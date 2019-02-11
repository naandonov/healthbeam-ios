//
//  LocatePatientsPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 11.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol LocatePatientsPresentationLogic {
    var presenterOutput: LocatePatientsDisplayLogic? { get set }
}

class LocatePatientsPresenter: LocatePatientsPresentationLogic {
    
  weak var presenterOutput: LocatePatientsDisplayLogic?
    
}
