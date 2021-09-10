//
//  SearchState.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/2/21.
//

import ComposableArchitecture
import SwiftUI

struct SearchState: Equatable {
    var searchText: String
    
    var results: IdentifiedArrayOf<Venue> 
}

extension SearchState {
    static let live = SearchState(
        searchText: "",
        results: []
    )
}
