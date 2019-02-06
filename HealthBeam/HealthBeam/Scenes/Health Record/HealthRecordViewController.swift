//
//  HealthRecordViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias HealthRecordInteractorProtocol = HealthRecordBusinessLogic & HealthRecordDataStore
typealias HealthRecordPresenterProtocol =  HealthRecordPresentationLogic
typealias HealthRecordRouterProtocol = HealthRecordRoutingLogic & HealthRecordDataPassing

protocol HealthRecordDisplayLogic: class {
    
}

class HealthRecordViewController: UIViewController, HealthRecordDisplayLogic {
    
    var interactor: HealthRecordInteractorProtocol?
    var router: HealthRecordRouterProtocol?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
    }
    
}

//MARK: - Properties Injection

extension HealthRecordViewController {
    func injectProperties(interactor: HealthRecordInteractorProtocol,
                          presenter: HealthRecordPresenterProtocol,
                          router: HealthRecordRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
