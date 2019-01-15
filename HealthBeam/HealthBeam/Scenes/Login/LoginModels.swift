//
//  LoginModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.12.18.
//  Copyright (c) 2018 nikolay.andonov. All rights reserved.
//

import UIKit

struct Login {
    
    struct Result: Codable {
        let accessToken: String
    }
    
    struct Interaction {
        struct Request: Codable {
            let email: String
            let password: String
        }
        struct Response {
            let isSuccessful: Bool
            let user: UserProfile.Model?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let user: UserProfile.Model?
            let errorMessage: String?
        }
    }
}
