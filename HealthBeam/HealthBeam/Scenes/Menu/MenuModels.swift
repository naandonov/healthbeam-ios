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
    
    struct CheckForPendingAlerts {
        struct Request {
        }
        struct Response {
            let pendingAlertsExist: Bool
        }
        struct ViewModel {
            let warningMessage: String?
        }
    }
    
    struct UserLogout {
        struct Request {
        }
        struct Response {
             let isLogoutSuccessful: Bool
        }
        struct ViewModel {
             let isLogoutSuccessful: Bool
        }
    }
    
    struct UpdatePatientAlertsOption {
        struct Request {
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    struct RetrievePatientAlert {
        struct Request {
            let alertId: String
        }
        struct Response {
            let isSuccessful: Bool
            var patientAlert: PatientAlert?
            var error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            var patientAlert: PatientAlert?
            var errorMessage: String?
            var patientAlertMessage: String?
        }
    }
    
    struct Option {
        let type: OptionType
        let iconName: String
        let name: String
        let description: String
        
        enum OptionType {
            case patientsLocate
            case patientsSearch
            case patientAlerts
            case about
            case logout
        }
    }
}
