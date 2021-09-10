//
//  HomeAction.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/17/21.
//

import ComposableArchitecture
import CoreLocation
import UIKit.UIImage

enum HomeAction: Equatable {
    
    case downloadCategories
    case downloadCategoriesResult(Result<CategoriesResult, NetworkError>)
    
    case requestLocationPermission
    case requestLocationPermissionResult(Result<CLAuthorizationStatus, LocationError>)
    
    case requestLocation
    case requestLocationResult(Result<CLLocation, LocationError>)
    
    case downloadRecommendations(CLLocation)
    case downloadRecommendationsResult(Result<RecommendationsResult, NetworkError>)
    
    case downloadVenueResult(Result<[Venue], NetworkError>)
    
    case presentAlert(String)
    
    case presentOptionSheet
    case dissmissOptionSheet
    
    case logout
    case logoutFinished
    
    case presentImagePicker
    case dissmissImagePicker
    
    case addPhoto(UIImage)
    case photoAdded
    
    case startSearch
    case search(SearchAction)
    
    case showCategory(Category)
    case category(CategoryListAction)
    case dissmissCategory
}

