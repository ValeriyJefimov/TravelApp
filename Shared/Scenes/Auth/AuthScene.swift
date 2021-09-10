//
//  AuthScene.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import SwiftUI

struct AuthSceneConstants {
    static var hPadding: CGFloat = 30
    static var vPadding: CGFloat = 15
    static var animationDuration: TimeInterval = 0.5
}

struct AuthScene: View, KeyboardReadable {
    @ObservedObject var viewModel = AuthSceneViewModel()
    
    //MARK: - Private
    @State private var isKeyboardVisible = false
    
    var body: some View {
        GeometryReader { metrics in
            let width = metrics.size.width
            let height = metrics.size.height
            
            VStack {
                AuthHeader(state: $viewModel.state)
                    .frame(minWidth: width * 2,
                           idealHeight: height * 0.3,
                           maxHeight: height * 0.4,
                           alignment: .center)
                    .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                    
                Spacer()
                HStack(alignment: .center, spacing: AuthSceneConstants.hPadding) {
                    SignUpView(state: $viewModel.state,
                               email: $viewModel.email,
                               password: $viewModel.password,
                               name: $viewModel.name,
                               shouldSubmit: {
                                print(viewModel.submit())
                               })
                        .onTapGesture {
                            changeAnimatable(state: .signUp)
                        }
                    
                    SignInView(state: $viewModel.state,
                               email: $viewModel.email,
                               password: $viewModel.password,
                               shouldSubmit: {
                                print(viewModel.submit())
                            })
                        .onTapGesture {
                            changeAnimatable(state: .signIn)
                        }
                }
                .padding([.leading, .trailing], AuthSceneConstants.hPadding / 2)
                .offset(CGSize(width: viewModel.state
                                .offset(with: AuthSceneConstants.hPadding, and: width),
                               height: -(metrics.safeAreaInsets.bottom + 20)))
                .frame(minWidth: width * 2 - AuthSceneConstants.hPadding)
            }
            .adaptsToKeyboard(prefferedRatio: 0.8)
        }
        .ignoresSafeArea(.keyboard)
        .alert(isPresented: viewModel.isPresentingAlert) {
            Alert(localizedError: viewModel.activeError!)
        }
    }
    
    func changeAnimatable(state newValue: AuthSceneViewModel.State) {
        withAnimation(.easeInOut(duration: AuthSceneConstants.animationDuration)) {
            viewModel.state = newValue
            hideKeyboard()
        }
    }
}

struct AuthScene_Previews: PreviewProvider {
    static var previews: some View {
        AuthScene()
            .preferredColorScheme(.light)
        AuthScene().preferredColorScheme(.dark).environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge).previewDevice("iPad Pro (12.9-inch) (5th generation)")
        
    }
}
