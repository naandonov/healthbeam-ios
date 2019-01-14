//
//  MenuViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

typealias MenuInteractorProtocol = MenuBusinessLogic & MenuDataStore
typealias MenuPresenterProtocol =  MenuPresentationLogic
typealias MenuRouterProtocol = MenuRoutingLogic & MenuDataPassing

protocol MenuDisplayLogic: class {
    func didPerformAuthorizationCheck(viewModel: Menu.AuthorizationCheck.ViewModel)
}

class MenuViewController: UIViewController, MenuDisplayLogic {
    
    var interactor: MenuInteractorProtocol?
    var router: MenuRouterProtocol?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.performAuthorizationCheck(request: Menu.AuthorizationCheck.Request())
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
    }
    
    //MARK:- Display Logic
    
    func didPerformAuthorizationCheck(viewModel: Menu.AuthorizationCheck.ViewModel) {
        if !viewModel.authorizationGranted {
            router?.routeToAuthorization(withHandler: self)
        }
        else {

        }
    }
    
}

extension MenuViewController: PostAuthorizationHandler {
    func handleSuccessfullAuthorization(userProfile: UserProfile.Model) {
        
    }
}

//MARK: - Properties Injection

extension MenuViewController {
    func injectProperties(interactor: MenuInteractorProtocol,
                          presenter: MenuPresenterProtocol,
                          router: MenuRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
