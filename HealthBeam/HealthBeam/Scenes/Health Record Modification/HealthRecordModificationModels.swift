//
//  HealthRecordModificationModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct HealthRecordModification {
    
    struct DataSource {
        struct Request {
            
        }
        struct Response {
            var healthRecord: HealthRecord?
        }
        struct ViewModel {
            var dataSource: ModificationDatasource<HealthRecord>
        }
    }
    
    struct Create {
        struct Request {
            let healthRecord: HealthRecord
        }
        struct Response {
            let isSuccessful: Bool
            let healthRecord: HealthRecord?
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let healthRecord: HealthRecord?
            let errorMessage: String?
        }
    }
    
    struct Update {
        struct Request {
            let healthRecord: HealthRecord
        }
        struct Response {
            let isSuccessful: Bool
            let healthRecord: HealthRecord?
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let healthRecord: HealthRecord?
            let errorMessage: String?
        }
    }
}
