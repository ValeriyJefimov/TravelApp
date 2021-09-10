//
//  AppAction.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/13/21.
//

import SwiftUI
import ComposableArchitecture

enum AppAction: Equatable {
    case appDidFinishLaunching
    
    case auth(AuthAction)
    case home(HomeAction)
    
    case userChecked(Bool)
    case userFetched(Result<User, AuthError>)
    case userLogouted
        
    case alertDissapears
    
    case changeSelectedTab(AppTab)
}

