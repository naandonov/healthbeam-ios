//
//  Double+Utilities.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 10.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

extension Double {

    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
