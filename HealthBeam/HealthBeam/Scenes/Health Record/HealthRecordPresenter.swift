//
//  HealthRecordPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol HealthRecordPresentationLogic {
    var presenterOutput: HealthRecordDisplayLogic? { get set }
    
    func formatHealthRecords(response: HealthRecordModel.Get.Response)
    func processDeleteHealthRecordOperation(response: HealthRecordModel.Delete.Response)
}

class HealthRecordPresenter: HealthRecordPresentationLogic {
    
    weak var presenterOutput: HealthRecordDisplayLogic?
    
    func formatHealthRecords(response: HealthRecordModel.Get.Response) {
        let dataSource = dataSourceForHealthRecord(response.healthRecord)
        presenterOutput?.displayHealthRecords(viewModel: HealthRecordModel.Get.ViewModel(dataSource: dataSource))
    }
    
    func processDeleteHealthRecordOperation(response: HealthRecordModel.Delete.Response) {
        
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        presenterOutput?.displayDeleteHealthRecordResult(viewModel: HealthRecordModel.Delete.ViewModel(isSuccessful: response.isSuccessful,
                                                                                                       healthRecord: response.healthRecord,
                                                                                                       errorMessage: errorMessage))
        
    }
    
    private func dataSourceForHealthRecord(_ healthRecord: HealthRecord) -> HealthRecordModel.DataSource {
        let healthRecord = healthRecord
        var displayElements: [ContentDisplayController.DisplayElement] = [
            .standard(title: "Treatement".localized(), content: healthRecord.treatment),
            .standard(title: "Prescription".localized(), content: healthRecord.prescription)
        ]
        
        if let notes = healthRecord.notes, notes.count > 0 {
            displayElements.append(.standard(title: "Notes".localized(), content: notes))
        }
        
        let creationDate = healthRecord.createdDate.simpleDateString()
        
        return HealthRecordModel.DataSource(displayElements: displayElements,
                                            creatorName: healthRecord.creator?.fullName ?? "",
                                            creatorDesignation: healthRecord.creator?.designation ?? "",
                                            creationDate: creationDate,
                                            disgnosis: healthRecord.diagnosis)
    }
    
}
