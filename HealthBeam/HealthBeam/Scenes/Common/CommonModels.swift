//
//  CommonModel.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

#warning ("extract to the patients search scene")

struct Patient: Codable {
    let id: Int
    var fullName: String
    var gender: String
    var personalIdentification: String
    var birthDate: Date
    var bloodType: String
    var alergies: [String]
    var premiseLocation: String
}


struct BatchResult<T: Codable>: Codable {
    
    let items: [T]
    let totalPagesCount: Int
    let elementsInPage: Int
    let currentPage: Int
    let totalElementsCount: Int
}


struct FormattedResponse: Codable {
    let result: String
}
