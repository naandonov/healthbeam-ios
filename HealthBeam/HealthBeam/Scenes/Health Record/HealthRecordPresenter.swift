//
//  HealthRecordPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol HealthRecordPresentationLogic {
    var presenterOutput: HealthRecordDisplayLogic? { get set }
}

class HealthRecordPresenter: HealthRecordPresentationLogic {
    
  weak var presenterOutput: HealthRecordDisplayLogic?
    
}
