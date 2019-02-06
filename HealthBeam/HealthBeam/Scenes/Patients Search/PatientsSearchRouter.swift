//
//  PatientsSearchRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol PatientsSearchRoutingLogic {
    var viewController: PatientsSearchViewController? { get set }
    
    func routeToPatientDetails()
}

protocol PatientsSearchDataPassing {
    var dataStore: PatientsSearchDataStore? {get set}
}

class PatientsSearchRouter:  PatientsSearchRoutingLogic, PatientsSearchDataPassing {
    
  weak var viewController: PatientsSearchViewController?
  var dataStore: PatientsSearchDataStore?
    
    private let patientDetailsViewControllerProvider: Provider<PatientDetailsViewController>
    
    func routeToPatientDetails() {
        let patientDetailsViewController = patientDetailsViewControllerProvider.get()
        patientDetailsViewController.router?.dataStore?.patient = dataStore?.selectedPatient
        patientDetailsViewController.router?.dataStore?.patientAttributes = dataStore?.selectedPatientAttributes
        viewController?.navigationController?.pushViewController(patientDetailsViewController, animated: true)
    }
    
    init(patientDetailsViewControllerProvider: Provider<PatientDetailsViewController>) {
        self.patientDetailsViewControllerProvider = patientDetailsViewControllerProvider
    }
    
}
