//
//  AuthSceneViewModel.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 7/30/21.
//

import Combine
import SwiftUI

class AuthSceneViewModel: ObservableObject {
    enum State {
        case initial
        case signUp
        case signIn
        
        func offset(with padding: CGFloat, and size: CGFloat = 0) -> CGFloat {
            switch self {
            case .signUp:
                return 0
            case .initial:
                return -size / 2
            case .signIn:
                return padding - size
            }
        }
    }
    
    @Published var state: State = .initial
    @Published var email: String = ""
    @Published var password: String = ""
    
}


