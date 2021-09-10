//
//  KeychainRepository.swift
//  TravelApp (iOS)
//
//  Created by Valeriy Jefimov on 8/2/21.
//

import Foundation
import KeychainAccess

enum KeychainKey: String {
    case password, name, email
}

protocol KeychainRepository {
    func value(at key: KeychainKey) -> String?
    func set(value: String, for key: KeychainKey) throws
    func remove(at key: KeychainKey) throws
}


struct KeychainStore: KeychainRepository {
     
    //MARK: - Private
    private let keychain: Keychain
    
    init() {
        self.keychain = Keychain(service: "com.Jefimov.TravelApp")
    }
    
    func value(at key: KeychainKey) -> String? {
       try? keychain.get(key.rawValue)
    }
    
    func set(value: String, for key: KeychainKey) throws {
       try keychain.set(value, key: key.rawValue)
    }
    
    
    func remove(at key: KeychainKey) throws {
       try keychain.remove(key.rawValue)
    }
    
    
}
