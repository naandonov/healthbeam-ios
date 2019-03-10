//
//  AlertRespondNavigationModels.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

struct AlertRespondNavigation {

    struct ProcessingRequest: Codable {
        let patientId: Int
        let notes: String?
    }
    
    struct ProcessingResponse: Codable {
        let remainingPendingAlertsCount: Int?
    }
    
    struct DescriptionModel {
        enum Designation {
            case patientInfo(name: String, description: String)
            case trgiggerLocation(location: String)
            case triggerDate(date: Date)
            case tagCharecteristics(tagCharecteristics: TagCharacteristics)
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
            case .patientInfo(let name, let description):
                
                title = name
                subtitle = description
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
            case .tagCharecteristics(let tagCharecteristics):
                
                title = tagCharecteristics.representationName
                subtitle = "Patient Tag".localized()
                imageName = tagCharecteristics.representationImageName
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
            var tagCharecteristics: TagCharacteristics?
        }
        struct ViewModel {
            let dataSource: [DescriptionModel]?
            let isSuccessful: Bool
        }
    }
    
    struct PatientSearch {
        struct Request {
        }
        struct Response {
            let isSuccessful: Bool
        }
        struct ViewModel {
            let isSuccessful: Bool
            var errorMessage: String?
        }
    }
    
    struct Respond {
        struct Request {
            let notes: String? 
        }
        struct Response {
            let isSuccessful: Bool
            let error: MSError?
        }
        struct ViewModel {
            let isSuccessful: Bool
            var errorMessage: String?
        }
    }
}
