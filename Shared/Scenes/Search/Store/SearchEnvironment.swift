//
//  SearchEnvironment.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import Foundation
import ComposableCoreLocation
import ComposableArchitecture

struct SearchEnvironment {
    let networkRepo: NetworkRepository
    let locationRepo: LocationManager
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension SearchEnvironment {
    static let mock = SearchEnvironment(networkRepo: .live,
                                        locationRepo: .notDetermined,
                                        mainQueue: .main)
}
