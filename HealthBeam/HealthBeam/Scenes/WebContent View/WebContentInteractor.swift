//
//  WebContentInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol WebContentBusinessLogic {
    var presenter: WebContentPresentationLogic? { get set }
}

protocol WebContentDataStore {
    var urlString: String? { get set }
    var title: String? { get set }
}

class WebContentInteractor: WebContentBusinessLogic, WebContentDataStore {
    
    var urlString: String?
    var title: String? 
    
    var presenter: WebContentPresentationLogic?
    
}
