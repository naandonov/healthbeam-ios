//
//  PatientTagsSearchModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct PatientTagsSearch {
    
    struct Locate {
        struct Request {
            
        }
        struct Response {
            let beacons: [Beacon]
        }
        struct ViewModel {
            let beacons: [Beacon]
        }
    }
}
