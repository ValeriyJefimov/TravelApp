//
//  Errors.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/2/21.
//

import Foundation

enum AuthError: Error {
    case unknown
    case invalidEmail
    case invalidPassword
    case invalidName
    case wrongCreds
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongCreds:
            return "Wrong Email or Password"
        case .unknown:
            return "Unknown Error"
        case .invalidEmail:
            return "Invalid Email"
        case .invalidPassword:
            return "Invalid Password"
        case .invalidName:
            return "Invalid Name"
        }
    }
}
