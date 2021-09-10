//
//  AuthHeader.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/16/21.
//

import SwiftUI

struct AuthHeader: View {
        
    //MARK: - Public
    @Binding var state: AuthState.Position
    @Binding var isKeyboardVisible: Bool
    
    var body: some View {
        GeometryReader { metrics in
            let cardSize = CGSize(width: (metrics.size.width) / 2,
                                  height: metrics.size.height)
            let cardVOffset: CGFloat = {
                switch state {
                case .initial:
                    return -(cardSize.width) - AuthViewConstants.hPadding / 2
                case .signUp:
                    return -AuthViewConstants.hPadding / 4
                case .signIn:
                    return -(cardSize.width * 2) - AuthViewConstants.hPadding / 2
                }
            }()
            
            HStack {
                VStack(spacing: 20) {
                    BackButton(state: $state)
                    Text("Wellcome Back!")
                        .modifier(AuthSceneHeaderTitle())
                }
                .modifier(HeaderSize(size: cardSize, vOffset: cardVOffset))
                .padding(.bottom, 40)
                .opacity(isKeyboardVisible ? 0 : 1)
                
                Text("Hello!")
                    .modifier(AuthSceneHeaderTitle())
                    .modifier(HeaderSize(size: cardSize, vOffset: cardVOffset))
                    .opacity(isKeyboardVisible ? 0 : 1)
                
                VStack(spacing: 20) {
                    BackButton(state: $state)
                    Text("Welcome!")
                        .modifier(AuthSceneHeaderTitle())
                        .opacity(isKeyboardVisible ? 0 : 1)
                }
                .modifier(HeaderSize(size: cardSize, vOffset: cardVOffset))
                .padding(.bottom, 40)
            }
        }
    }
}

extension AuthHeader {
    struct HeaderSize: ViewModifier {
        
        let size: CGSize
        let vOffset: CGFloat
        
        func body(content: Content) -> some View {
            content
                .frame(width: size.width,
                       height: size.height,
                       alignment: .center)
                .offset(x: vOffset, y: 0)
        }
    }
    
    struct AuthSceneHeaderTitle: ViewModifier {
        
        private let font = Font.system(size: 50).weight(.light)
        
        func body(content: Content) -> some View {
            content
                .foregroundColor(.mainCyan)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .font(font)
                .padding()
                .minimumScaleFactor(0.4)
        }
    }
    
    struct BackButton: View {
        @Binding var state: AuthState.Position
        
        var body: some View {
            Button(action: {
                hideKeyboard()
                withAnimation(.easeInOut(duration: AuthViewConstants.animationDuration)) {
                    state = .initial
                }
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 22))
                    .clipped()
                    .frame(width: 44, height: 44, alignment: .center)
                    .background(Color.mainCyan)
                    .cornerRadius(44).foregroundColor(.white)
            })
        }
    }
}
