//
//  SearchState+Reducer.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import ComposableArchitecture
import Combine

let searchReducerCore = Reducer<SearchState, SearchAction, SearchEnvironment> { state, action, env in
    switch action {
    case let .searchTextChanged(text):
        struct SearchLocationId: Hashable {}
        state.searchText = text
        
        let reducedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !reducedText.isEmpty else {
            state.results = []
            return .none
        }
        
        return .init(value: .requestLocation)
            .debounce(id: SearchLocationId(),
                      for: 0.5,
                      scheduler: env.mainQueue)
    case .searchEnded:
        return .none
        
    case .loadResults:
        return .none
        
    case let .resultsLoaded(.failure(error)):
        state.results.removeAll()
        return .init(value: .presentAlert(error.localizedDescription))
        
    case let .resultsLoaded(.success(result)):
        state.results.removeAll()
        result.response?.venues.forEach { state.results.append($0) }
        return .none
        
    case .requestLocation:
        return env.locationRepo
            .requestLocation(id: LocationManagerId())
            .fireAndForget()
        
    case let .locationManager(.didUpdateLocations(locations)):
        return env
            .networkRepo
            .run(SearchRequest(query: state.searchText, location: locations.first!))
            .catchToEffect()
            .map(SearchAction.resultsLoaded)
        
    case .locationManager:
        return .none
        
    case .presentAlert:
        return .none
        
    case .venueRow:
      return .none
    }
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment>
    .combine(
        venueRowReducer.forEach(
            state: \.results,
            action: /SearchAction.venueRow(id:action:),
            environment: { _ in VenueRowEnvironment() }
        ),
        searchReducerCore
    )
    .lifecycle()
