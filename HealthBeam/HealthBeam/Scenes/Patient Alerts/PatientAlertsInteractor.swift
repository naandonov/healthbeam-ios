//
//  PatientAlertsInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias PatientAlertsHandler = (BatchResult<PatientAlert>) -> Void


protocol PatientAlertsBusinessLogic {
    var presenter: PatientAlertsPresentationLogic? { get set }
    
    func retrievePendingPatientAlerts(request: PatientAlerts.Pending.Request)
}

protocol PatientAlertsDataStore {
    
}

class PatientAlertsInteractor: PatientAlertsBusinessLogic, PatientAlertsDataStore {
    
    var presenter: PatientAlertsPresentationLogic?
    private let networkingManager: NetworkingManager
    
    func retrievePendingPatientAlerts(request: PatientAlerts.Pending.Request) {
        let operation = GetPendingAlertsOperation() { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value  {
                    
                    request.handler(BatchResult.generateOnePageResultForModel(value))
                    strongSelf.presenter?.handlePatientAlertsPendingResult(response: PatientAlerts.Pending.Response(isSuccessful: true, error: nil))
                } else {
                    strongSelf.presenter?.handlePatientAlertsPendingResult(response: PatientAlerts.Pending.Response(isSuccessful: false, error: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.handlePatientAlertsPendingResult(response: PatientAlerts.Pending.Response(isSuccessful: false, error: responseObject))
                
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    init(networkingManager: NetworkingManager) {
        self.networkingManager = networkingManager
    }
}
