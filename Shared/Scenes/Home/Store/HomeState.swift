//
//  HomeState.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/17/21.
//

import ComposableArchitecture
import SwiftUI

struct HomeState: Equatable {
    var user: User
    
    var categories: [Category]
    var recommendations: [Venue]
    
    var isDataFetching: Bool
    var showImagePicker: Bool = false
        
    var optionSheet: ActionSheetState<HomeAction>?
    
    var categoryList: CategoryListState?
    
    var searchState: SearchState?
}
