//
//  HealthRecordInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol HealthRecordBusinessLogic {
    var presenter: HealthRecordPresentationLogic? { get set }
    
    func requestHealthRecords(request: HealthRecordModel.Get.Request)
    func deleteHealthRecord(request: HealthRecordModel.Delete.Request)

}

protocol HealthRecordDataStore {
    var healthRecord: HealthRecord? { get set }
    var modificationDelegate: HealthRecordsModificationProtocol? { get set }
}

class HealthRecordInteractor: HealthRecordBusinessLogic, HealthRecordDataStore {
    
    var presenter: HealthRecordPresentationLogic?
    
    var healthRecord: HealthRecord?
    weak var modificationDelegate: HealthRecordsModificationProtocol?
    private let networkingManager: NetworkingManager
    
    func requestHealthRecords(request: HealthRecordModel.Get.Request) {
        if let healthRecord = healthRecord {
            presenter?.formatHealthRecords(response: HealthRecordModel.Get.Response(healthRecord: healthRecord))
        }
    }
    
    func deleteHealthRecord(request: HealthRecordModel.Delete.Request) {
        guard let healthRecordId = request.healthRecord.id else {
            presenter?.processDeleteHealthRecordOperation(response: HealthRecordModel.Delete.Response(isSuccessful: false, healthRecord: request.healthRecord, error: nil))
            return
        }

        let operation = DeleteHealthRecordOperation(healthRecordId: healthRecordId) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value, value.type == .success   {
                    strongSelf.presenter?.processDeleteHealthRecordOperation(response: HealthRecordModel.Delete.Response(isSuccessful: true, healthRecord: request.healthRecord, error: nil))
                } else {
                    strongSelf.presenter?.processDeleteHealthRecordOperation(response: HealthRecordModel.Delete.Response(isSuccessful: false, healthRecord: request.healthRecord, error: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.processDeleteHealthRecordOperation(response: HealthRecordModel.Delete.Response(isSuccessful: false, healthRecord: request.healthRecord, error: responseObject))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    init(networkingManager: NetworkingManager) {
        self.networkingManager = networkingManager
    }
}
