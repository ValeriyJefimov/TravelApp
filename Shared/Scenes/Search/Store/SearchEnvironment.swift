//
//  SearchEnvironment.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import Foundation
import ComposableArchitecture

struct SearchEnvironment {
    let networkRepo: NetworkRepository
    let locationRepo: LocationRepository
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension SearchEnvironment {
    static let mock = SearchEnvironment(networkRepo: .live,
                                        locationRepo: .authorizedWhenInUse,
                                        mainQueue: .main)
}
