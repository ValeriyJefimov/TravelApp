//
//  AuthState.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/13/21.
//

import ComposableArchitecture
import SwiftUI

struct AuthState: Equatable {
    enum Position {
        case initial
        case signUp
        case signIn
    }
    
    var name: String
    var pass: String
    var email: String
    var position: Position
    var isKeyboardVisible: Bool
    
    init(user: User?, position: Position = .initial, isKeyboardVisible: Bool) {
        self.name = user?.name ?? ""
        self.pass = user?.pass ?? ""
        self.email = user?.email ?? ""
        self.position = position
        self.isKeyboardVisible = isKeyboardVisible
    }
}
