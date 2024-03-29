//
//  CommonModel.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

enum StyleMode {
    case standard
    case alert
}

struct PatientTag: Codable, TagCharacteristics {
    var id: Int?
    var minor: Int
    var major: Int
}

struct Patient: Codable {
    let id: Int?
    var fullName: String
    var gender: String
    var personalIdentification: String
    var birthDate: Date?
    var bloodType: String
    var allergies: [String]
    var chronicConditions: [String]
    var notes: String?
    var premiseLocation: String?
    
    static func emptySnapshot() -> Patient {
        return Patient(id: nil, fullName: "", gender: "", personalIdentification: "", birthDate: nil, bloodType: "", allergies: [], chronicConditions: [], notes: nil, premiseLocation: nil)
    }
    
    var shortDescription: String {
        return "\(birthDate?.yearsSince() ?? "Unknown age".localized()), \(gender)"
    }
}

struct PatientAttributes: Codable {
    var observers: [UserProfile.ExternalModel]?
    var healthRecords: [HealthRecord]?
    var patientTag: PatientTag?
}

struct HealthRecord: Codable {
    let id: Int?
    var diagnosis: String
    var treatment: String
    var prescription: String
    var notes: String?
    var createdDate: Date
    var creator: UserProfile.ExternalModel?
    
    static func emptySnapshot(creator: UserProfile.ExternalModel) -> HealthRecord {
        return HealthRecord(id: nil, diagnosis: "", treatment: "", prescription: "", notes: "", createdDate: Date(), creator: creator)
    }
}

struct PatientAlert: Codable {
    var id: Int
    let creationDate: Date
    var status: String
    let patient: Patient
    let gateway: Gateway
    let patientTag: PatientTag
}

struct Premise: Codable {
    let id: Int
    let name: String
    let type: String
}

struct Gateway: Codable {
    let id: Int
    let codeIdentifier: String
    let premise: Premise
    let name: String
}

struct BatchResult<T: Codable>: Codable {
    let items: [T]
    let totalPagesCount: Int
    let elementsInPage: Int
    let currentPage: Int
    let totalElementsCount: Int
    
    static func generateOnePageResultForModel(_ model: [T]) -> BatchResult<T> {
        return BatchResult(items: model,
                           totalPagesCount: 1,
                           elementsInPage: model.count,
                           currentPage: 1,
                           totalElementsCount: model.count)
    }
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
