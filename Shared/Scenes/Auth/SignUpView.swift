//
//  SignUpView.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        Rectangle()
            .modifier(Card())
            .foregroundColor(.red)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
