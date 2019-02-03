//
//  PatientDetailsInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientDetailsBusinessLogic {
    var presenter: PatientDetailsPresentationLogic? { get set }
}

protocol PatientDetailsDataStore {

}

class PatientDetailsInteractor: PatientDetailsBusinessLogic, PatientDetailsDataStore {
    
  var presenter: PatientDetailsPresentationLogic?
    
}
