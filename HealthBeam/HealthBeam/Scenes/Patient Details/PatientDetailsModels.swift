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
}
