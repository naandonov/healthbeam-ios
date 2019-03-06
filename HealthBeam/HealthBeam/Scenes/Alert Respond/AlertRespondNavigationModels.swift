//
//  AlertRespondNavigationModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct AlertRespondNavigation {

    struct DescriptionModel {
        enum Designation {
            case patientInfo(name: String, age: String, gender: String)
            case trgiggerLocation(location: String)
            case triggerDate(date: Date)
            case patientTag(beacon: Beacon)
        }
        
        private(set) var title: String
        private(set) var titleColor: UIColor
        private(set) var subtitle: String
        private(set) var imageName: String
        let cellHeight: CGFloat = 80
        
        let designation: Designation
        
        init(designation: Designation) {
            self.designation = designation
            switch designation {
            case .patientInfo(let name, let age, let gender):
                
                title = name
                subtitle = "\(age), \(gender)"
                imageName = "heartbeatIcon"
                titleColor = .neutralRed
            case .trgiggerLocation(let location):
                
                title = location
                subtitle = "Trigger Location".localized()
                imageName = "gatewayIcon"
                titleColor = .darkGray
            case .triggerDate(let date):
                
                title = date.simpleFullDateString()
                subtitle = "Trigger Date".localized()
                imageName = "clockIcon"
                titleColor = .darkGray
            case .patientTag(let beacon):
                
                title = beacon.representationName
                subtitle = "Patient Tag".localized()
                imageName = beacon.representationImageName
                titleColor = .darkGray
            }
        }
    }
    
    
    struct DescriptionDatasource {
        struct Request {
        }
        struct Response {
            var patient: Patient?
            var triggerLocation: String?
            var triggerDate: Date?
            var beacon: Beacon?
        }
        struct ViewModel {
            let dataSource: [DescriptionModel]?
            let isSuccessful: Bool
        }
    }
}
