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
}

protocol AlertRespondNavigationDataStore {

}

class AlertRespondNavigationInteractor: AlertRespondNavigationBusinessLogic, AlertRespondNavigationDataStore {
    
  var presenter: AlertRespondNavigationPresentationLogic?
    
}
