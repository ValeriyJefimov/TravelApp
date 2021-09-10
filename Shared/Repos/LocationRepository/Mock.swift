//
//  Mock.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/31/21.
//

import ComposableArchitecture
import CoreLocation
import Combine

extension LocationRepository {
  public static var authorizedWhenInUse: Self {
    let subject = PassthroughSubject<DelegateEvent, Never>()

    return Self(
      authorizationStatus: { .authorizedWhenInUse },
      requestWhenInUseAuthorization: { },
      requestLocation: {
        subject.send(.didUpdateLocations([CLLocation()]))
      },
      delegate: subject.eraseToEffect()
    )
  }

  public static var notDetermined: Self {
    var status = CLAuthorizationStatus.notDetermined
    let subject = PassthroughSubject<DelegateEvent, Never>()

    return Self(
      authorizationStatus: { status },
      requestWhenInUseAuthorization: {
        status = .authorizedWhenInUse
        subject.send(.didChangeAuthorization(status))
      },
      requestLocation: {
        subject.send(.didUpdateLocations([CLLocation()]))
      },
      delegate: subject.eraseToEffect()
    )
  }
}
