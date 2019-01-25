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
    func cancelSearchRequestFor(page: Int)
    
}

protocol PatientsSearchDataStore {
    
}

class PatientsSearchInteractor: PatientsSearchBusinessLogic, PatientsSearchDataStore {
    
    var presenter: PatientsSearchPresentationLogic?
    
    private var searchOperations: [Int: Operation] = [:]
    
    func retrievePatients(request: PatientsSearch.Retrieval.Request) {
        cancelSearchRequestFor(page: request.page)
        
        let operation = GetPatientsOperation(patientsSegment: request.segment, searchQuery: request.searchQuery, pageQuery: request.page) {[weak self] result in
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
    
    func cancelSearchRequestFor(page: Int) {
        if let operation = searchOperations[page] {
            operation.cancel()
        }
    }
    
}
