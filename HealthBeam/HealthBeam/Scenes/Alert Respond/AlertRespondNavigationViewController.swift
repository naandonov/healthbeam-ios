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
    func processAlertDescriptionDatasource(viewModel: AlertRespondNavigation.DescriptionDatasource.ViewModel)
}

protocol AlertDescriptionViewOutput: class {
    func didPressRespondButton()
}

class AlertRespondNavigationViewController: MenuNavigationController, AlertRespondNavigationDisplayLogic {
    
    var interactor: AlertRespondNavigationInteractorProtocol?
    var router: AlertRespondNavigationRouterProtocol?
    
    private weak var alertDescriptionViewInput: AlertDescriptionViewInput?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.backgroundColor = UIColor.applicationAlertColorFoBounds(view.bounds)
        navigationBar.prefersLargeTitles = true
        
       interactor?.requestAlertDescription(request: AlertRespondNavigation.DescriptionDatasource.Request())
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
    }
    
    //MARK: - Setup UI
    
    func processAlertDescriptionDatasource(viewModel: AlertRespondNavigation.DescriptionDatasource.ViewModel) {
        if let dataSource = viewModel.dataSource, viewModel.isSuccessful == true {
            alertDescriptionViewInput?.dataSource = dataSource
        }
    }
}

extension AlertRespondNavigationViewController: AlertDescriptionViewOutput {
    
    func didPressRespondButton() {
        
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
        
        alertDescriptionViewInput = viewControllers.first as? AlertDescriptionViewInput
    }
}
