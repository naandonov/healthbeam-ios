//
//  PatientAlertsModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct PatientAlerts {
    
    struct Details: Codable {
        var count: Int
    }
    
    struct Pending {
        struct Request {
            let page: Int
            let handler: PatientAlertsHandler
        }
        struct Response {
            let isSuccessful: Bool
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let errorMessage: String?
        }
    }
}
