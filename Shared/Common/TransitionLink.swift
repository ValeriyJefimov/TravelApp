//
//  TransitionLink.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 9/3/21.
//

import SwiftUI

enum ModalTransition: TransitionLinkType {
    case cover(offset: CGFloat)
    case fullScreenModal
    case scale

    var transition: AnyTransition {
        switch self {
        case .fullScreenModal:
            return .move(edge: .bottom)
        case .scale:
            return .scale(scale: 0)
        case let .cover(offset):
            return .offset(y: offset).combined(with: .opacity)
        }
    }
}

protocol TransitionLinkType {
    var transition: AnyTransition { get }
}

struct TransitionLink<Content, Destination>: View where Content: View, Destination: View {

    @Binding var isPresented: Bool
    var content: () -> Content
    var destination: () -> Destination
    var linkType: TransitionLinkType
        
    init(isPresented: Binding<Bool>, linkType: TransitionLinkType, @ViewBuilder destination: @escaping () -> Destination, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.destination = destination
        self._isPresented = isPresented
        self.linkType = linkType
    }
    
    var body: some View {
        ZStack {
            if self.isPresented {
                self.destination()
                    .transition(self.linkType.transition)
            } else {
                self.content()
            }
        }
    }
}

struct ModaLinkViewModifier<Destination>: ViewModifier where Destination: View {

    @Binding var isPresented: Bool
    var linkType: TransitionLinkType
    var destination: () -> Destination

    func body(content: Self.Content) -> some View {
        TransitionLink(isPresented: self.$isPresented,
                       linkType: linkType,
                       destination: {
                        self.destination()
        }, content: {
            content
        })
    }

}

extension View {

    func modalLink<Destination: View>(isPresented: Binding<Bool>,
                                      linkType: TransitionLinkType,
                                      destination: @escaping () -> Destination) -> some View {
        self.modifier(ModaLinkViewModifier(isPresented: isPresented,
                                           linkType: linkType,
                                           destination: destination))
    }

}
