//
//  AuthState+Reducer.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/13/21.
//

import ComposableArchitecture

let authReducer = Reducer<AuthState, AuthAction, AuthEnvironment> { state, action, env in
    switch action {
    case let .positionChanged(position):
        state.position = position
        return .none
    case .signInRequest, .signUpRequest:
        return env
            .authRepo
            .saveUser(
                User(
                    name: state.name,
                    pass: state.pass,
                    email: state.email
                )
            )
            .catchToEffect()
            .map(AuthAction.saveUserResult)
    case .saveUserResult:
        return .none
    case let .emailChanged(email):
        state.email = email
        return .none
    case let .passwordChanged(pass):
        state.pass = pass
        return .none
    case let .nameChanged(name):
        state.name = name
        return .none
    case let .keyboardVisibilityChanged(visibility):
        state.isKeyboardVisible = visibility
        return .none
    }
}
