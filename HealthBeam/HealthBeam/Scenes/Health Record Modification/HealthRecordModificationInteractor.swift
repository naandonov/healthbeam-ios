//
//  HealthRecordModificationInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol HealthRecordModificationBusinessLogic {
    var presenter: HealthRecordModificationPresentationLogic? { get set }
    
    func requestDataStore(request: HealthRecordModification.DataSource.Request)
    func requestHealthRecordCreation(request: HealthRecordModification.Create.Request)
    func requestHealthRecordUpdate(request: HealthRecordModification.Update.Request)
    
    func getExternalUser(completion: (UserProfile.ExternalModel) -> Void)
}

protocol HealthRecordModificationDataStore {
    var patient: Patient? { get set }
    var healthRecord: HealthRecord? { get set }
    var modificationDelegate: HealthRecordsModificationProtocol? { get set }
    var healthRecordViewControllerProvider: Provider<HealthRecordViewController>? { get set}
    var healthRecordUpdateHandler: HealthRecordUpdateProtocol? { get set }
}

class HealthRecordModificationInteractor: HealthRecordModificationBusinessLogic, HealthRecordModificationDataStore {
    
  var presenter: HealthRecordModificationPresentationLogic?
    
    private let networkingManager: NetworkingManager
    private let coreDataHandler: CoreDataHandler
    
    var patient: Patient?
    var healthRecord: HealthRecord?
    weak var healthRecordUpdateHandler: HealthRecordUpdateProtocol?
    
    weak var modificationDelegate: HealthRecordsModificationProtocol?
    var healthRecordViewControllerProvider: Provider<HealthRecordViewController>?
    
    func requestDataStore(request: HealthRecordModification.DataSource.Request) {
        presenter?.presentDatasource(response: HealthRecordModification.DataSource.Response(healthRecord: healthRecord))
    }
    
    func requestHealthRecordCreation(request: HealthRecordModification.Create.Request) {
        guard let patientId = patient?.id else {
            presenter?.presentCreatedHealthRecord(response: HealthRecordModification.Create.Response(isSuccessful: false,
                                                                                                     healthRecord: nil,
                                                                                                     error: nil))
            return
        }
        let operation = CreateHealthRecordOperation(patientId: patientId, healthRecord: request.healthRecord) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                strongSelf.healthRecord = responseObject.value
                strongSelf.presenter?.presentCreatedHealthRecord(response: HealthRecordModification.Create.Response(isSuccessful: true, healthRecord: responseObject.value, error: nil))
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.presentCreatedHealthRecord(response: HealthRecordModification.Create.Response(isSuccessful: false, healthRecord: nil, error: responseObject))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    func requestHealthRecordUpdate(request: HealthRecordModification.Update.Request) {
        let operation = UpdateHealthRecordOperation(healthRecord: request.healthRecord) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                strongSelf.healthRecord = responseObject.value
                strongSelf.presenter?.presentUpdateHealthRecord(response: HealthRecordModification.Update.Response(isSuccessful: true, healthRecord: responseObject.value, error: nil))
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.presentUpdateHealthRecord(response: HealthRecordModification.Update.Response(isSuccessful: false, healthRecord: nil, error: responseObject))
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
