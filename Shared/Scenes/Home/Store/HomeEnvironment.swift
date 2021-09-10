//
//  HomeEnvironment.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/17/21.
//

import ComposableArchitecture

struct HomeEnvironment {
    let authRepo: AuthRepository
    let networkRepo: NetworkRepository
    let locationRepo: LocationRepository
}
