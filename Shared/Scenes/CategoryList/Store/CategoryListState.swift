//
//  CategoryListState.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/7/21.
//

import ComposableArchitecture

struct CategoryListState: Equatable {
    let name: String
    let categoryId: String
    var venues: IdentifiedArrayOf<Venue>
}

extension CategoryListState {
    init(category: Category) {
        self.name = category.shortName
        self.venues = []
        self.categoryId = category.id
    }
}

extension CategoryListState {
    static let mock = CategoryListState(
        name: Category.mock.shortName,
        categoryId: Category.mock.id,
        venues: [.mock]
    )
}
