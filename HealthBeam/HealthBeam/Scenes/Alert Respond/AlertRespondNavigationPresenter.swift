//
//  AlertRespondNavigationPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol AlertRespondNavigationPresentationLogic {
    var presenterOutput: AlertRespondNavigationDisplayLogic? { get set }
    
    func prepareAlertDescription(response: AlertRespondNavigation.DescriptionDatasource.Response)
    func preparePatientSearchResult(response: AlertRespondNavigation.PatientSearch.Response)
    func prepareRespondResult(response: AlertRespondNavigation.Respond.Response)
}

class AlertRespondNavigationPresenter: AlertRespondNavigationPresentationLogic {
    
    weak var presenterOutput: AlertRespondNavigationDisplayLogic?
    
    func prepareAlertDescription(response: AlertRespondNavigation.DescriptionDatasource.Response) {

            guard let patient = response.patient,
                let triggerLocation = response.triggerLocation,
                let triggerDate = response.triggerDate,
                let tagCharecteristics = response.tagCharecteristics else {
            presenterOutput?.processAlertDescriptionDatasource(viewModel: AlertRespondNavigation.DescriptionDatasource.ViewModel(dataSource: nil, isSuccessful: false))
            return
        }
            
        var dataSource: [AlertRespondNavigation.DescriptionModel] = []
        dataSource.append(AlertRespondNavigation.DescriptionModel(designation: .patientInfo(name: patient.fullName,
                                                                                            description: patient.shortDescription)))
        dataSource.append(AlertRespondNavigation.DescriptionModel(designation: .trgiggerLocation(location: triggerLocation)))
        dataSource.append(AlertRespondNavigation.DescriptionModel(designation: .triggerDate(date: triggerDate)))
        dataSource.append(AlertRespondNavigation.DescriptionModel(designation: .tagCharecteristics(tagCharecteristics: tagCharecteristics)))
        
        presenterOutput?.processAlertDescriptionDatasource(viewModel: AlertRespondNavigation.DescriptionDatasource.ViewModel(dataSource: dataSource, isSuccessful: true))
    }
    
    func preparePatientSearchResult(response: AlertRespondNavigation.PatientSearch.Response) {
        let errorMessage = response.isSuccessful ? nil : "Unable to locate patient tags".localized()
        presenterOutput?.processPatientSearchResult(viewModel: AlertRespondNavigation.PatientSearch.ViewModel(isSuccessful: response.isSuccessful, errorMessage: errorMessage))
    }
    
    func prepareRespondResult(response: AlertRespondNavigation.Respond.Response) {
        let errorMessage = response.error?.userFiendlyDescription
        presenterOutput?.processRespondResult(viewModel: AlertRespondNavigation.Respond.ViewModel(isSuccessful: response.isSuccessful, errorMessage: errorMessage))
    }

}
