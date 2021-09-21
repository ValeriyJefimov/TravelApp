//
//  AppState.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/13/21.
//

import SwiftUI
import ComposableArchitecture

enum AppTab: Int {
    case home, map, favorites
}

struct AppState: Equatable {
    var alert: AlertState<AppAction>?
    
    var authState: AuthState?
    var homeState: HomeState?

    var user: User?
    var isUserLogged: Bool
    
    var isKeyboardVisible: Bool
    
    var selectedTab: AppTab
    
    var mapState: MapState
}

extension AppState {
    static let initial: Self = .init(
        alert: nil,
        authState: AuthState(user: nil, isKeyboardVisible: false),
        homeState: nil,
        user: nil,
        isUserLogged: false,
        isKeyboardVisible: false,
        selectedTab: .home,
        mapState: .live
    )
}
