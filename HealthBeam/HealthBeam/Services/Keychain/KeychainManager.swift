//
//  KeychainManager.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 12.10.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation
import KeychainAccess

extension KeychainManager {
    private enum Constants {
        static let AuthorizationTokenKey = "authorizationTokenKey"
    }
    
    private enum KeychainError: Error {
        case UnsuccessfulDeletion
    }
}

class KeychainManager {
    
    class func setAuthorizationToken(_ token: String) {
        keychain[Constants.AuthorizationTokenKey] = token
    }
    
    class func getAuthorizationToken() -> String? {
        return keychain[Constants.AuthorizationTokenKey]
    }
    
    class func deleteAuthorizationToken() throws {
        do {
            try keychain.remove(Constants.AuthorizationTokenKey)
        }
        catch {
            throw KeychainError.UnsuccessfulDeletion
        }
    }
    
    //MARK:- Private Implementation
    
    private static var keychain: Keychain = {
        return Keychain(service: Bundle.main.bundleIdentifier!)
    }()
}
