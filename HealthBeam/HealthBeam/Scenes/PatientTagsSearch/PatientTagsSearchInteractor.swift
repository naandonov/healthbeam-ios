//
//  PatientTagsSearchInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientTagsSearchBusinessLogic {
    var presenter: PatientTagsSearchPresentationLogic? { get set }
    func locateNearbyBeacons(request: PatientTagsSearch.Locate.Request)
    func forceStopLocatingBeacons()
}

protocol PatientTagsSearchDataStore {
    var patientTagAssignHandler: PatientTagAssignHandler? { get set }
}

class PatientTagsSearchInteractor: PatientTagsSearchBusinessLogic, PatientTagsSearchDataStore {
    
    weak var patientTagAssignHandler: PatientTagAssignHandler?
    
    private static let locatingTimeInterval: TimeInterval = 5.0
    
    var presenter: PatientTagsSearchPresentationLogic?
    
    private let coreDataHandler: CoreDataHandler
    private let notificationCenter: NotificationCenter
    private let beaconsManager: BeaconsManager
    private var locatedBeacons: [Beacon] = []
    
    
    
    deinit {
        forceStopLocatingBeacons()
    }
    
    func locateNearbyBeacons(request: PatientTagsSearch.Locate.Request) {
        shouldListenForTrackingBeaconsNotifications(true)
        coreDataHandler.getUserProfile() { [weak self] userModel in
            guard let discoveryRegions = userModel?.discoveryRegions else {
                return
            }
            beaconsManager.startListentingForBeaconsInProximity(searchRegions: discoveryRegions)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + PatientTagsSearchInteractor.locatingTimeInterval) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.forceStopLocatingBeacons()
                strongSelf.locatedBeacons.sort() { $0.accuracy < $1.accuracy }
                strongSelf.presenter?.presentBeacons(response: PatientTagsSearch.Locate.Response(beacons: strongSelf.locatedBeacons))
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
    
    init(coreDataHandler: CoreDataHandler, notificationCenter: NotificationCenter, beaconsManager: BeaconsManager) {
        self.coreDataHandler = coreDataHandler
        self.notificationCenter = notificationCenter
        self.beaconsManager = beaconsManager
    }
}

//MARK: - Notification Observers

extension PatientTagsSearchInteractor {
    
    @objc private func didLocateBeacons(_ notification: Notification) {
        if let beacons = notification.userInfo?[BeaconsManager.Constants.Notifications.UserInfoBeaconsKey] as? [Beacon] {
            for beacon in beacons {
                locatedBeacons.removeAll { $0 == beacon }
                locatedBeacons.append(beacon)
            }
        }
    }
}
