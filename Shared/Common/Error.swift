//
//  Error.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/12/21.
//

import ComposableArchitecture
import Combine


enum AuthError: Error, Equatable {
    case unknown
    case invalidEmail
    case invalidPassword
    case invalidName
    case wrongCreds
    case noUser
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
        case .noUser:
            return "No Existing User"
        }
    }
}

// MARK: - GlobalError
enum GlobalError: Error, Equatable {
  case unknown
  case wrappedResponseIsEmpty
  case parsingError
}

// MARK: - NetworkError
enum NetworkError: Error, Equatable {
  case unknown
  case parsingError
}

// MARK: - LocationError
enum LocationError: Error, Equatable {
    case unknown
    case notAuthorized
    case cannotDetermineLocation
}
