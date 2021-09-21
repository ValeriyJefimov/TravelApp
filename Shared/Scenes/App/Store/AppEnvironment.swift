//
//  AppEnvironment.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/13/21.
//

import ComposableCoreLocation
struct AppEnvironment {
    let authRepo: AuthRepository = .live
    let networkRepo: NetworkRepository = .live
    let locationRepo: LocationManager = .live
}
