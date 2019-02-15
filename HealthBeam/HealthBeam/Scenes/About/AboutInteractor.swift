//
//  AboutInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol AboutBusinessLogic {
    var presenter: AboutPresentationLogic? { get set }
}

protocol AboutDataStore {

}

class AboutInteractor: AboutBusinessLogic, AboutDataStore {
    
  var presenter: AboutPresentationLogic?
    
}
