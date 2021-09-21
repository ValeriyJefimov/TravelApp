//
//  Map+Reducer.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/14/21.
//

import ComposableArchitecture
import Combine

let mapReducerCore = Reducer<MapState, MapAction, MapEnvironment> { state, action, env in
    switch action {
    case .didAppear:
        return .merge(
            env.locationRepo
                .create(id: LocationManagerId())
                .map(MapAction.locationManager),
            
            env.locationRepo
                .requestLocation(id: LocationManagerId())
                .fireAndForget()
        )
        
    case let .regionChanged(region):
        state.currentRegion = region
        return .none
        
    case .requestVenues:
        struct RegionId: Hashable {}
        return env.networkRepo
            .run(SearchRequest(region: state.currentRegion))
            .debounce(id: RegionId(),
                      for: 0.5,
                      scheduler: env.mainQueue)
            .catchToEffect()
            .map(MapAction.venuesLoaded)
        
    case let .venuesLoaded(.failure(error)):
        state.results.removeAll()
        return .init(value: .presentAlert(error.localizedDescription))
        
    case let .venuesLoaded(.success(result)):
        state.results.removeAll()
        result.response?.venues.forEach { state.results.append($0) }
        return .none
        
    case .presentAlert:
        return .none
        
    case .venue:
        return .none
        
    case let .venueSelected(venue):
        state.selectedVenue = venue
        return .none
        
    case .locationManager(.didChangeAuthorization(.denied)):
        return .init(value: .presentAlert(LocationError.notAuthorized.localizedDescription))
        
    case let .locationManager(.didUpdateLocations(locations)):
        let regionChanged = Effect<MapAction, Never>
            .init(value:
                    .regionChanged(
                        .init(
                            location: locations.first!,
                            span: .default)
                    )
            )
        return .concatenate(regionChanged, .init(value: .requestVenues))
        
    case .locationManager:
        return .none
    }
}

let mapReducer = Reducer<MapState, MapAction, MapEnvironment>
    .combine(
        venueRowReducer
            .optional()
            .pullback(state: \.selectedVenue,
                      action: /MapAction.venue,
                      environment: { _ in VenueRowEnvironment() }),
        mapReducerCore
    ).debugActions()
