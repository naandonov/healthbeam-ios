//
//  Beacon.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 28.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import Foundation

protocol TagCharacteristics {
    var minor: Int { get set }
    var major: Int { get set }
}

extension TagCharacteristics {
    var representationImageName: String {
        return minor < 1000 ? "braceletTagIcon" : "cardTagIcon"
    }
    
    var representationName: String {
        return "\(minor)-\(major)"
    }
}

struct Beacon: Equatable, Codable, TagCharacteristics {
    var minor: Int
    var major: Int
    let rssi: Int
    let accuracy: Double
    
    public static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor
    }
}
