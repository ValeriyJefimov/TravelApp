//
//  AuthAction.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/13/21.
//

import ComposableArchitecture

enum AuthAction: Equatable {
    case positionChanged(AuthState.Position)
    
    case signInRequest
    case signUpRequest
    
    case emailChanged(String)
    case passwordChanged(String)
    case nameChanged(String)
    
    case keyboardVisibilityChanged(Bool)
    
    case saveUserResult(Result<User, AuthError>)
}
