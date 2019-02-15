//
//  AboutPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol AboutPresentationLogic {
    var presenterOutput: AboutDisplayLogic? { get set }
}

class AboutPresenter: AboutPresentationLogic {
    
  weak var presenterOutput: AboutDisplayLogic?
    
}
