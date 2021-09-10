//
//  LocationRepository.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/31/21.
//

import CoreLocation
import ComposableArchitecture

public struct LocationRepository {
    public var authorizationStatus: () -> CLAuthorizationStatus
    public var requestWhenInUseAuthorization: () -> Void
    public var requestLocation: () -> Void
    public var delegate: Effect<DelegateEvent, Never>
    
    public init(
        authorizationStatus: @escaping () -> CLAuthorizationStatus,
        requestWhenInUseAuthorization: @escaping () -> Void,
        requestLocation: @escaping () -> Void,
        delegate: Effect<DelegateEvent, Never>
    ) {
        self.authorizationStatus = authorizationStatus
        self.requestWhenInUseAuthorization = requestWhenInUseAuthorization
        self.requestLocation = requestLocation
        self.delegate = delegate
    }
    
    public enum DelegateEvent {
        case didChangeAuthorization(CLAuthorizationStatus)
        case didUpdateLocations([CLLocation])
        case didFailWithError(Error)
    }
}
