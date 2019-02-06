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
    func deletePatient(request: PatientDetails.Delete.Request)
}

protocol PatientDetailsDataStore {
    var patient: Patient? { get set }
    var patientAttributes: PatientAttributes? { get set }
}

class PatientDetailsInteractor: PatientDetailsBusinessLogic, PatientDetailsDataStore {
    
    var patient: Patient?
    var patientAttributes: PatientAttributes?
    private let coreDataHandler: CoreDataHandler
    private let networkingManager: NetworkingManager
    
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
    
    func deletePatient(request: PatientDetails.Delete.Request) {
        let operation = DeletePatientOperation(patientId: request.patient.id) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value, value.type == .success   {
                    strongSelf.presenter?.processDeletePatientOperation(response: PatientDetails.Delete.Response(isSuccessful: true, patient: request.patient, error: nil))
                } else {
                    strongSelf.presenter?.processDeletePatientOperation(response: PatientDetails.Delete.Response(isSuccessful: false, patient: request.patient, error: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.processDeletePatientOperation(response: PatientDetails.Delete.Response(isSuccessful: false, patient: request.patient, error: responseObject))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    init(coreDataHandler: CoreDataHandler, networkingManager: NetworkingManager) {
        self.coreDataHandler = coreDataHandler
        self.networkingManager = networkingManager
    }
}
