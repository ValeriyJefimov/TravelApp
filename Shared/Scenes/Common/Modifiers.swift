//
//  Modifiers.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import SwiftUI

struct Card: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.white))
            .cornerRadius(20)
            .shadow(color: Color(red: 0,
                                 green: 0,
                                 blue: 0,
                                 opacity: 0.07),
                    radius: 14, x: 0, y: 7)
    }
}

