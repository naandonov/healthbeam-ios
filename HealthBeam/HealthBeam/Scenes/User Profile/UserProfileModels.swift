//
//  UserProfileModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct UserProfile {
    
    struct ExternalModel: Codable {
        let id: Int
        var fullName: String
        var designation: String
    }
    
    struct Model: Codable {
        let id: Int
        var fullName: String
        var designation: String
        let email: String
        var discoveryRegions: [String]
        let accountType: String?
        let premise: Premise
    }
    
    struct Placeholder {
        struct Request {
            
        }
        struct Response {
            
        }
        struct ViewModel {
            
        }
    }
}
