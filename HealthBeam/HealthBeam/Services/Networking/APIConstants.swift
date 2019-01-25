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
        case localHost
        case healthBeamRoot
        
        var urlString: String {
            switch self {
            case .localHost:
                return "http://localhost:8080/v1"
            case .healthBeamRoot:
                return "https://healthbeam.io/v1"
            }
        }
    }
    
    enum EndPoint {
        case login
        case logout
        case user
        case userDeviceToken
        case patients
        case subscriptions
        
        
        var endpointString: String {
            switch self {
            case .login:
                return "/login"
            case .logout:
                return "/logout"
            case .user:
                return "/user"
            case .userDeviceToken:
                return "/user/assignToken"
            case .patients:
                return "/patients"
            case .subscriptions:
                return "/user/subscriptions"
            }
        }
    }
}


