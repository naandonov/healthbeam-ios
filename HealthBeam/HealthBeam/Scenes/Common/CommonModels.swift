//
//  CommonModel.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

struct PatientTag: Codable {
    let id: Int
    let minor: Int
    let major: Int
}

struct Patient: Codable {
    let id: Int
    var fullName: String
    var gender: String
    var personalIdentification: String
    var birthDate: Date
    var bloodType: String
    var alergies: [String]
    var chronicConditions: [String]
    var notes: String?
    var premiseLocation: String?
}

struct PatientAttributes: Codable {
    let observers: [UserProfile.ExternalModel]?
    let healthRecords: [HealthRecord]?
    let patientTag: PatientTag?
}

struct HealthRecord: Codable {
    let id: Int
    var diagnosis: String
    var treatment: String
    var prescription: String
    var notes: String?
    var createdDate: Date
    var creator: UserProfile.ExternalModel?
}

struct BatchResult<T: Codable>: Codable {
    let items: [T]
    let totalPagesCount: Int
    let elementsInPage: Int
    let currentPage: Int
    let totalElementsCount: Int
}

struct GenericResponse: Codable {
    let status: String
    
    var type: ResultType {
        if let resultType = ResultType(rawValue: status) {
            return resultType
        }
        return ResultType.unknown
    }
    
    enum ResultType: String {
        case success = "success"
        case faliure = "faliure"
        case unknown = "unknown"
    }
}
