//
//  SignUpView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import SwiftUI

struct SignUpView: View, KeyboardReadable {
    
    @Binding var state: AuthSceneViewModel.State
    @Binding var email: String
    @Binding var password: String
    @Binding var name: String
    
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
                    Text("Sign Up")
                        .foregroundColor(.mainCyan)
                        .frame(width: metrics.size.width - AuthSceneConstants.hPadding, alignment: state == .signUp ? .center : .trailing)
                        .padding()
                        .font(.system(size: 30, weight: .thin))
                        .opacity(isKeyboardVisible ? 0 : 1)
                        .animation(.easeInOut(duration: 0.5))
                    ZStack {
                        VStack {
                            Spacer()
                            
                            FloatingTextField(placeHolder: "Name", text: $name)
                                .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                                .padding([.leading, .trailing], 15)
                            
                            FloatingTextField(placeHolder: "E-mail", text: $email)
                                .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                                .padding([.leading, .trailing], 15)
                            
                            FloatingSecureField(placeHolder: "Password", text: $password)
                                .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                                .padding([.leading, .trailing], 15)
                            
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
                            .opacity(state == .signUp ? 1 : 0)
                            .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                            
                            Spacer()
                        }
                        .opacity(state == .signUp ? 1 : 0)
                        .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                        
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("New here?\n\nDon’t worry\njust sign up to\ngain access to\nthis amazing\napp")
                                    .foregroundColor(.mainCyan)
                                    .multilineTextAlignment(.trailing)
                                    .font(.system(size: 17, weight: .thin))
                                    .animation(.easeInOut(duration: AuthSceneConstants.animationDuration))
                                Spacer()
                            }
                        }
                        .padding()
                        .opacity(state != .signUp ? 1 : 0)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.1))
            .frame(width: metrics.size.width,
                   height: metrics.size.height,
                   alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        .onReceive(keyboardVisibility) { isKeyboardVisible = $0 }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(state: .constant(.initial), email: .constant(""), password: .constant(""), name: .constant(""), shouldSubmit: {})
            .previewDevice("iPod touch (7th generation)")
    }
}
