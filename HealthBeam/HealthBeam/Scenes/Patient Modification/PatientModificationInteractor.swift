//
//  PatientModificationInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol PatientModificationBusinessLogic {
    var presenter: PatientModificationPresentationLogic? { get set }
    
    func requestDataSource(request: PatientModification.DataSource.Request)
    
    func requestPatientCreation(request: PatientModification.Create.Request)
    func requestPatientUpdate(request: PatientModification.Update.Request)

    func getExternalUser(completion: (UserProfile.ExternalModel) -> Void)
}

protocol PatientModificationDataStore {
    var patient: Patient? { get set }
    var modificationDelegate: PatientsModificationProtocol? { get set }
    var patientDetailsViewControllerProvider: Provider<PatientDetailsViewController>? { get set}
}

class PatientModificationInteractor: PatientModificationBusinessLogic, PatientModificationDataStore {
    
    var presenter: PatientModificationPresentationLogic?

    weak var modificationDelegate: PatientsModificationProtocol?

    var patient: Patient?
    
    private let networkingManager: NetworkingManager
    private let coreDataHandler: CoreDataHandler

    var patientDetailsViewControllerProvider: Provider<PatientDetailsViewController>?
    
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
                strongSelf.patient = responseObject.value
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
                strongSelf.patient = responseObject.value
                strongSelf.presenter?.presentUpdatePatient(response: PatientModification.Update.Response(isSuccessful: true, patient: responseObject.value, error: nil))
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.presentUpdatePatient(response: PatientModification.Update.Response(isSuccessful: false, patient: nil, error: responseObject))
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

    init(networkingManager: NetworkingManager, coreDataHandler: CoreDataHandler) {
        self.networkingManager = networkingManager
        self.coreDataHandler = coreDataHandler
    }
}
