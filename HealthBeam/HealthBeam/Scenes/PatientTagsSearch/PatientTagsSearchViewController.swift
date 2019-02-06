//
//  PatientTagsSearchViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias PatientTagsSearchInteractorProtocol = PatientTagsSearchBusinessLogic & PatientTagsSearchDataStore
typealias PatientTagsSearchPresenterProtocol =  PatientTagsSearchPresentationLogic
typealias PatientTagsSearchRouterProtocol = PatientTagsSearchRoutingLogic & PatientTagsSearchDataPassing

protocol PatientTagsSearchDisplayLogic: class {
    
}

class PatientTagsSearchViewController: UIViewController, PatientTagsSearchDisplayLogic {
    
    var interactor: PatientTagsSearchInteractorProtocol?
    var router: PatientTagsSearchRouterProtocol?
    
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

extension PatientTagsSearchViewController {
    func injectProperties(interactor: PatientTagsSearchInteractorProtocol,
                          presenter: PatientTagsSearchPresenterProtocol,
                          router: PatientTagsSearchRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
