//
//  Coordinates.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/15/21.
//

import CoreLocation
import ComposableCoreLocation
import MapKit.MKGeometry

struct LocationManagerId: Hashable {}

struct MapSpan: Equatable {
    var latitudeDelta: Double
    var longitudeDelta: Double
    
    static var `default`: MapSpan = .init(latitudeDelta: 0.005, longitudeDelta: 0.005)
}

extension MapSpan {
    init(span: MKCoordinateSpan) {
        self.latitudeDelta = span.latitudeDelta
        self.longitudeDelta = span.longitudeDelta
    }
}

extension Location {
    static var `default`: Location = .init(rawValue: CLLocation(
                                            latitude: 51.507222,
                                            longitude: -0.1275)
    )
}

struct MapRegion: Equatable {
    var location: Location
    var span: MapSpan
    
    static var `default`: MapRegion = .init(
        location: .default,
        span: .default
    )
}

extension MapRegion {
    init(region: MKCoordinateRegion) {
        self.location = .init(
            rawValue: .init(latitude: region.center.latitude,
                            longitude: region.center.longitude)
        )
        self.span = .init(span: region.span)
    }
    
    var radius: Double {
        let loc1 = CLLocation(latitude: location.coordinate.latitude - span.latitudeDelta * 0.5, longitude: location.coordinate.longitude)
        let loc2 = CLLocation(latitude: location.coordinate.latitude + span.latitudeDelta * 0.5, longitude: location.coordinate.longitude)
        let loc3 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude - span.longitudeDelta * 0.5)
        let loc4 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude + span.longitudeDelta * 0.5)
        
        let metersInLatitude = loc1.distance(from: loc2)
        let metersInLongitude = loc3.distance(from: loc4)
        return max(metersInLatitude, metersInLongitude)
    }
}
