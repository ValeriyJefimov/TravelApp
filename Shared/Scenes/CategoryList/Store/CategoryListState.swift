//
//  CategoryListState.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/7/21.
//

import ComposableArchitecture
import ComposableCoreLocation

struct CategoryListState: Equatable {
    let name: String
    let categoryId: String
    var venues: IdentifiedArrayOf<Venue>
    let currentLocation: Location
}

extension CategoryListState {
    init(category: Category, location: Location) {
        self.name = category.shortName
        self.venues = []
        self.categoryId = category.id
        self.currentLocation = location
    }
}

extension CategoryListState {
    static let mock = CategoryListState(
        name: Category.mock.shortName,
        categoryId: Category.mock.id,
        venues: [.mock],
        currentLocation: .default
    )
}
