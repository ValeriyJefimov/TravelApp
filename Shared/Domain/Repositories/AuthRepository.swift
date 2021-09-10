//
//  AuthRepository.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/2/21.
//

import Combine

class AuthRepository: ObservableObject {
    
    //MARK: - Private
    private let storage: KeychainRepository = KeychainStore()
    private let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    private let passwordRegex =  #"(?=.{8,})"# + #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"#

    
    //MARK: - Public
    
    func set(name: String) throws {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).count <= 4 {
            throw AuthError.invalidName
        }
        try storage.set(value: name, for: .name)
    }
    
    func set(password: String) throws {
        if password.range(of: passwordRegex, options: .regularExpression) == nil {
            throw AuthError.invalidPassword
        }
        try storage.set(value: password, for: .password)
    }
    
    func set(email: String) throws {
        if email.range(of: emailRegex, options: .regularExpression) == nil {
            throw AuthError.invalidEmail
        }
        try storage.set(value: email, for: .email)
    }
    
    func email() -> String? {
        return storage.value(at: .email)
    }
    
    func password() -> String? {
        return storage.value(at: .password)
    }
    
    func name() -> String?  {
        return storage.value(at: .name)
    }
    
    func erase() throws {
        try storage.remove(at: .email)
        try storage.remove(at: .name)
        try storage.remove(at: .password)
    }
}
