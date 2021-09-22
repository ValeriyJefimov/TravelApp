//
//  MapAction.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/14/21.
//

import ComposableArchitecture
import MapKit
import ComposableCoreLocation

enum MapAction: Equatable {
    case didAppear
    
    case locationManager(LocationManager.Action)
    
    case regionChanged(MapRegion)
    
    case requestVenues
    case venuesLoaded(Result<SearchResult, NetworkError>)

    case presentAlert(String)
    
    case venue(VenueRowAction)
    
    case venueSelected(Venue)
    
    case searchButtonVisibilityChanged(Bool)
}



