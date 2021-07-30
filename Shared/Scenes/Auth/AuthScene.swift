//
//  AuthScene.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import SwiftUI

struct AuthSceneConstants {
    static var hPadding: CGFloat = 30
}

struct AuthScene: View {
    
    @ObservedObject var viewModel = AuthSceneViewModel()
    
    var body: some View {
        GeometryReader { metrics in
            let width = metrics.size.width
            let height = metrics.size.height
            
            VStack {
                AuthHeader(state: $viewModel.state)
                    .frame(minWidth: width * 2 - AuthSceneConstants.hPadding,
                           idealHeight: height * 0.3,
                           maxHeight: height * 0.4,
                           alignment: .leading)
                
                HStack(alignment: .center, spacing: AuthSceneConstants.hPadding) {
                    SignUpView()
                        .onTapGesture {
                            changeAnimatable(state: .signUp)
                        }
                    
                    SignInView(state: $viewModel.state,
                               email: $viewModel.email,
                               password: $viewModel.password)
                        .onTapGesture {
                            changeAnimatable(state: .signIn)
                        }
                }
                .padding([.leading, .trailing], AuthSceneConstants.hPadding)
                .offset(CGSize(width: viewModel.state
                                .offset(with: AuthSceneConstants.hPadding, and: width),
                               height: -(metrics.safeAreaInsets.bottom + 20)))
                .frame(minWidth: width * 2 - AuthSceneConstants.hPadding)
                
                
            }
        }
    }
    
    func changeAnimatable(state newValue: AuthSceneViewModel.State) {
        withAnimation(.easeInOut(duration: 0.5)) {
            viewModel.state = newValue
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
