//
//  HealthRecordRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol HealthRecordRoutingLogic {
    var viewController: HealthRecordViewController? { get set }
    func performNavigationCleanupIfNeeded()
    func routeToPreviousScreen()
    func routeToUpdateHealthRecord(for healthRecord: HealthRecord)
}

protocol HealthRecordDataPassing {
    var dataStore: HealthRecordDataStore? {get set}
}

class HealthRecordRouter:  HealthRecordRoutingLogic, HealthRecordDataPassing {
    
    weak var viewController: HealthRecordViewController?
    var dataStore: HealthRecordDataStore?
    
    private let healthRecordModificationViewControllerProvider: Provider<HealthRecordModificationViewController>
    
    func routeToPreviousScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func performNavigationCleanupIfNeeded() {
        if let viewControllersCount = viewController?.navigationController?.viewControllers.count,
            viewControllersCount > 2,
            let _ = viewController?.navigationController?.viewControllers[viewControllersCount - 2] as? HealthRecordModificationViewController {
            viewController?.navigationController?.viewControllers.remove(at: viewControllersCount - 2)
        }
    }
    
    func routeToUpdateHealthRecord(for healthRecord: HealthRecord) {
        let healthRecordModificationViewController = healthRecordModificationViewControllerProvider.get()
        healthRecordModificationViewController.router?.dataStore?.modificationDelegate = dataStore?.modificationDelegate
        healthRecordModificationViewController.mode = .update
        healthRecordModificationViewController.router?.dataStore?.healthRecord = healthRecord
        healthRecordModificationViewController.router?.dataStore?.healthRecordUpdateHandler = viewController
        viewController?.navigationController?.pushViewController(healthRecordModificationViewController, animated: true)
    }
    
    init(healthRecordModificationViewControllerProvider: Provider<HealthRecordModificationViewController>) {
        self.healthRecordModificationViewControllerProvider = healthRecordModificationViewControllerProvider
    }
}
