//
//  CategoryListEnvironment.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/7/21.
//

import ComposableArchitecture

struct CategoryListEnvironment {
    let networkRepo: NetworkRepository
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension CategoryListEnvironment {
    static let mock = CategoryListEnvironment(networkRepo: .live,
                                              mainQueue: .main)
}

