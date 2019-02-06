//
//  PatientsSearchInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias PatientsSearchHandler = (BatchResult<Patient>) -> ()

protocol PatientsSearchBusinessLogic {
    var presenter: PatientsSearchPresentationLogic? { get set }
    
    func retrievePatients(request: PatientsSearch.Retrieval.Request)
    func retrievePatientAttributes(request: PatientsSearch.Attributes.Request)

    func cancelSearchRequestFor(page: Int)
    
}

protocol PatientsSearchDataStore {
    var selectedPatient: Patient? { get set }
    var selectedPatientAttributes: PatientAttributes? { get set }
}

class PatientsSearchInteractor: PatientsSearchBusinessLogic, PatientsSearchDataStore {
    
    var presenter: PatientsSearchPresentationLogic?
    
    var selectedPatient: Patient?
    var selectedPatientAttributes: PatientAttributes?
    
    private var searchOperations: [Int: Operation] = [:]
    
    func retrievePatients(request: PatientsSearch.Retrieval.Request) {
        cancelSearchRequestFor(page: request.page)
        
        let segment: PatientsSearch.Segment
        if let selectedSegment = request.segment {
            segment = selectedSegment
        }
        else {
            segment = PatientsSearch.Segment.all
        }
        
        let operation = GetPatientsOperation(patientsSegment: segment, searchQuery: request.searchQuery, pageQuery: request.page) {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value  {
                    request.handler(value)
                    strongSelf.presenter?.handlePatientsSearchResult(response: PatientsSearch.Retrieval.Response(isSuccessful: true, error: nil))
                } else {
                    strongSelf.presenter?.handlePatientsSearchResult(response: PatientsSearch.Retrieval.Response(isSuccessful: false, error: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.handlePatientsSearchResult(response: PatientsSearch.Retrieval.Response(isSuccessful: false, error: responseObject))
                
            }
            strongSelf.searchOperations.removeValue(forKey: request.page)
        }
        searchOperations[request.page] = operation
        NetworkingManager.shared.addNetwork(operation: operation)
    }
    
    func retrievePatientAttributes(request: PatientsSearch.Attributes.Request) {
        
        let operation = GetPatientAttributesOperation(patientId: request.selectedPatient.id) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value  {
                    strongSelf.selectedPatient = request.selectedPatient
                    strongSelf.selectedPatientAttributes = value
                    strongSelf.presenter?.handlePatientAttributesResult(response: PatientsSearch.Attributes.Response(isSuccessful: true, error: nil))

                } else {
                    strongSelf.presenter?.handlePatientAttributesResult(response: PatientsSearch.Attributes.Response(isSuccessful: false, error: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.handlePatientAttributesResult(response: PatientsSearch.Attributes.Response(isSuccessful: false, error: responseObject))
                
            }
            
        }
        NetworkingManager.shared.addNetwork(operation: operation)
        
    }
    
    func cancelSearchRequestFor(page: Int) {
        if let operation = searchOperations[page] {
            operation.cancel()
        }
    }
    
}
