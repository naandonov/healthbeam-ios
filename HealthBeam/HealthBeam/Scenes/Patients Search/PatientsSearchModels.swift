//
//  PatientsSearchModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct PatientsSearch {
    
    enum Segment: Int {
        case all = 0
        case observed
        
        var title: String {
            switch self {
            case .all:
                return "All".localized()
            case .observed:
                return "Observed".localized()
            }
        }
    }
    
    struct Retrieval {
        struct Request {
            let page: Int
            let searchQuery: String?
            let segment: PatientsSearch.Segment?
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
