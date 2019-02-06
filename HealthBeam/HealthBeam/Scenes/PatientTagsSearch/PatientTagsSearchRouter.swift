//
//  PatientTagsSearchRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientTagsSearchRoutingLogic {
    var viewController: PatientTagsSearchViewController? { get set }
}

protocol PatientTagsSearchDataPassing {
    var dataStore: PatientTagsSearchDataStore? {get set}
}

class PatientTagsSearchRouter:  PatientTagsSearchRoutingLogic, PatientTagsSearchDataPassing {
    
  weak var viewController: PatientTagsSearchViewController?
  var dataStore: PatientTagsSearchDataStore?
    
}
