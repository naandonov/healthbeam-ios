//
//  HealthRecordModificationPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol HealthRecordModificationPresentationLogic {
    var presenterOutput: HealthRecordModificationDisplayLogic? { get set }
    
    func presentDatasource(response: HealthRecordModification.DataSource.Response)
    func presentCreatedHealthRecord(response: HealthRecordModification.Create.Response)
    func presentUpdateHealthRecord(response: HealthRecordModification.Update.Response)
}

class HealthRecordModificationPresenter: HealthRecordModificationPresentationLogic {
    
  weak var presenterOutput: HealthRecordModificationDisplayLogic?
    
    func presentDatasource(response: HealthRecordModification.DataSource.Response) {
        guard let healthRecord = response.healthRecord else {
            return
        }
        
        let dataSource =  ModificationDatasource(element: healthRecord, inputDescriptors: [
            .notes(title: "Diagnosis".localized(), keyPath: \.diagnosis, isRequired: true),
            .notes(title: "Treatement".localized(), keyPath: \.treatment, isRequired: true),
            .notes(title: "Prescription".localized(), keyPath: \.prescription, isRequired: true),
            .notesOptional(title: "Notes".localized(), keyPath: \.notes, isRequired: false)
            ])
        presenterOutput?.displayDatasource(viewModel: HealthRecordModification.DataSource.ViewModel(dataSource: dataSource))
    }

    
    func presentCreatedHealthRecord(response: HealthRecordModification.Create.Response) {
            var errorMessage: String?
            if !response.isSuccessful {
                if let error = response.error {
                    errorMessage = error.userFiendlyDescription
                } else {
                    errorMessage = "Unknowned error has occured".localized()
                }
            }
            presenterOutput?.displayCreatedHealthRecord(viewModel: HealthRecordModification.Create.ViewModel(isSuccessful:
                response.isSuccessful,
                                                                                                   healthRecord: response.healthRecord,
                                                                                                   errorMessage: errorMessage))
    }
    
    func presentUpdateHealthRecord(response: HealthRecordModification.Update.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        presenterOutput?.displayUpdatedHealthRecord(viewModel: HealthRecordModification.Update.ViewModel(isSuccessful:
            response.isSuccessful,
                                                                                               healthRecord: response.healthRecord,
                                                                                               errorMessage: errorMessage))
    }
}
