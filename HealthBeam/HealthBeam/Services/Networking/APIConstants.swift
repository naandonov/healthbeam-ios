//
//  APIConstants.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

struct APIConstants {
    enum BaseURL {
        case healthBeamRoot
        
        var urlString: String {
            switch self {
            case .healthBeamRoot:
                return "http://localhost:8080/v1"
            }
        }
    }
    
    enum EndPoint {
        case login
        case logout
        case user
        case patients
        
        
        var endpointString: String {
            switch self {
            case .login:
                return "/login"
            case .logout:
                return "/logout"
            case .user:
                return "/user"
            case .patients:
                return "/patients"
            }
        }
    }
}


