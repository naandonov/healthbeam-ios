//
//  PatientDetailsInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientDetailsBusinessLogic {
    var presenter: PatientDetailsPresentationLogic? { get set }
    
    func handlePatientDetails(request: PatientDetails.AttributeProcessing.Request)
}

protocol PatientDetailsDataStore {
    var patient: Patient? { get set }
    var patientAttributes: PatientAttributes? { get set }
}

class PatientDetailsInteractor: PatientDetailsBusinessLogic, PatientDetailsDataStore {
    
    var patient: Patient?
    var patientAttributes: PatientAttributes?
    let coreDataHandler: CoreDataHandler
    
    var presenter: PatientDetailsPresentationLogic?
    
    func handlePatientDetails(request: PatientDetails.AttributeProcessing.Request) {
        guard let patient = patient, let patientAttributes = patientAttributes else {
            return
        }
        
        coreDataHandler.getUserProfile { user in
            let isObserved: Bool
            if let observers = patientAttributes.observers, observers.filter({ $0.id == user?.id}).count > 0 {
                isObserved = true
            } else {
                isObserved = false
            }
            let patientDetails = PatientDetails.Model(patient: patient,
                                             healthRecords: patientAttributes.healthRecords ?? [],
                                             patientTag: patientAttributes.patientTag,
                                             isObserved: isObserved)
            
            presenter?.presentationForPatientsDescription(response: PatientDetails.AttributeProcessing.Response(patientDetails: patientDetails))
        }
    }
    
    init(coreDataHandler: CoreDataHandler) {
        self.coreDataHandler = coreDataHandler
    }
}
