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
    var tagCharecteristics: TagCharacteristics? { get set }
    
    var alertResponderHandler: AlertResponderHandler? { get set }
}

class AlertRespondNavigationInteractor: AlertRespondNavigationBusinessLogic, AlertRespondNavigationDataStore {
    
    var presenter: AlertRespondNavigationPresentationLogic?
    
    weak var alertResponderHandler: AlertResponderHandler?
    
    var patient: Patient?
    var triggerLocation: String?
    var triggerDate: Date?
    var tagCharecteristics: TagCharacteristics?
    
    func requestAlertDescription(request: AlertRespondNavigation.DescriptionDatasource.Request) {
        presenter?.prepareAlertDescription(response: AlertRespondNavigation.DescriptionDatasource.Response(patient: patient,
                                                                                                           triggerLocation: triggerLocation,
                                                                                                           triggerDate: triggerDate,
                                                                                                           tagCharecteristics: tagCharecteristics))
    }
}
