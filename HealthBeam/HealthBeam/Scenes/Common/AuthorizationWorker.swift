//
//  FindBarrierWorker.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.10.18.
//  Copyright (c) 2018 HealthBeam. All rights reserved.
//

import UIKit

protocol AutorizationEvents: class {
    func authorizationHasExpired()
}

protocol AuthorizationWorker {
    var delegate: AutorizationEvents? { get set }
    
    func checkForAuthorization() -> Bool
    func setAuthorizationToken(_ token: String)
    func getAuthorizationToken() -> String?
    func deleteAuthorizationToken() throws
    func revokeAuthorization() throws
}

class AuthorizationManager: AuthorizationWorker {
    
    weak var delegate: AutorizationEvents?
    
    func checkForAuthorization() -> Bool {
        return KeychainManager.getAuthorizationToken() != nil
    }
    
    func setAuthorizationToken(_ token: String) {
        KeychainManager.setAuthorizationToken(token)
    }
    
    func getAuthorizationToken() -> String? {
        return KeychainManager.getAuthorizationToken()
    }
    
    func deleteAuthorizationToken() throws {
       try KeychainManager.deleteAuthorizationToken()
    }
    
    func revokeAuthorization() throws {
        try deleteAuthorizationToken()
        delegate?.authorizationHasExpired()
    }
}
