//
//  HomeEnvironment.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/17/21.
//

import ComposableArchitecture
import ComposableCoreLocation

struct HomeEnvironment {
    let authRepo: AuthRepository
    let networkRepo: NetworkRepository
    let locationRepo: LocationManager
}
