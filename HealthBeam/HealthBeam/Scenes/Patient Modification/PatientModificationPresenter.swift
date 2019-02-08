//
//  PatientModificationPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientModificationPresentationLogic {
    var presenterOutput: PatientModificationDisplayLogic? { get set }
    
    func presentDatasource(response: PatientModification.DataSource.Response)
    
    func presentCreatedPatient(response: PatientModification.Create.Response)
    func presentUpdatePatient(response: PatientModification.Update.Response)
}

class PatientModificationPresenter: PatientModificationPresentationLogic {
    
  weak var presenterOutput: PatientModificationDisplayLogic?
    
    struct Patientzz: Codable {
        let id: Int
        var fullName: String
        var gender: String
        var personalIdentification: String
        var birthDate: Date?
        var bloodType: String
        var alergies: [String]
        var chronicConditions: [String]
        var notes: String?
        var premiseLocation: String?
    }
    
    func presentDatasource(response: PatientModification.DataSource.Response) {
        guard let patient = response.patient else {
            return
        }
        
        let dataSource =  ModificationDatasource(element: patient, inputDescriptors: [
            .standard(title: "Full Name".localized(), keyPath: \.fullName, keyboardType: .default, isRequired: true),
            .itemsPicker(title: "Gender".localized(), keyPath: \.gender, model: DataProvider.genders, isRequired: true),
            .standard(title: "Personal Identification".localized(), keyPath: \.personalIdentification, keyboardType: .numberPad, isRequired: true),
            .datePickerOptional(title: "Birth Date".localized(), keyPath: \.birthDate, isRequired: true),
            .itemsPicker(title: "Blood Type".localized(), keyPath: \.bloodType, model: DataProvider.bloodTypes, isRequired: true),
            .multitude(title: "Alergies".localized(), keyPath: \.alergies, isRequired: false),
            .multitude(title: "Chronic Conditions".localized(), keyPath: \.chronicConditions, isRequired: false),
            .notesOptional(title: "Premise Location".localized(), keyPath: \.notes, isRequired: false)
        ])
        presenterOutput?.displayDatasource(viewModel: PatientModification.DataSource.ViewModel(dataSource: dataSource))
    }
    
    func presentCreatedPatient(response: PatientModification.Create.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        presenterOutput?.displayCreatedPatient(viewModel: PatientModification.Create.ViewModel(isSuccessful:
            response.isSuccessful,
                                                                                               patient: response.patient,
                                                                                               errorMessage: errorMessage))
    }
    
    func presentUpdatePatient(response: PatientModification.Update.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        presenterOutput?.displayUpdatedPatient(viewModel: PatientModification.Update.ViewModel(isSuccessful:
            response.isSuccessful,
                                                                                               patient: response.patient,
                                                                                               errorMessage: errorMessage))
    }
}
