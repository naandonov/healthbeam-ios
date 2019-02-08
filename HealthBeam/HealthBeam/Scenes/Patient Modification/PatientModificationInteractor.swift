//
//  PatientModificationInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientModificationBusinessLogic {
    var presenter: PatientModificationPresentationLogic? { get set }
    
    func requestDataSource(request: PatientModification.DataSource.Request)
    
    func requestPatientCreation(request: PatientModification.Create.Request)
    func requestPatientUpdate(request: PatientModification.Update.Request)
}

protocol PatientModificationDataStore {
    var patient: Patient? { get set }
}

class PatientModificationInteractor: PatientModificationBusinessLogic, PatientModificationDataStore {
    
  var presenter: PatientModificationPresentationLogic?
    
    var patient: Patient?
    
    private let networkingManager: NetworkingManager
    
    func requestDataSource(request: PatientModification.DataSource.Request) {
        presenter?.presentDatasource(response: PatientModification.DataSource.Response(patient: patient))
    }
    
    func requestPatientCreation(request: PatientModification.Create.Request) {
        let operation = CreatePatientOperation(patient: request.patient) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                print(responseObject.value)
                strongSelf.presenter?.presentCreatedPatient(response: PatientModification.Create.Response(isSuccessful: true, patient: responseObject.value, error: nil))
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.presentCreatedPatient(response: PatientModification.Create.Response(isSuccessful: false, patient: nil, error: responseObject))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    func requestPatientUpdate(request: PatientModification.Update.Request) {
        let operation = UpdatePatientOperation(patient: request.patient) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                strongSelf.presenter?.presentUpdatePatient(response: PatientModification.Update.Response(isSuccessful: true, patient: responseObject.value, error: nil))
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.presentUpdatePatient(response: PatientModification.Update.Response(isSuccessful: false, patient: nil, error: responseObject))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    init(networkingManager: NetworkingManager) {
        self.networkingManager = networkingManager
    }
}
