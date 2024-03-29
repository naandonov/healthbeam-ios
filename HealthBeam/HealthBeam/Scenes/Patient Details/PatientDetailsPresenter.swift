//
//  PatientDetailsPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientDetailsPresentationLogic {
    var presenterOutput: PatientDetailsDisplayLogic? { get set }
    
    func presentationForPatientsDescription(response: PatientDetails.AttributeProcessing.Response)
    func processDeletePatientOperation(response: PatientDetails.Delete.Response)
    
    func presentAssignedPatientTag(response: PatientDetails.AssignTag.Response)
    func presentUnassignedPatientTag(response: PatientDetails.UnassignTag.Response)
    func presentPerformedSubscriptionToggle(response: PatientDetails.SubscribeToggle.Response)

}

enum PatientDetailsSection: Int {
    case allergies
    case chronicConditions
    case healthRecords
    
    var sectionTitle: String {
        switch self {
            
        case .allergies:
            return "Allergies".localized()
        case .chronicConditions:
            return "Chronic Conditions".localized()
        case .healthRecords:
            return "Health Records".localized()
        }
    }
}

class PatientDetailsPresenter: PatientDetailsPresentationLogic {
    
  weak var presenterOutput: PatientDetailsDisplayLogic?
    
    func presentationForPatientsDescription(response: PatientDetails.AttributeProcessing.Response) {
        presenterOutput?.displayPatientDetails(viewModel: PatientDetails.AttributeProcessing.ViewModel(patientDetails: response.patientDetails))
    }
    
    func processDeletePatientOperation(response: PatientDetails.Delete.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        presenterOutput?.displayDeletePatientResult(viewModel: PatientDetails.Delete.ViewModel(isSuccessful: response.isSuccessful,
                                                                                               deletedPatient: response.patient,
                                                                                               errorMessage: errorMessage))
    }
    
    func presentAssignedPatientTag(response: PatientDetails.AssignTag.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        presenterOutput?.displayAssignedPatientTag(viewModel: PatientDetails.AssignTag.ViewModel(isSuccessful: response.isSuccessful,
                                                                                               errorMessage: errorMessage,
                                                                                               patientTag: response.patientTag))
    }
    
    func presentUnassignedPatientTag(response: PatientDetails.UnassignTag.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        presenterOutput?.displayUnassignedPatientTag(viewModel: PatientDetails.UnassignTag.ViewModel(isSuccessful: response.isSuccessful,
                                                                                                 errorMessage: errorMessage))
    }
    
    func presentPerformedSubscriptionToggle(response: PatientDetails.SubscribeToggle.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        presenterOutput?.displayPerformedSubscriptionToggle(viewModel: PatientDetails.SubscribeToggle.ViewModel(isSuccessful: response.isSuccessful,
                                                                                                                isSubscribed: response.isSubscribed,
                                                                                                                errorMessage: errorMessage))
    }
    
}
