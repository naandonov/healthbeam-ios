//
//  APIConstants.swift
//  MinerStats
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

struct APIConstants {
    enum BaseURL {
        case localHost
        case healthBeamRoot
        case healthBeamWeb
        
        var urlString: String {
            switch self {
            case .localHost:
                return "http://localhost:8080/v1"
            case .healthBeamRoot:
                return "https://healthbeam.io/v1"
            case .healthBeamWeb:
                return "https://healthbeam.io"
            }
        }
    }
    
    enum EndPoint: String {
        case login
        case logout
        case user
        case userDeviceToken
        case pendingAlerts
        case pendingAlertsCount
        case alert
        case respondToAlert
        case patients
        case patientDelete
        case patientAttributes
        case healthRecordCreate
        case healthRecordDelete
        case healthRecordModification
        case subscriptions
        case toggleSubscription
        case assignPatientTag
        case unassignPatientTag
        case locateNearbyPatients
        case termsAndConditions
        case privacyPolicy
        
        
        var endpointString: String {
            switch self {
            case .login:
                return "/login"
            case .logout:
                return "/logout"
                
            case .user:
                return "/user"
            case .userDeviceToken:
                return "/user/assignToken"
            case .subscriptions:
                return "/user/subscriptions"
            case .toggleSubscription:
                return "/user/toggleSubscription"
            case .pendingAlerts:
                return "/alerts/pending"
            case .pendingAlertsCount:
                return "/alerts/pending/count"
            case .respondToAlert:
                return "/alerts/respond"
            case .alert:
                return "/alerts/\(APIConstants.EndPoint.alertIdSubstitutionKey)"
                
            case .patients:
                return "/patients"
            case .patientDelete:
                return "/patients/\(APIConstants.EndPoint.patientIdSubstitutionKey)"
            case .patientAttributes:
                return "/patients/\(APIConstants.EndPoint.patientIdSubstitutionKey)/attributes"
            case .healthRecordCreate:
                return "/patients/\(APIConstants.EndPoint.patientIdSubstitutionKey)/healthRecords"
            case .assignPatientTag:
                return "/patients/\(APIConstants.EndPoint.patientIdSubstitutionKey)/assignTag"
            case .unassignPatientTag:
                return "/patients/\(APIConstants.EndPoint.patientIdSubstitutionKey)/unassignTag"
            case .locateNearbyPatients:
                return "/patients/nearby"
                
            case .healthRecordDelete:
                return "/healthRecords/\(APIConstants.EndPoint.patientIdSubstitutionKey)"
            case .healthRecordModification:
                return "/healthRecords"
                
            case .termsAndConditions:
                return "/terms-and-conditions"
            case .privacyPolicy:
                return "/privacy-policy"
            }
        }
        
        static let patientIdSubstitutionKey = "patientId"
        static let alertIdSubstitutionKey = "alertId"
    }
}


