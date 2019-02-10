//
//  PatientDetailsModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct PatientDetails {
    
    struct Model {
        var patient: Patient
        var healthRecords: [HealthRecord]
        var patientTag: PatientTag?
        var isObserved: Bool
    }
    
    struct SubscriptionToggleRequest: Codable {
        let patientId: Int
    }
    
    struct SubscriptionToggleResult: Codable {
        let patientId: Int
        let isSubscribed: Bool
    }
    
    struct AttributeProcessing {
        struct Request {
        }
        struct Response {
            let patientDetails: Model
        }
        struct ViewModel {
            let patientDetails: Model
        }
    }
    
    struct AssignTag {
        struct Request {
            let beacon: Beacon
            
        }
        struct Response {
            let isSuccessful: Bool
            let error: MSError?
            let patientTag: PatientTag?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let errorMessage: String?
            let patientTag: PatientTag?
        }
    }
    
    struct UnassignTag {
        struct Request {
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
    
    struct SubscribeToggle {
        struct Request {
        }
        struct Response {
            let isSuccessful: Bool
            let isSubscribed: Bool?
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let isSubscribed: Bool?
            let errorMessage: String?
        }
    }
    
    struct Delete {
        struct Request {
            let patient: Patient
        }
        struct Response {
            let isSuccessful: Bool
            let patient: Patient
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let deletedPatient: Patient
            let errorMessage: String?
        }
    }
    
    struct Update {
        struct Request {
            let patient: Patient
        }
        struct Response {
            let isSuccessful: Bool
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let updatedPatient: Patient?
            let errorMessage: String?
        }
    }
}
