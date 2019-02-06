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
        let healthRecords: [HealthRecord]
        let patientTag: PatientTag?
        let isObserved: Bool
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
