//
//  Premise+Mapping.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 23.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

extension PremiseEntity {
    
    func model() -> Premise? {
        var premise: Premise?
        if let name = name,
            let type = type {
            premise = Premise(id: Int(id),
                              name: name,
                              type: type)
        }
        return premise
    }
    
    func assignFromModel(_ model: Premise) {
        id = Int64(model.id)
        name = model.name
        type = model.type
    }
    
    
}
