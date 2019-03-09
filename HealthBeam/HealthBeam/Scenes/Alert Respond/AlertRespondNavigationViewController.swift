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
    func processPatientSearchResult(viewModel: AlertRespondNavigation.PatientSearch.ViewModel)
    func processRespondResult(viewModel: AlertRespondNavigation.Respond.ViewModel)
}

protocol AlertDescriptionViewOutput: class {
    func didPressRespondButton()
}

protocol AlertLocatingViewOutput: class {
}

protocol AlertCompletionViewOutput: class {
    func didCompleteAlertWith(notes: String?)
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
    
    //MARK: - Setup
    
    func processAlertDescriptionDatasource(viewModel: AlertRespondNavigation.DescriptionDatasource.ViewModel) {
        if let dataSource = viewModel.dataSource, viewModel.isSuccessful == true {
            alertDescriptionViewInput?.dataSource = dataSource
            alertDescriptionViewInput?.output = self
        }
    }
    
    //MARK: - Display logic
    
    func processPatientSearchResult(viewModel: AlertRespondNavigation.PatientSearch.ViewModel) {
        if viewModel.isSuccessful {
            router?.routeToAlertCompletionView(output: self)
        } else {
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
    
    func processRespondResult(viewModel: AlertRespondNavigation.Respond.ViewModel) {
        if viewModel.isSuccessful {
            LoadingOverlay.hideWithSuccess { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
        } else {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
}

extension AlertRespondNavigationViewController: AlertDescriptionViewOutput {
    
    func didPressRespondButton() {
        router?.routeToLocatingView(output: self)
        interactor?.startSearchingForPatient(request: AlertRespondNavigation.PatientSearch.Request())
    }
}

extension AlertRespondNavigationViewController: AlertLocatingViewOutput {
    
}

extension AlertRespondNavigationViewController: AlertCompletionViewOutput {
    
    func didCompleteAlertWith(notes: String?) {
        LoadingOverlay.showOn(view)
        interactor?.respondToAlert(request: AlertRespondNavigation.Respond.Request(notes: notes))
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
