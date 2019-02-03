//
//  PatientDetailsPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientDetailsPresentationLogic {
    var presenterOutput: PatientDetailsDisplayLogic? { get set }
}

class PatientDetailsPresenter: PatientDetailsPresentationLogic {
    
  weak var presenterOutput: PatientDetailsDisplayLogic?
    
}
