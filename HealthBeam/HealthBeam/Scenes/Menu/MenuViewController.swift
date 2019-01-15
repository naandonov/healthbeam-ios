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
    func didPerformProfileUpdate(viewModel: Menu.UserProfileUpdate.ViewModel)
}

class MenuViewController: UIViewController, MenuDisplayLogic {
    
    private var startupLoadingView: StartupLoadingView?
    
    var interactor: MenuInteractorProtocol?
    var router: MenuRouterProtocol?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.performAuthorizationCheck(request: Menu.AuthorizationCheck.Request())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
            updateDeviceToken()
            interactor?.updateUserProfile(request: Menu.UserProfileUpdate.Request())
            if let startupLoadingView = startupLoadingView {
                view.addSubview(startupLoadingView)
                view.addConstraintsForWrappedInsideView(startupLoadingView)
            }
        }
    }
    
    func didPerformProfileUpdate(viewModel: Menu.UserProfileUpdate.ViewModel) {
        startupLoadingView?.animateFade(positive: false, completition: nil)
        guard let user = viewModel.user else {
//            UIAlertController.presentAlertControllerWithErrorMessage("A problem has occured.", on: self)
            return
        }
    }
    
    //MARK:- Setup
    
    func updateDeviceToken() {
        interactor?.requestNotificationServices()
        interactor?.updateDeviceToken()
    }
}

extension MenuViewController: PostAuthorizationHandler {
    func handleSuccessfullAuthorization(userProfile: UserProfile.Model) {
        updateDeviceToken()
    }
}

//MARK: - Properties Injection

extension MenuViewController {
    func injectProperties(interactor: MenuInteractorProtocol,
                          presenter: MenuPresenterProtocol,
                          router: MenuRouterProtocol,
                          startupLoadingView: StartupLoadingView) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
        
        self.startupLoadingView = startupLoadingView
    }
}
