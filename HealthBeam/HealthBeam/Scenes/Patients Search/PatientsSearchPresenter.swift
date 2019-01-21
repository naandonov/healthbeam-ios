//
//  PatientsSearchPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientsSearchPresentationLogic {
    var presenterOutput: PatientsSearchDisplayLogic? { get set }
}

class PatientsSearchPresenter: PatientsSearchPresentationLogic {
    
  weak var presenterOutput: PatientsSearchDisplayLogic?
    
}
