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
    func assignPatientTag(request: PatientDetails.AssignTag.Request)
    func unassignPatientTag(request: PatientDetails.UnassignTag.Request)
    func performSubscriptionToggle(request: PatientDetails.SubscribeToggle.Request)
    
    func getExternalUser(completion: (UserProfile.ExternalModel) -> Void)
}

protocol PatientDetailsDataStore {
    var patient: Patient? { get set }
    var patientAttributes: PatientAttributes? { get set }
    var modificationDelegate: PatientsModificationProtocol? { get set }
}

class PatientDetailsInteractor: PatientDetailsBusinessLogic, PatientDetailsDataStore {
    
    var patient: Patient?
    var patientAttributes: PatientAttributes?
    private let coreDataHandler: CoreDataHandler
    private let networkingManager: NetworkingManager
    
    var presenter: PatientDetailsPresentationLogic?
    weak var modificationDelegate: PatientsModificationProtocol?
    
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
        guard let patientId = request.patient.id else {
            presenter?.processDeletePatientOperation(response: PatientDetails.Delete.Response(isSuccessful: false, patient: request.patient, error: nil))
            return
        }
        
        let operation = DeletePatientOperation(patientId: patientId) { [weak self] result in
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
    
    func getExternalUser(completion: (UserProfile.ExternalModel) -> Void) {
        coreDataHandler.getUserProfile { user in
            if let user = user {
                let externalUser = UserProfile.ExternalModel(id: user.id,
                                                             fullName: user.fullName,
                                                             designation: user.designation)
                completion(externalUser)
            }
        }
    }
    
    func assignPatientTag(request: PatientDetails.AssignTag.Request) {
        guard let patientId = patient?.id else {
            presenter?.presentAssignedPatientTag(response: PatientDetails.AssignTag.Response(isSuccessful: false, error: nil, patientTag: nil))
            return
        }
        
        let operation = AssignPatientTagOperation(patientId: patientId, beacon: request.beacon) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value  {
                    strongSelf.patientAttributes?.patientTag = value
                    strongSelf.presenter?.presentAssignedPatientTag(response: PatientDetails.AssignTag.Response(isSuccessful: true, error: nil, patientTag: value))
                } else {
                      strongSelf.presenter?.presentAssignedPatientTag(response: PatientDetails.AssignTag.Response(isSuccessful: true, error: nil, patientTag: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                  strongSelf.presenter?.presentAssignedPatientTag(response: PatientDetails.AssignTag.Response(isSuccessful: false, error: responseObject, patientTag: nil))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    func unassignPatientTag(request: PatientDetails.UnassignTag.Request) {
        guard let patientId = patient?.id else {
            presenter?.presentUnassignedPatientTag(response: PatientDetails.UnassignTag.Response(isSuccessful: false, error: nil))
            return
        }
        
        let operation = UnassignPatientTagOperation(patientId: patientId) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case  .success:
                strongSelf.patientAttributes?.patientTag = nil
                strongSelf.presenter?.presentUnassignedPatientTag(response: PatientDetails.UnassignTag.Response(isSuccessful: true, error: nil))
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.presentUnassignedPatientTag(response: PatientDetails.UnassignTag.Response(isSuccessful: false, error: responseObject))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    func performSubscriptionToggle(request: PatientDetails.SubscribeToggle.Request) {
        guard let patientId = patient?.id else {
            presenter?.presentPerformedSubscriptionToggle(response: PatientDetails.SubscribeToggle.Response(isSuccessful: false, isSubscribed: nil, error: nil))
            return
        }
        let toggleRequest = PatientDetails.SubscriptionToggleRequest(patientId: patientId)
        let operation = SubscriptionToggleOperation(toggleRequest: toggleRequest) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value {
                    strongSelf.coreDataHandler.getUserProfile(completition: { [weak self] userModel in
            
                        if let userModel = userModel {
                            if value.isSubscribed {
                                self?.patientAttributes?.observers?.removeAll() { $0.id == userModel.id}
                                self?.patientAttributes?.observers?.append(UserProfile.ExternalModel(id: userModel.id,fullName: userModel.fullName, designation: userModel.designation))
                            } else {
                                self?.patientAttributes?.observers?.removeAll() { $0.id == userModel.id}
                            }
                        }

                        strongSelf.presenter?.presentPerformedSubscriptionToggle(response: PatientDetails.SubscribeToggle.Response(isSuccessful: true, isSubscribed: value.isSubscribed, error: nil))
                        
                    })
                } else {
                    strongSelf.presenter?.presentPerformedSubscriptionToggle(response: PatientDetails.SubscribeToggle.Response(isSuccessful: true, isSubscribed: nil, error: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.presentPerformedSubscriptionToggle(response: PatientDetails.SubscribeToggle.Response(isSuccessful: false, isSubscribed: nil, error: nil))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    init(coreDataHandler: CoreDataHandler, networkingManager: NetworkingManager) {
        self.coreDataHandler = coreDataHandler
        self.networkingManager = networkingManager
    }
}
