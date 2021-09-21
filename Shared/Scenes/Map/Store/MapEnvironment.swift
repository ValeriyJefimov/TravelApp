//
//  MapEnvironment.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/14/21.
//

import Foundation
import ComposableArchitecture
import ComposableCoreLocation

struct MapEnvironment {
    let networkRepo: NetworkRepository
    var locationRepo: LocationManager
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension MapEnvironment {
    static let mock = SearchEnvironment(networkRepo: .live,
                                        locationRepo: .notDetermined,
                                        mainQueue: .main)
}
