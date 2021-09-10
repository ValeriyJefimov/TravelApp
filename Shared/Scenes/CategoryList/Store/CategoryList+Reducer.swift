//
//  CategoryList+Reducer.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/7/21.
//

import ComposableArchitecture

let categoryListReducer = Reducer<CategoryListState, CategoryListAction, CategoryListEnvironment> { state, action, env in
    switch action {
  
    case .venuesLoaded(_):
        return .none
        
    case .presentAlert:
        return .none
        
    case .dissmiss:
        return .none
    }
}
.lifecycle(onDisappear:  { env in
    //load venues here
    return .none
})

