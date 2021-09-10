//
//  SignInView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import SwiftUI

struct SignInView: View, KeyboardReadable {
    
    //MARK: - Public
    @Binding var state: AuthSceneViewModel.State
    @Binding var email: String
    @Binding var password: String
    
    var shouldSubmit: () -> Void
    
    //MARK: - Private
    
    @State private var isKeyboardVisible = false
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                Rectangle()
                    .modifier(Card())
                    .animation(.easeInOut(duration: 0.5))
                
                VStack {
                    Spacer(minLength: 30)
                    Text("Sign In")
                        .foregroundColor(.mainCyan)
                        .frame(width: metrics.size.width - AuthSceneConstants.hPadding, alignment: state == .signIn ? .center : .leading)
                        .padding()
                        .font(.system(size: 30, weight: .thin))
                        .opacity(isKeyboardVisible ? 0 : 1)
                        .animation(.easeInOut(duration: 0.5))
                    ZStack {
                        VStack {
                            Spacer()
                            
                            FloatingTextField(placeHolder: "E-mail", text: $email)
                                .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                                .padding([.leading, .trailing], 15)
                            
                            FloatingSecureField(placeHolder: "Password", text: $password)
                                .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                                .padding([.leading, .trailing, .top], 15)
                            
                            Spacer()
                            
                            Button(action: {
                                shouldSubmit()
                            }, label: {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 22))
                                    .clipped()
                                    .frame(width: 44, height: 44, alignment: .center)
                                    .foregroundColor(.mainCyan)
                                    .overlay(RoundedRectangle(cornerRadius: 44)
                                                .stroke(Color.mainCyan, lineWidth: 1))
                                    .minimumScaleFactor(0.5)
                            })
                            .opacity(state == .signIn ? 1 : 0)
                            .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                            
                            Spacer()
                        }
                        .opacity(state == .signIn ? 1 : 0)
                        .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Returning?\n\nJust Sign in to\nresume what\nyou were\ndoing")
                                    .foregroundColor(.mainCyan)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 17, weight: .thin))
                                    .opacity(state == .signIn ? 0 : 1)
                                    .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                                
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding()
                        .opacity(state != .signIn ? 1 : 0)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.1))
            .frame(width: metrics.size.width,
                   height: metrics.size.height * 0.8,
                   alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .onReceive(keyboardVisibility) { isKeyboardVisible = $0 }
    }
}
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(state: .constant(.signIn), email: .constant(""), password: .constant(""), shouldSubmit: {})
            .previewDevice("iPod touch (7th generation)")
        SignInView(state: .constant(.initial), email: .constant(""), password: .constant(""), shouldSubmit: {})
            .previewDevice("iPod touch (7th generation)")
    }
}
