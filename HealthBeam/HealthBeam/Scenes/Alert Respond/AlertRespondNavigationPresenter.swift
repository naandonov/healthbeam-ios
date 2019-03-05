//
//  AlertRespondNavigationPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol AlertRespondNavigationPresentationLogic {
    var presenterOutput: AlertRespondNavigationDisplayLogic? { get set }
}

class AlertRespondNavigationPresenter: AlertRespondNavigationPresentationLogic {
    
  weak var presenterOutput: AlertRespondNavigationDisplayLogic?
    
}
