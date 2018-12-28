//
//  Beacon.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 28.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import Foundation

struct Beacon: Equatable {
    let minor: Int
    let major: Int
    let rssi: Int
    
    public static func == (lhs: Beacon, rhs: Beacon) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor
    }
}
