//
//  Beacon.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 28.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import Foundation

struct Beacon: Equatable, Codable {
    let minor: Int
    let major: Int
    let rssi: Int
    let accuracy: Double
    
    var representationImageName: String {
        return minor < 1000 ? "braceletTagIcon" : "cardTagIcon"
    }
    
    var representationName: String {
        return "\(minor)-\(major)"
    }
    
    public static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor
    }
}
