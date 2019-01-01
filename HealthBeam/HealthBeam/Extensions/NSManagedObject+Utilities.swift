//
//  NSManagedObject+Utilities.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    class var entityName: String {
        let name = String(describing: self).components(separatedBy: ".").first ?? ""
        return name
    }
}

