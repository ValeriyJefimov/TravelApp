//
//  SignInView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import SwiftUI

struct SignInView: View {
    
    //MARK: - Public
    @Binding var state: AuthSceneViewModel.State
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                Rectangle()
                    .modifier(Card())
                VStack {
                    FloatingTextField(placeHolder: "E-mail", text: $email)
                        .opacity(state == .signIn ? 1 : 0)
                        .animation(.easeInOut(duration: state == .signIn ? 0.5 : 0.1)
                                    .delay(state == .signIn ? 0.2 : 0))
                        .padding([.leading, .trailing], 15)
                    
                    FloatingTextField(placeHolder: "Password", isSequre: false, text: $password)
                        .opacity(state == .signIn ? 1 : 0)
                        .animation(.easeInOut(duration: state == .signIn ? 0.5 : 0.1)
                                    .delay(state == .signIn ? 0.2 : 0))
                        .padding([.leading, .trailing, .top], 15)
                }
            }
            
            .frame(width: metrics.size.width,
                   height: metrics.size.height * 0.8,
                   alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(state: .constant(.signIn), email: .constant(""), password: .constant(""))
    }
}
