//
//  MenuModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct Menu {
    
    struct AuthorizationCheck {
        struct Request {
        }
        struct Response {
            let authorizationGranted: Bool
        }
        struct ViewModel {
            let authorizationGranted: Bool
        }
    }
    
    struct UserProfileUpdate {
        struct Request {
        }
        struct Response {
            let user: UserProfile.Model?
        }
        struct ViewModel {
            let user: UserProfile.Model?
        }
    }
}
