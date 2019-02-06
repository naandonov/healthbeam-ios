//
//  HealthRecordRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol HealthRecordRoutingLogic {
    var viewController: HealthRecordViewController? { get set }
}

protocol HealthRecordDataPassing {
    var dataStore: HealthRecordDataStore? {get set}
}

class HealthRecordRouter:  HealthRecordRoutingLogic, HealthRecordDataPassing {
    
  weak var viewController: HealthRecordViewController?
  var dataStore: HealthRecordDataStore?
    
}
