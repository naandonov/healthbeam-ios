//
//  PatientTagsSearchPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientTagsSearchPresentationLogic {
    var presenterOutput: PatientTagsSearchDisplayLogic? { get set }
    
    func presentBeacons(response: PatientTagsSearch.Locate.Response)
}

class PatientTagsSearchPresenter: PatientTagsSearchPresentationLogic {
    
  weak var presenterOutput: PatientTagsSearchDisplayLogic?
    
    func presentBeacons(response: PatientTagsSearch.Locate.Response) {
        presenterOutput?.displayNearbyTags(viewModel: PatientTagsSearch.Locate.ViewModel(beacons: response.beacons))
    }
    
}
