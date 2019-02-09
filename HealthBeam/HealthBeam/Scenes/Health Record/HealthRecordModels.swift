//
//  HealthRecordModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct HealthRecordModel {
    
    struct DataSource {
        let displayElements: [ContentDisplayController.DisplayElement]
        let creatorName: String
        let creatorDesignation: String
        let creationDate: String
        let disgnosis: String
    }
    
    struct Get {
        struct Request {
            
        }
        struct Response {
            let healthRecord: HealthRecord
        }
        struct ViewModel {
            let dataSource: DataSource
        }
    }
    
    struct Delete {
        struct Request {
            let healthRecord: HealthRecord
        }
        struct Response {
            let isSuccessful: Bool
            let healthRecord: HealthRecord
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            let healthRecord: HealthRecord
            let errorMessage: String?
        }
    }
}
