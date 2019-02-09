//
//  HealthRecordModificationRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol HealthRecordModificationRoutingLogic {
    var viewController: HealthRecordModificationViewController? { get set }
    
    func routeToHealthRecordDetails(healthRecord: HealthRecord)
    func routeToPreviousScreen()
}

protocol HealthRecordModificationDataPassing {
    var dataStore: HealthRecordModificationDataStore? {get set}
}

class HealthRecordModificationRouter:  HealthRecordModificationRoutingLogic, HealthRecordModificationDataPassing {
    
  weak var viewController: HealthRecordModificationViewController?
  var dataStore: HealthRecordModificationDataStore?
    
    func routeToHealthRecordDetails(healthRecord: HealthRecord) {
        if let healthRecordViewController = dataStore?.healthRecordViewControllerProvider?.get() {
            healthRecordViewController.router?.dataStore?.healthRecord = healthRecord
            healthRecordViewController.router?.dataStore?.modificationDelegate = dataStore?.modificationDelegate
            viewController?.navigationController?.pushViewController(healthRecordViewController, animated: true)
        }
    }
    
    func routeToPreviousScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
