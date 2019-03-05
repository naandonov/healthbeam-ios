//
//  AlertRespondNavigationViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias AlertRespondNavigationInteractorProtocol = AlertRespondNavigationBusinessLogic & AlertRespondNavigationDataStore
typealias AlertRespondNavigationPresenterProtocol =  AlertRespondNavigationPresentationLogic
typealias AlertRespondNavigationRouterProtocol = AlertRespondNavigationRoutingLogic & AlertRespondNavigationDataPassing

protocol AlertRespondNavigationDisplayLogic: class {
    
}

class AlertRespondNavigationViewController: MenuNavigationController, AlertRespondNavigationDisplayLogic {
    
    var interactor: AlertRespondNavigationInteractorProtocol?
    var router: AlertRespondNavigationRouterProtocol?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.backgroundColor = UIColor.applicationAlertColorFoBounds(view.bounds)
        navigationBar.prefersLargeTitles = true
        
//        viewControllers.last?.view.backgroundColor = UIColor.applicationAlertColorFoBounds(view.bounds)
        
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
    }
    
}

//MARK: - Properties Injection

extension AlertRespondNavigationViewController {
    func injectProperties(interactor: AlertRespondNavigationInteractorProtocol,
                          presenter: AlertRespondNavigationPresenterProtocol,
                          router: AlertRespondNavigationRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
