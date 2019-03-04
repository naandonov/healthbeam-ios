//
//  PatientAlertsPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientAlertsPresentationLogic {
    var presenterOutput: PatientAlertsDisplayLogic? { get set }
    
    func handlePatientAlertsPendingResult(response: PatientAlerts.Pending.Response)
}

class PatientAlertsPresenter: PatientAlertsPresentationLogic {
    
  weak var presenterOutput: PatientAlertsDisplayLogic?
    
    func handlePatientAlertsPendingResult(response: PatientAlerts.Pending.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        
        presenterOutput?.processPendingPatientAlertsResult(viewModel: PatientAlerts.Pending.ViewModel(isSuccessful: response.isSuccessful, errorMessage: errorMessage))
    }

}
