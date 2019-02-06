//
//  HealthRecordInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol HealthRecordBusinessLogic {
    var presenter: HealthRecordPresentationLogic? { get set }
}

protocol HealthRecordDataStore {

}

class HealthRecordInteractor: HealthRecordBusinessLogic, HealthRecordDataStore {
    
  var presenter: HealthRecordPresentationLogic?
    
}
