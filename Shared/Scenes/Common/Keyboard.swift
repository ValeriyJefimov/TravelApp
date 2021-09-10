//
//  Keyboard.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/2/21.
//

import SwiftUI
import Combine

struct KeyboardAdaptable: ViewModifier {
    
    @State var currentHeight: CGFloat = 0
    let prefferedRatio: CGFloat
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            withAnimation(.easeOut(duration: 0.16)) {
                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                            }
                    }
                    .map { rect in
                       return (rect.height - geometry.safeAreaInsets.bottom) * prefferedRatio
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { notification in
                            CGFloat.zero
                    }
                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}

extension View {
    func adaptsToKeyboard(prefferedRatio: CGFloat = 1) -> some View {
        return modifier(KeyboardAdaptable(prefferedRatio: prefferedRatio))
    }
}

protocol KeyboardReadable {
    var keyboardVisibility: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardVisibility: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map {$0 as? UIWindowScene}
                    .compactMap({$0})
                    .first?.windows
                    .filter {$0.isKeyWindow}
                    .first?.endEditing(true)
    }
}
