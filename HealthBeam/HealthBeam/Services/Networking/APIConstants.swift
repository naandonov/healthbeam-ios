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
                return "https://api.HealthBeamapp.eu/v1"
            }
        }
    }
    
    enum EndPoint {
        case access
        case checkState
        case checkPremise
        case enterPremise
        case exitPremise
        
        var endpointString: String {
            switch self {
            case .access:
                return "/access/\(SubstituteAccessCodeKey)"
            case .checkState:
                return "/places/transaction/current"
            case .checkPremise:
                return "/places/do/check"
            case .enterPremise:
                return "/places/do/enter"
            case .exitPremise:
                return "/places/do/exit"
            }
        }
    }
    static let NextActionEnterKey = "enter"
    static let NextActionExitKey = "exit"
    static let OutsideStateKey = "outside"
    static let InsideStateKey = "inside"
    
    static let SubstituteAccessCodeKey = "access_code"
}


