//
//  PatientAlertsRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol PatientAlertsRoutingLogic {
    var viewController: PatientAlertsViewController? { get set }
    
    func routeToAlertResponder(patientAlert: PatientAlert, handler: AlertResponderHandler)
}

protocol PatientAlertsDataPassing {
    var dataStore: PatientAlertsDataStore? {get set}
}

class PatientAlertsRouter:  PatientAlertsRoutingLogic, PatientAlertsDataPassing {
    
    weak var viewController: PatientAlertsViewController?
    var dataStore: PatientAlertsDataStore?
    
    private var alertRespondNavigationViewControllerProvider: Provider<AlertRespondNavigationViewController>
    
    func routeToAlertResponder(patientAlert: PatientAlert, handler: AlertResponderHandler) {
        let alertRespondNavigationViewController = alertRespondNavigationViewControllerProvider.get()
        alertRespondNavigationViewController.router?.dataStore?.alertResponderHandler = handler
        alertRespondNavigationViewController.router?.dataStore?.patient = patientAlert.patient
        alertRespondNavigationViewController.router?.dataStore?.tagCharecteristics = patientAlert.patientTag
        alertRespondNavigationViewController.router?.dataStore?.triggerDate = patientAlert.creationDate
        alertRespondNavigationViewController.router?.dataStore?.triggerLocation = patientAlert.gateway.name
        
        let popUpContainerViewController = PopUpContainerViewController.generate(forContainedViewController: alertRespondNavigationViewController, mode: .alert)
        viewController?.present(popUpContainerViewController, animated: true, completion: nil)
    }
    
    init(alertRespondNavigationViewControllerProvider: Provider<AlertRespondNavigationViewController>) {
        self.alertRespondNavigationViewControllerProvider = alertRespondNavigationViewControllerProvider
    }
}
