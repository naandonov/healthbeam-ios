//
//  PatientTagsSearchInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientTagsSearchBusinessLogic {
    var presenter: PatientTagsSearchPresentationLogic? { get set }
}

protocol PatientTagsSearchDataStore {

}

class PatientTagsSearchInteractor: PatientTagsSearchBusinessLogic, PatientTagsSearchDataStore {
    
  var presenter: PatientTagsSearchPresentationLogic?
    
}
