//
//  SearchAction.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import ComposableArchitecture
import CoreLocation

enum SearchAction: Equatable {
    case searchTextChanged(String)
    case searchEnded
    
    case loadResults
    case resultsLoaded(Result<SearchResult, NetworkError>)
    
    case requestLocation
    case requestLocationResult(Result<CLLocation, LocationError>)
    
    case presentAlert(String)
    
    case venueRow(id: Venue.ID, action: VenueRowAction)

}


