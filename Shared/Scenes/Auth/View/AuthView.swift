//
//  AuthScene.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/12/21.
//

import SwiftUI
import ComposableArchitecture

struct AuthViewConstants {
    static let hPadding: CGFloat = 30
    static let vPadding: CGFloat = 15
    static let animationDuration: TimeInterval = 0.5
}

fileprivate extension AuthState.Position {
    func offset(with padding: CGFloat, and size: CGFloat = 0) -> CGFloat {
        switch self {
        case .signUp:
            return 0
        case .initial:
            return -size / 2
        case .signIn:
            return -size
        }
    }
}

struct AuthView: View {
    let store: Store<AuthState, AuthAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            GeometryReader { metrics in
                let width = metrics.size.width
                let height = metrics.size.height
                
                VStack {
                    AuthHeader(state:
                                viewStore.binding(
                                    get: \.position,
                                    send: AuthAction.positionChanged
                                ),
                               isKeyboardVisible:
                                viewStore.binding(
                                    get: \.isKeyboardVisible,
                                    send: AuthAction.keyboardVisibilityChanged
                                )
                    )
                    .frame(minWidth: width * 2,
                           idealHeight: height * 0.3,
                           maxHeight: height * 0.4,
                           alignment: .center)
                    .animation(.easeInOut(duration: AuthViewConstants.animationDuration)).foregroundColor(.red)
                    
                    Spacer()
                    HStack(alignment: .center, spacing: AuthViewConstants.hPadding) {
                        SignUpView(
                            state: viewStore.binding(
                                get: \.position,
                                send: AuthAction.positionChanged
                            ),
                            email: viewStore.binding(
                                get: \.email,
                                send: AuthAction.emailChanged
                            ),
                            password: viewStore.binding(
                                get: \.pass,
                                send: AuthAction.passwordChanged
                            ),
                            name: viewStore.binding(
                                get: \.name,
                                send: AuthAction.nameChanged
                            ),
                            isKeyboardVisible: viewStore.binding(
                                get: \.isKeyboardVisible,
                                send: AuthAction.keyboardVisibilityChanged
                            ),
                            shouldSubmit: {
                                viewStore.send(.signUpRequest)
                            })
                            .foregroundColor(.blue)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: AuthViewConstants.animationDuration)) {
                                    viewStore.send(.positionChanged(.signUp))
                                    hideKeyboard()
                                }
                            }
                        
                        SignInView(
                            state: viewStore.binding(
                                get: \.position,
                                send: AuthAction.positionChanged
                            ),
                            email: viewStore.binding(
                                get: \.email,
                                send: AuthAction.emailChanged
                            ),
                            password: viewStore.binding(
                                get: \.pass,
                                send: AuthAction.passwordChanged
                            ),
                            isKeyboardVisible: viewStore.binding(
                                get: \.isKeyboardVisible,
                                send: AuthAction.keyboardVisibilityChanged
                            ),
                            shouldSubmit: {
                                viewStore.send(.signInRequest)
                            })
                            .foregroundColor(.green)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: AuthViewConstants.animationDuration)) {
                                    viewStore.send(.positionChanged(.signIn))
                                    hideKeyboard()
                                }
                            }
                    }
                    .padding([.leading, .trailing], AuthViewConstants.hPadding / 2)
                    .offset(CGSize(width: viewStore.position
                                    .offset(with: AuthViewConstants.hPadding, and: width),
                                   height: -(metrics.safeAreaInsets.bottom + 20)))
                    .frame(minWidth: width * 2 - AuthViewConstants.hPadding)
                }
                .adaptsToKeyboard(prefferedRatio: 0.85)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
