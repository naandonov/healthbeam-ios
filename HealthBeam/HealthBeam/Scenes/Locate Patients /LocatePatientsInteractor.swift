//
//  LocatePatientsInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 11.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol LocatePatientsBusinessLogic {
    var presenter: LocatePatientsPresentationLogic? { get set }
}

protocol LocatePatientsDataStore {

}

class LocatePatientsInteractor: LocatePatientsBusinessLogic, LocatePatientsDataStore {
    
  var presenter: LocatePatientsPresentationLogic?
    
}
