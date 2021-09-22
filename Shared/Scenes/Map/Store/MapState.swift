//
//  MapState.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/14/21.
//

import ComposableArchitecture
import CoreLocation.CLLocation

struct MapState: Equatable {
    var currentRegion: MapRegion
    var selectedVenue: Venue?
    var results: IdentifiedArrayOf<Venue>
    var searchButtonVisibility: Bool = false
}

extension MapState {
    static let live = MapState(
        currentRegion: .default,
        results: []
    )
}

extension Venue.Location {
    var clLocation: CLLocation {
        return .init(latitude: lat, longitude: lng)
    }
}
