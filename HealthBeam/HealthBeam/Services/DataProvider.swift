//
//  DataProvider.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

struct DataProvider {
    
    static var genders: [String] {
        return [
            "male".localized(),
            "female".localized()
        ]
    }
    
    static var bloodTypes: [String] {
        return [
            "A".localized(),
            "B".localized(),
            "AB".localized(),
            "0".localized()
        ]
    }
    
}
