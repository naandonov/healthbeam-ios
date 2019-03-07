//
//  AlertRespondNavigationRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol AlertRespondNavigationRoutingLogic {
    var viewController: AlertRespondNavigationViewController? { get set }
    
    func routeToLocatingView(output: AlertLocatingViewOutput)
}

protocol AlertRespondNavigationDataPassing {
    var dataStore: AlertRespondNavigationDataStore? {get set}
}

class AlertRespondNavigationRouter:  AlertRespondNavigationRoutingLogic, AlertRespondNavigationDataPassing {
    
    weak var viewController: AlertRespondNavigationViewController?
    var dataStore: AlertRespondNavigationDataStore?
    weak var alertLocatingViewOutput: AlertLocatingViewOutput?
    
    private let alertLocatingViewControllerProvider: Provider<AlertLocatingViewController>
    
    func routeToLocatingView(output: AlertLocatingViewOutput) {
        alertLocatingViewOutput = output
        let alertLocatingViewController = alertLocatingViewControllerProvider.get()
        viewController?.pushViewController(alertLocatingViewController, animated: true)
    }
    
    init(alertLocatingViewControllerProvider: Provider<AlertLocatingViewController>) {
        self.alertLocatingViewControllerProvider = alertLocatingViewControllerProvider
    }
}
