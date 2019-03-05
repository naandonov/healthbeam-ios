//
//  AlertRespondNavigationRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol AlertRespondNavigationRoutingLogic {
    var viewController: AlertRespondNavigationViewController? { get set }
}

protocol AlertRespondNavigationDataPassing {
    var dataStore: AlertRespondNavigationDataStore? {get set}
}

class AlertRespondNavigationRouter:  AlertRespondNavigationRoutingLogic, AlertRespondNavigationDataPassing {
    
  weak var viewController: AlertRespondNavigationViewController?
  var dataStore: AlertRespondNavigationDataStore?
    
}
