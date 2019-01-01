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
        case HealthBeamRoot
        
        var urlString: String {
            switch self {
            case .HealthBeamRoot:
                return "http://localhost:8080/v1"
            }
        }
    }
    
    enum EndPoint {
        case login
        case logout
        case user
        
        
        var endpointString: String {
            switch self {
            case .login:
                return "/login"
            case .logout:
                return "/logout"
            case .user:
                return "/user"
            }
        }
    }
}


