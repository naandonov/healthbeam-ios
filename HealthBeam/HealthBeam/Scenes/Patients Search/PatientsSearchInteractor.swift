//
//  PatientsSearchInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientsSearchBusinessLogic {
    var presenter: PatientsSearchPresentationLogic? { get set }
}

protocol PatientsSearchDataStore {

}

class PatientsSearchInteractor: PatientsSearchBusinessLogic, PatientsSearchDataStore {
    
  var presenter: PatientsSearchPresentationLogic?
    
}
