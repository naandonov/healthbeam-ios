//
//  PatientsSearchModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct PatientsSearch {
    
    struct Retrieval {
        struct Request {
            let page: Int
            let searchQuery: String?
            let handler: PatientsSearchHandler
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
