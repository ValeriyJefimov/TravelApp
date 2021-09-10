//
//  AuthRepository.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/12/21.
//

import ComposableArchitecture
import Foundation
import UIKit.UIImage

struct AuthRepository {
    fileprivate enum Key: String {
        case password, name, email, image
    }
    
    //MARK: - Private
    fileprivate static let storage: UserDefaults = .standard
    fileprivate static let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    fileprivate static let passwordRegex =  #"(?=.{8,})"# + #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"#
    
    //MARK: - Public
    public var isUserLogged: () -> Effect<Bool, Never>
    public var currentUser: () -> Effect<User, AuthError>
    public var saveUser: (User) -> Effect<User, AuthError>
    public var logout: () -> Effect<Void, AuthError>
    
    public init(
        isUserLogged: @escaping () -> Effect<Bool, Never>,
        currentUser: @escaping () -> Effect<User, AuthError>,
        saveUser: @escaping (User) -> Effect<User, AuthError>,
        logout: @escaping () -> Effect<Void, AuthError>
    ) {
        self.isUserLogged = isUserLogged
        self.currentUser = currentUser
        self.saveUser = saveUser
        self.logout = logout
    }
}


extension AuthRepository {
    public static let live = AuthRepository(
        isUserLogged: { .init(value: storage.value(forKey: Key.email.rawValue) != nil) },
        currentUser: {
            guard
                let email = storage.value(forKey: Key.email.rawValue) as? String,
                let name = storage.value(forKey: Key.name.rawValue) as? String,
                let password = storage.value(forKey: Key.password.rawValue) as? String
            else {
                return .init(error: .noUser)
            }
            
            var profileImage: UIImage? = nil
            if  let profileImageData = storage.value(forKey: Key.image.rawValue) as? Data {
                profileImage = try? NSKeyedUnarchiver
                    .unarchiveTopLevelObjectWithData(profileImageData) as? UIImage
            }
            
            return .init(value: User(name: name, pass: password, email: email, profileImage: profileImage))
        },
        saveUser: { user in
            if user.name.trimmingCharacters(in: .whitespacesAndNewlines).count <= 4 {
                return .init(error: .invalidName)
            }
            
            if user.pass.range(of: passwordRegex, options: .regularExpression) == nil {
                return .init(error: .invalidPassword)
            }
            
            if user.email.range(of: emailRegex, options: .regularExpression) == nil {
                return .init(error: .invalidEmail)
            }

        
            storage.setValue(user.email, forKey: Key.email.rawValue)
            storage.setValue(user.pass, forKey: Key.password.rawValue)
            storage.setValue(user.name, forKey: Key.name.rawValue)
            
            if let profileImage = user.profileImage {
                let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: profileImage, requiringSecureCoding: false)
                storage.setValue(encodedData, forKey: Key.image.rawValue)
            }
            
            return .init(value: user)
        },
        logout:  {
            storage.setValue(nil, forKey: Key.email.rawValue)
            storage.setValue(nil, forKey: Key.password.rawValue)
            storage.setValue(nil, forKey: Key.name.rawValue)
            storage.setValue(nil, forKey: Key.image.rawValue)
            return .init(value: ())
        }
    )
}

extension AuthRepository {
    public static let mock = AuthRepository(
        isUserLogged: { .none },
        currentUser: { .none },
        saveUser: { _ in .none },
        logout: { .none }
    )
}
