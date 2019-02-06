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
}

enum PatientDetailsSection: Int {
    case alergies
    case chronicConditions
    case healthRecords
    
    var sectionTitle: String {
        switch self {
            
        case .alergies:
            return "Alergies".localized()
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
    
}
