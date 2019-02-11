//
//  PatientsSearchPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientsSearchPresentationLogic {
    var presenterOutput: PatientsSearchDisplayLogic? { get set }
    
    func handlePatientsSearchResult(response: PatientsSearch.Retrieval.Response)
    func handleLocateNearbyPatientsResult(response: PatientsSearch.Nearby.Response)
    func handlePatientAttributesResult(response: PatientsSearch.Attributes.Response)

}

class PatientsSearchPresenter: PatientsSearchPresentationLogic {
    
  weak var presenterOutput: PatientsSearchDisplayLogic?
    
    func handlePatientsSearchResult(response: PatientsSearch.Retrieval.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        
        presenterOutput?.processPatientsSearchReult(viewModel: PatientsSearch.Retrieval.ViewModel(isSuccessful: response.isSuccessful, errorMessage: errorMessage))
    }
    
    func handleLocateNearbyPatientsResult(response: PatientsSearch.Nearby.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        
        presenterOutput?.processLocateNearbyPatientsReult(viewModel: PatientsSearch.Nearby.ViewModel(isSuccessful: response.isSuccessful, errorMessage: errorMessage))
    }
    
    func handlePatientAttributesResult(response: PatientsSearch.Attributes.Response) {
        var errorMessage: String?
        if !response.isSuccessful {
            if let error = response.error {
                errorMessage = error.userFiendlyDescription
            } else {
                errorMessage = "Unknowned error has occured".localized()
            }
        }
        
        presenterOutput?.processPatientAttributesReult(viewModel: PatientsSearch.Attributes.ViewModel(isSuccessful: response.isSuccessful, errorMessage: errorMessage))
    }
    
}
