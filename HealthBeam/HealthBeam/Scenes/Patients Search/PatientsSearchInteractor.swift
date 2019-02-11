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
    
    func retrieveNearbyPatients(request: PatientsSearch.Nearby.Request)

    func cancelSearchRequestFor(page: Int)
    
}

protocol PatientsSearchDataStore {
    var selectedPatient: Patient? { get set }
    var selectedPatientAttributes: PatientAttributes? { get set }
    var mode: PatientsSearch.Mode? { get set }
}

class PatientsSearchInteractor: PatientsSearchBusinessLogic, PatientsSearchDataStore {
    
    var presenter: PatientsSearchPresentationLogic?
    
    var selectedPatient: Patient?
    var selectedPatientAttributes: PatientAttributes?
    var mode: PatientsSearch.Mode?
    
    private static let locatingTimeInterval: TimeInterval = 5.0
    private let beaconsManager: BeaconsManager
    private var locatedBeacons: [Beacon] = []
    private let coreDataHandler: CoreDataHandler
    private let notificationCenter: NotificationCenter

    private var searchOperations: [Int: Operation] = [:]
    private let networkingManager: NetworkingManager
    
    deinit {
        forceStopLocatingBeacons()
    }
    
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
        networkingManager.addNetwork(operation: operation)
    }
    
    func retrieveNearbyPatients(request: PatientsSearch.Nearby.Request) {
        
        locateNearbyBeacons { [weak self] beacons in
            
            let operation = LocateNearbyPatientsOpearation(beacons: beacons) {[weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case let .success(responseObject):
                    if let value = responseObject.value  {
                        request.handler(BatchResult.generateOnePageResultForModel(value))
                        strongSelf.presenter?.handleLocateNearbyPatientsResult(response: PatientsSearch.Nearby.Response(isSuccessful: true, error: nil))
                    } else {
                        strongSelf.presenter?.handleLocateNearbyPatientsResult(response: PatientsSearch.Nearby.Response(isSuccessful: false, error: nil))
                    }
                case let .failure(responseObject):
                    log.error(responseObject.description)
                    strongSelf.presenter?.handleLocateNearbyPatientsResult(response: PatientsSearch.Nearby.Response(isSuccessful: false, error: responseObject))
                    
                }
            }
            self?.networkingManager.addNetwork(operation: operation)
        }
        
    }
    
    func retrievePatientAttributes(request: PatientsSearch.Attributes.Request) {
        guard let patientId = request.selectedPatient.id else {
            presenter?.handlePatientAttributesResult(response: PatientsSearch.Attributes.Response(isSuccessful: false, error: nil))
            return
        }
        
        let operation = GetPatientAttributesOperation(patientId: patientId) { [weak self] result in
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
    
    init(networkingManager: NetworkingManager, beaconsManager: BeaconsManager, coreDataHandler: CoreDataHandler, notificationCenter: NotificationCenter) {
        self.networkingManager = networkingManager
        self.beaconsManager = beaconsManager
        self.notificationCenter = notificationCenter
        self.coreDataHandler = coreDataHandler
    }
}

//MARK: Beacons Scanning

extension PatientsSearchInteractor {
    
    
    private func locateNearbyBeacons(completion: @escaping ([Beacon]) -> Void) {
        shouldListenForTrackingBeaconsNotifications(true)
        coreDataHandler.getUserProfile() { [weak self] userModel in
            guard let discoveryRegions = userModel?.discoveryRegions else {
                completion([])
                return
            }
            beaconsManager.startListentingForBeaconsInProximity(searchRegions: discoveryRegions)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + PatientsSearchInteractor.locatingTimeInterval) { [weak self] in
                guard let strongSelf = self else {
                    completion([])
                    return
                }
                
                strongSelf.forceStopLocatingBeacons()
                strongSelf.locatedBeacons.sort() { $0.accuracy < $1.accuracy }
                completion(strongSelf.locatedBeacons)
                strongSelf.locatedBeacons = []
            }
            
        }
        
    }
    
    func forceStopLocatingBeacons() {
        beaconsManager.stopListeningForBeacons()
        shouldListenForTrackingBeaconsNotifications(false)
    }
    
    private func shouldListenForTrackingBeaconsNotifications(_ shouldListen: Bool) {
        if shouldListen {
            notificationCenter.setObserver(self,
                                           selector: #selector(didLocateBeacons),
                                           name: BeaconsManager.Constants.Notifications.BeaconsFound,
                                           object: nil)
        }
        else {
            notificationCenter.removeObserver(self, name: BeaconsManager.Constants.Notifications.BeaconsFound, object: nil)
        }
    }
}

//MARK: - Notification Observers

extension PatientsSearchInteractor {
    
    @objc private func didLocateBeacons(_ notification: Notification) {
        if let beacons = notification.userInfo?[BeaconsManager.Constants.Notifications.UserInfoBeaconsKey] as? [Beacon] {
            for beacon in beacons {
                locatedBeacons.removeAll { $0 == beacon }
                locatedBeacons.append(beacon)
            }
        }
    }
}
