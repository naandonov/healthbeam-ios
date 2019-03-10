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
    func routeToAlertCompletionView(output: AlertCompletionViewOutput)
}

protocol AlertRespondNavigationDataPassing {
    var dataStore: AlertRespondNavigationDataStore? {get set}
}

class AlertRespondNavigationRouter:  AlertRespondNavigationRoutingLogic, AlertRespondNavigationDataPassing {
    
    weak var viewController: AlertRespondNavigationViewController?
    var dataStore: AlertRespondNavigationDataStore?
    
    private let alertLocatingViewControllerProvider: Provider<AlertLocatingViewController>
    private let alertCompletionViewControllerProvider: Provider<AlertCompletionViewController>
    
    func routeToLocatingView(output: AlertLocatingViewOutput) {
        let alertLocatingViewController = alertLocatingViewControllerProvider.get()
        alertLocatingViewController.output = output
        alertLocatingViewController.patient = dataStore?.patientAlert?.patient
        alertLocatingViewController.tagCharecteristics = dataStore?.patientAlert?.patientTag
        viewController?.pushViewController(alertLocatingViewController, animated: true)
    }
    
    func routeToAlertCompletionView(output: AlertCompletionViewOutput) {
        let alertCompletionViewController = alertCompletionViewControllerProvider.get()
        alertCompletionViewController.output = output
        alertCompletionViewController.patient = dataStore?.patientAlert?.patient
        viewController?.pushViewController(alertCompletionViewController, animated: true)
    }
    
    init(alertLocatingViewControllerProvider: Provider<AlertLocatingViewController>,
         alertCompletionViewControllerProvider: Provider<AlertCompletionViewController>) {
        self.alertLocatingViewControllerProvider = alertLocatingViewControllerProvider
        self.alertCompletionViewControllerProvider = alertCompletionViewControllerProvider
    }
}
