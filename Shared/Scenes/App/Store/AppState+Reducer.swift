//
//  AppState+Reducer.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/13/21.
//

import ComposableArchitecture

extension AppState {
    static let reducerCore = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
        switch action {
        
        //MARK: - App
        case .appDidFinishLaunching:
            return environment
                .authRepo
                .isUserLogged()
                .map(AppAction.userChecked)
            
        case .alertDissapears:
            state.alert = nil
            return .none
            
        case let .changeSelectedTab(newTab):
            state.selectedTab = newTab
            return .none
                        
        //MARK: - Home
        case let .home(.presentAlert(error)):
            state.alert = .init(title: TextState(error))
            return .none
            
        case .home(.logoutFinished):
            return .init(value: .userLogouted)
            
        case .home:
            return .none
            
            
        //MARK: - Auth
        case let .auth(.saveUserResult(.failure(error))):
            state.alert = .init(title: TextState(error.localizedDescription))
            return .none
            
        case let .auth(.saveUserResult(.success(result))):
            state.isUserLogged = true
            state.user = result
            state.homeState = HomeState(user: state.user!,
                                        categories: [],
                                        recommendations: [],
                                        isDataFetching: false)
            return .none
            
        case .auth:
            return .none
            
        case let .userChecked(isUserLogged):
            return isUserLogged
                ? environment
                .authRepo
                .currentUser()
                .catchToEffect()
                .map(AppAction.userFetched)
                : Effect.none
            
        case let .userFetched(.success(user)):
            state.isUserLogged = true
            state.user = user
            state.homeState = HomeState(user: state.user!,
                                        categories: [],
                                        recommendations: [],
                                        isDataFetching: false)
            return .none
            
        case .userFetched(.failure), .userLogouted:
            state.isUserLogged = false
            return .none
        }
    }
}

//MARK: - Combine
extension AppState {
    static let reducer = Reducer<AppState, AppAction, AppEnvironment>
        .combine(
            AppState.reducerCore,
            authReducer
                .optional()
                .pullback(
                    state: \.authState,
                    action: /AppAction.auth,
                    environment: { AuthEnvironment(authRepo: $0.authRepo) }
                ),
            homeReducer
                .optional()
                .pullback(state: \.homeState,
                          action: /AppAction.home,
                          environment: {
                            HomeEnvironment(
                                authRepo: $0.authRepo,
                                networkRepo: $0.networkRepo,
                                locationRepo: $0.locationRepo
                            )
                          }
                )
        )
}

