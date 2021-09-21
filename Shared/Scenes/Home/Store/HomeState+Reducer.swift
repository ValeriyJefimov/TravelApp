//
//  HomeState+Reducer.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/17/21.
//

import ComposableArchitecture
import Combine

let homeReducerCore = Reducer<HomeState, HomeAction, HomeEnvironment> { state, action, env in
    switch action {
        
    case let .downloadRecommendations(location):
        return .none
        return env.networkRepo
            .run(RecommendationsRequest(location: location))
            .catchToEffect()
            .map(HomeAction.downloadRecommendationsResult)
        
    case let .downloadRecommendationsResult(.success(result)):
        let ids = result.response?
            .groups
            .flatMap { $0.items }
            .map { $0.venue.id } ?? []
        
        let effects = ids.map { id -> Effect<Venue, NetworkError> in
            let result: Effect<VenueResult, NetworkError> = env
                .networkRepo
                .run(VenueRequest(id: id))
            return result
                .map { $0.response?.venue }
                .compactMap { $0 }
                .eraseToEffect()
        }
        
        return Publishers
            .MergeMany(effects)
            .collect()
            .eraseToAnyPublisher()
            .catchToEffect()
            .map(HomeAction.downloadVenueResult)
        
    case let .downloadVenueResult(.success(venues)):
        state.recommendations = venues
        state.isDataFetching = false
        return .none
        
    //MARK: - Location
    case .requestLocationPermission:
        switch env.locationRepo.authorizationStatus() {
        case .notDetermined:
            return env.locationRepo
                .requestLocation(id: LocationManagerId())
                .fireAndForget()
        case .restricted, .denied:
            return .init(value: .presentAlert(LocationError.notAuthorized.localizedDescription))
        case .authorizedAlways, .authorizedWhenInUse:
            return .init(value: .requestLocation)
        @unknown default:
            return .none
        }
        
    case .requestLocation:
        return env.locationRepo
            .requestLocation(id: LocationManagerId())
            .fireAndForget()
        
    case .locationManager(.didChangeAuthorization(.authorizedWhenInUse)):
        return .init(value: .requestLocation)
        
    case .locationManager(.didChangeAuthorization(.denied)),
         .locationManager(.didChangeAuthorization(.restricted)):
        return .init(value: .presentAlert(LocationError.notAuthorized.localizedDescription))
        
    case let .locationManager(.didUpdateLocations(locations)):
        guard let location = locations.first else {
            return .none
        }
        state.currentLocation = .init(location)
        return .init(value: .downloadRecommendations(locations.first!))
        
    case .locationManager:
        return .none
        
    case let .presentAlert(error):
        return .none

    case .presentOptionSheet:
        state.optionSheet = ActionSheetState(
            title: TextState("Options"),
            buttons: [
                .default(TextState("Add Photo"), send: .presentImagePicker),
                .destructive(TextState("Logout"), send: .logout),
                .cancel()
            ]
        )
        return .none
        
    case .dissmissOptionSheet:
        state.optionSheet = nil
        return .none
        
    case .logout:
        return env
            .authRepo
            .logout()
            .catchToEffect()
            .map { _ in HomeAction.logoutFinished }

    case .logoutFinished:
        return .none
        
    case let .addPhoto(image):
        state.user.profileImage = image
        return env
            .authRepo
            .saveUser(state.user)
            .catchToEffect()
            .map { _ in HomeAction.photoAdded }
        
    case .photoAdded:
        return .none
        
    case .presentImagePicker:
        state.showImagePicker = true
        return .none
        
    case .dissmissImagePicker:
        state.showImagePicker = false
        return .none
        
    //MARK: - Search
    case .startSearch:
        state.searchState = .live
        return .none
        
    case .search(.action(.searchEnded)):
        state.searchState = nil
        return .none
        
    case let .search(.action(.presentAlert(error))):
        return .init(value: .presentAlert(error))
        
    case .search:
        return .none
        
    //MARK: - Categories
    case .downloadCategories:
        state.isDataFetching = true
        return env.networkRepo
            .run(CategoriesRequest())
            .catchToEffect()
            .map(HomeAction.downloadCategoriesResult)
        
    case let .downloadCategoriesResult(.success(result)):
        state.isDataFetching = false
        state.categories = result.response?.categories ?? []
        return .none
        
    case .downloadCategoriesResult(.failure):
        state.categories = []
        state.isDataFetching = false
        return .none
        
    case .downloadRecommendationsResult(.failure),
         .downloadVenueResult(.failure):
        state.recommendations = []
        state.isDataFetching = false
        return .none
        
    case let .showCategory(category):
        guard let location = state.currentLocation else { return .none }
        state.categoryList = CategoryListState(category: category, location: location)
        return .none
        
    case .category(.action(.dissmiss)):
        state.categoryList = nil
        return .none
        
    case .category:
        return .none
    }
}

let homeReducer = Reducer
    .combine(
        searchReducer
            .pullback(state: \.searchState,
                      action: /HomeAction.search,
                      environment: {
                        SearchEnvironment(
                            networkRepo: $0.networkRepo,
                            locationRepo: $0.locationRepo,
                            mainQueue: .main
                        )
                      }
            ),
        categoryListReducer
            .pullback(state: \.categoryList,
                      action: /HomeAction.category,
                      environment: {
                        CategoryListEnvironment(
                            networkRepo: $0.networkRepo,
                            mainQueue: .main
                        )
                      }
            ),
        homeReducerCore
    )
