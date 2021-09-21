//
//  CategoryList+Reducer.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/7/21.
//

import ComposableArchitecture

let categoryListReducer = Reducer<CategoryListState, CategoryListAction, CategoryListEnvironment> { state, action, env in
    switch action {
    case .loadCategories:
        return env.networkRepo
            .run(SearchRequest(categoryId: state.categoryId, location: state.currentLocation))
            .catchToEffect()
            .map(CategoryListAction.categoriesLoaded)
    case let .categoriesLoaded(.success(result)):
        state.venues.removeAll()
        result.response?.venues.forEach {
            state.venues.append($0)
        }
        return .none
        
    case let .categoriesLoaded(.failure(error)):
        return .init(value: .presentAlert(error.localizedDescription))
        
    case .presentAlert:
        return .none
        
    case .dissmiss:
        return .none
        
    case let .venueRow(_, action: .didSelect(venue)):
        print(venue)
        return .none
    }
}
.lifecycle()

