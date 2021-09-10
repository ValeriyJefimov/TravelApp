//
//  Modifiers.swift
//  TravelApp
//
//  Created by Valeriy Jefimov on 8/16/21.
//

import SwiftUI


//MARK: - Card
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

//MARK: - OverflowContentViewModifier
struct OverflowContentViewModifier: ViewModifier {
    @State private var contentOverflow: Bool = false
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader { contentGeometry in
                    Color.clear.onAppear {
                        contentOverflow = contentGeometry.size.height > geometry.size.height
                    }
                }
            )
            .wrappedInScrollView(when: contentOverflow)
        }
    }
}

extension View {
    @ViewBuilder
    func wrappedInScrollView(when condition: Bool) -> some View {
        if condition {
            ScrollView {
                self
            }
        } else {
            self
        }
    }
}

extension View {
    func scrollOnOverflow() -> some View {
        modifier(OverflowContentViewModifier())
    }
}
