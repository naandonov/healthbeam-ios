//
//  UserProfileViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias UserProfileInteractorProtocol = UserProfileBusinessLogic & UserProfileDataStore
typealias UserProfilePresenterProtocol =  UserProfilePresentationLogic
typealias UserProfileRouterProtocol = UserProfileRoutingLogic & UserProfileDataPassing

protocol UserProfileDisplayLogic: class {
    
}

class UserProfileViewController: UIViewController, UserProfileDisplayLogic {
    
    var interactor: UserProfileInteractorProtocol?
    var router: UserProfileRouterProtocol?
    
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

extension UserProfileViewController {
    func injectProperties(interactor: UserProfileInteractorProtocol,
                          presenter: UserProfilePresenterProtocol,
                          router: UserProfileRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
