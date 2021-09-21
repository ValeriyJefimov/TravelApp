//
//  CategoryListAction.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/7/21.
//

import ComposableArchitecture

enum CategoryListAction: Equatable {
    case loadCategories
    case categoriesLoaded(Result<SearchResult, NetworkError>)
    
    case presentAlert(String)
    
    case venueRow(id: Venue.ID, action: VenueRowAction)
    
    case dissmiss

}


