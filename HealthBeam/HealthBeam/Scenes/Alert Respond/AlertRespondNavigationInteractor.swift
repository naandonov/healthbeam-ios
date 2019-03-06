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
}

protocol AlertRespondNavigationDataStore {
    var patient: Patient? { get set }
    var triggerLocation: String? { get set }
    var triggerDate: Date? { get set }
    var beacon: Beacon? { get set }
}

class AlertRespondNavigationInteractor: AlertRespondNavigationBusinessLogic, AlertRespondNavigationDataStore {
    
    var presenter: AlertRespondNavigationPresentationLogic?
    
 
    var patient: Patient?
    var triggerLocation: String?
    var triggerDate: Date?
    var beacon: Beacon?
    
    func requestAlertDescription(request: AlertRespondNavigation.DescriptionDatasource.Request) {
        var pa = Patient.emptySnapshot()
        pa.fullName = "Nikolay Andonov"
        pa.birthDate = Date.init(timeIntervalSince1970: 0)
        pa.gender = "Male"
        
        let tl = "Cardiology Wing Z8"
        let td = Date()
        let beaconz = Beacon(minor: 1534, major: 667, rssi: 3, accuracy: 3.4)
        
        presenter?.prepareAlertDescription(response: AlertRespondNavigation.DescriptionDatasource.Response(patient: pa,
                                                                                                           triggerLocation: tl,
                                                                                                           triggerDate: td,
                                                                                                           beacon: beaconz))
    }
}
