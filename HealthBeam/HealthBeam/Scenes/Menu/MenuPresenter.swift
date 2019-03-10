//
//  MenuPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol MenuPresentationLogic {
    var presenterOutput: MenuDisplayLogic? { get set }
    
    func handleAuthorization(response: Menu.AuthorizationCheck.Response)
    func handleUserProfileUpdate(response: Menu.UserProfileUpdate.Response)
    func handleUserLogout(response: Menu.UserLogout.Response)
    func handlePendingAlertsCheck(response: Menu.CheckForPendingAlerts.Response)
    func handleAuthorizationRevocation()
    func updatePatientAlertsOption(response: Menu.UpdatePatientAlertsOption.Response)
    func handlePatientAlertRetrievalResult(response: Menu.RetrievePatientAlert.Response)
    
    func handleReceivedPatientAlertNotification()
}

class MenuPresenter: MenuPresentationLogic {
    
    weak var presenterOutput: MenuDisplayLogic?
    
    
    func handleAuthorization(response: Menu.AuthorizationCheck.Response) {
        let viewModel = Menu.AuthorizationCheck.ViewModel(authorizationGranted: response.authorizationGranted)
        presenterOutput?.didPerformAuthorizationCheck(viewModel: viewModel)
    }
    
    func handleUserProfileUpdate(response: Menu.UserProfileUpdate.Response) {
        presenterOutput?.didPerformProfileUpdate(viewModel: Menu.UserProfileUpdate.ViewModel(user: response.user))
    }
    
    func handleAuthorizationRevocation() {
        presenterOutput?.didReceiveAuthorizationRevocation()
    }
    
    func handleUserLogout(response: Menu.UserLogout.Response) {
        presenterOutput?.didPerformUserLogout(viewModel: Menu.UserLogout.ViewModel(isLogoutSuccessful: response.isLogoutSuccessful))
    }
    
    func handlePendingAlertsCheck(response: Menu.CheckForPendingAlerts.Response) {
        var warningMessage: String?
        if response.pendingAlertsExist {
            warningMessage = "Patients which you are observing need immediate medical assistance!".localized() + "\n\n"
                + "Further information can be found in the Patient Alerts section.".localized()
        }
        presenterOutput?.didPerformPendingAlertsCheck(viewModel: Menu.CheckForPendingAlerts.ViewModel(warningMessage: warningMessage))
    }
    
    func updatePatientAlertsOption(response: Menu.UpdatePatientAlertsOption.Response) {
        presenterOutput?.didPerformPatientAlertsOperationUpdate(viewModel: Menu.UpdatePatientAlertsOption.ViewModel())
    }
    
    func handlePatientAlertRetrievalResult(response: Menu.RetrievePatientAlert.Response) {
        let errorMessage = response.error?.userFiendlyDescription
        var patientAlertMessage: String?
        if let patientAlert = response.patientAlert {
            patientAlertMessage = patientAlert.patient.fullName + " "
                + "requires immediate medical assistance" + "\n\n"
                + "Further information can be found in the Patient Alerts section.".localized()
        }
        presenterOutput?.didRetrievePatientAlert(viewModel: Menu.RetrievePatientAlert.ViewModel(isSuccessful: response.isSuccessful, patientAlert: response.patientAlert, errorMessage: errorMessage, patientAlertMessage: patientAlertMessage))
    }
    
    func handleReceivedPatientAlertNotification() {
        presenterOutput?.didReceivePatientAlert()
    }
}
