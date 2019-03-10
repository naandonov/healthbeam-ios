//
//  AlertRespondNavigationInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol AlertRespondNavigationBusinessLogic {
    var presenter: AlertRespondNavigationPresentationLogic? { get set }
    
    func requestAlertDescription(request: AlertRespondNavigation.DescriptionDatasource.Request)
    func startSearchingForPatient(request: AlertRespondNavigation.PatientSearch.Request)
    func respondToAlert(request: AlertRespondNavigation.Respond.Request)
}

protocol AlertRespondNavigationDataStore {
    var patientAlert: PatientAlert? { get set }
    
    var alertResponderHandler: AlertResponderHandler? { get set }
}

class AlertRespondNavigationInteractor: AlertRespondNavigationBusinessLogic, AlertRespondNavigationDataStore {
    
    var presenter: AlertRespondNavigationPresentationLogic?
    
    weak var alertResponderHandler: AlertResponderHandler?
    
    var patientAlert: PatientAlert?
    
    private let coreDataHandler: CoreDataHandler
    private let notificationCenter: NotificationCenter
    private let notificationManager: NotificationManger
    private let beaconsManager: BeaconsManager
    private let networkingManager: NetworkingManager
    
    init(coreDataHandler: CoreDataHandler, notificationCenter: NotificationCenter, beaconsManager: BeaconsManager, networkingManager: NetworkingManager, notificationManager: NotificationManger) {
        self.coreDataHandler = coreDataHandler
        self.notificationCenter = notificationCenter
        self.beaconsManager = beaconsManager
        self.networkingManager = networkingManager
        self.notificationManager = notificationManager
    }
    
    deinit {
        forceStopLocatingBeacons()
    }
    
    func requestAlertDescription(request: AlertRespondNavigation.DescriptionDatasource.Request) {
        presenter?.prepareAlertDescription(response: AlertRespondNavigation.DescriptionDatasource.Response(patient: patientAlert?.patient,
                                                                                                           triggerLocation: patientAlert?.gateway.name,
                                                                                                           triggerDate: patientAlert?.creationDate,
                                                                                                           tagCharecteristics: patientAlert?.patientTag))
    }
    
    func startSearchingForPatient(request: AlertRespondNavigation.PatientSearch.Request) {
        guard let minor = patientAlert?.patientTag.minor, let major = patientAlert?.patientTag.major else {
            presenter?.preparePatientSearchResult(response: AlertRespondNavigation.PatientSearch.Response(isSuccessful: false))
            return
        }
        shouldListenForTrackingBeaconsNotifications(true)
        coreDataHandler.getUserProfile() { [weak self] userModel in
            guard let discoveryRegions = userModel?.discoveryRegions else {
                return
            }
            self?.beaconsManager.startListentingForBeaconsInProximity(searchRegions: discoveryRegions, minor: minor, major: major)
        }
    }
    
    func respondToAlert(request: AlertRespondNavigation.Respond.Request) {
        guard let patientId = patientAlert?.patient.id else {
            presenter?.prepareRespondResult(response: AlertRespondNavigation.Respond.Response(isSuccessful: false, error: nil))
            return
        }
        
        let requestBody = AlertRespondNavigation.ProcessingRequest.init(patientId: patientId, notes: request.notes)
        
        let operation = RespondToAlertOperation(respondRequest: requestBody) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value {
                    strongSelf.presenter?.prepareRespondResult(response: AlertRespondNavigation.Respond.Response(isSuccessful: true, error: nil))
                    if let pendingAlertsCount = value.remainingPendingAlertsCount {
                        strongSelf.notificationManager.setBadgeCount(pendingAlertsCount)
                    }
                } else {
                    strongSelf.presenter?.prepareRespondResult(response: AlertRespondNavigation.Respond.Response(isSuccessful: false, error: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.prepareRespondResult(response: AlertRespondNavigation.Respond.Response(isSuccessful: false, error: responseObject))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
}

//MARK: - Utilities

extension AlertRespondNavigationInteractor {
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

extension AlertRespondNavigationInteractor {
    
    @objc private func didLocateBeacons(_ notification: Notification) {
        if let _ = notification.userInfo?[BeaconsManager.Constants.Notifications.UserInfoBeaconsKey] as? [Beacon] {
            presenter?.preparePatientSearchResult(response: AlertRespondNavigation.PatientSearch.Response(isSuccessful: true))
            forceStopLocatingBeacons()
        }
    }
}
