//
//  FindBarrierWorker.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.10.18.
//  Copyright (c) 2018 HealthBeam. All rights reserved.
//

import UIKit

protocol AuthorizationWorker {
    func checkForAuthorization() -> Bool
    func setAuthorizationToken(_ token: String)
    func getAuthorizationToken() -> String?
    func deleteAuthorizationToken() throws
}

class AuthorizationManager: AuthorizationWorker {
    
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
}
