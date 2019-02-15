//
//  WebContentRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol WebContentRoutingLogic {
    var viewController: WebContentViewController? { get set }
}

protocol WebContentDataPassing {
    var dataStore: WebContentDataStore? {get set}
}

class WebContentRouter:  WebContentRoutingLogic, WebContentDataPassing {
    
  weak var viewController: WebContentViewController?
  var dataStore: WebContentDataStore?
    
}
