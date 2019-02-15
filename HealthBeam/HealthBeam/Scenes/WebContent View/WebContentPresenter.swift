//
//  WebContentPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol WebContentPresentationLogic {
    var presenterOutput: WebContentDisplayLogic? { get set }
}

class WebContentPresenter: WebContentPresentationLogic {
    
  weak var presenterOutput: WebContentDisplayLogic?
    
}
