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
                return -size
            }
        }
    }
    
    @Published var state: State = .initial

    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    
    var isPresentingAlert: Binding<Bool> {
           return Binding<Bool>(get: {
               return self.activeError != nil
           }, set: { newValue in
               guard !newValue else { return }
               self.activeError = nil
           })
       }
        
    //MARK: - Private
    private let repo = AuthRepository()
    @Published private(set) var activeError: AuthError?
    
    func submit() -> Bool {
        switch state {
        case .signUp:
            do {
                try repo.erase()
                try repo.set(email: email)
                try repo.set(password: password)
                try repo.set(name: name)
            } catch {
                activeError = AuthError.unknown
                return false
            }
            
        case .signIn:
            do {
                guard let exEmail = repo.email(), let exPass = repo.password() else {
                    throw AuthError.unknown
                }
                
                guard exEmail == email, exPass == password else {
                    throw AuthError.wrongCreds
                }
            } catch let error as AuthError {
                activeError = error
                return false
            } catch {
                activeError = AuthError.unknown
                return false
            }
            
        default:
            return false
        }
       
        return true
    }
    
}
