//
//  PatientModificationModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct PatientModification {
    
    struct DataSource {
        struct Request {
            
        }
        struct Response {
            var patient: Patient?
        }
        struct ViewModel {
            var dataSource: ModificationDatasource<Patient>
        }
    }
    
    struct Create {
        struct Request {
            let patient: Patient
        }
        struct Response {
            let isSuccessful: Bool
            let patient: Patient?
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let patient: Patient?
            let errorMessage: String?
        }
    }
    
    struct Update {
        struct Request {
            let patient: Patient
        }
        struct Response {
            let isSuccessful: Bool
            let patient: Patient?
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let patient: Patient?
            let errorMessage: String?
        }
    }
}
