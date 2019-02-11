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
    func didPerformUserLogout(viewModel: Menu.UserLogout.ViewModel)
    func didReceiveAuthorizationRevocation()
}

class MenuViewController: UIViewController, MenuDisplayLogic {
    
    private var startupLoadingView: StartupLoadingView?
    
    var interactor: MenuInteractorProtocol?
    var router: MenuRouterProtocol?
    
    @IBOutlet weak var premiseNameLabel: UILabel!
    @IBOutlet weak var premiseTypeLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDesignationLabel: UILabel!
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.performAuthorizationCheck(request: Menu.AuthorizationCheck.Request())
        configureMenuCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Setup
    
    private func setupUI() {
        view.setApplicationGradientBackground()
    }
    
    private func configureMenuCollectionView() {
        if let layout = menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 250, height: 340)
            layout.minimumInteritemSpacing = 20.0
        }
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        let sidePadding = StyleCoordinator.Metrics.defaultSidePadding
        menuCollectionView.contentInset = UIEdgeInsets(top: 0, left: sidePadding, bottom: 0, right: sidePadding)
        menuCollectionView.contentOffset = CGPoint(x: -sidePadding, y: 0)
        menuCollectionView.showsVerticalScrollIndicator = false
        menuCollectionView.showsHorizontalScrollIndicator = false
        
        menuCollectionView.registerNib(MenuCollectionViewCell.self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Display Logic
    
    func didPerformAuthorizationCheck(viewModel: Menu.AuthorizationCheck.ViewModel) {
        if !viewModel.authorizationGranted {
            router?.routeToAuthorization(withHandler: self, animated: false)
        }
        else {
            interactor?.updateUserProfile(request: Menu.UserProfileUpdate.Request())
            if let startupLoadingView = startupLoadingView {
                view.addSubview(startupLoadingView)
                view.addConstraintsForWrappedInsideView(startupLoadingView)
            }
        }
    }
    
    func didPerformProfileUpdate(viewModel: Menu.UserProfileUpdate.ViewModel) {
        startupLoadingView?.animateFade(positive: false) { [weak self] _ in
            self?.startupLoadingView?.removeFromSuperview()
            self?.startupLoadingView = nil
        }
        guard let user = viewModel.user else {
//            UIAlertController.presentAlertControllerWithErrorMessage("A problem has occured.", on: self)
            return
        }
        setProfileInformation(userProfile: user)
        updateDeviceToken()
    }
    
    func didReceiveAuthorizationRevocation() {
        router?.routeToAuthorization(withHandler: self, animated: false)
    }
    
    func didPerformUserLogout(viewModel: Menu.UserLogout.ViewModel) {
        if viewModel.isLogoutSuccessful {
            router?.routeToAuthorization(withHandler: self, animated: true)
        }
    }
    
    //MARK:- Setup
    
    func updateDeviceToken() {
        interactor?.requestNotificationServices()
        interactor?.updateDeviceToken()
    }
    
    func setProfileInformation(userProfile: UserProfile.Model) {
        premiseNameLabel.text = userProfile.premise.name
        premiseTypeLabel.text = userProfile.premise.type
        
        userNameLabel.text = userProfile.fullName
        userDesignationLabel.text = userProfile.designation
    }
}

//MARK:- UICollectionViewDelegate

extension MenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        interactor?.performUserLogout(request: Menu.UserLogout.Request())
        guard let option = interactor?.options[indexPath.row] else {
            fatalError("Option for \(indexPath) does not exist")
        }
        switch option.type {
        case .patientsLocate:
            if let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell {
                router?.routeToLocatePatients(cell: cell)
            }
        case .patientsSearch:
            if let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell {
                router?.routeToPatientsSearch(cell: cell)
            }
        case .about:
            break
        case .logout:
            interactor?.performUserLogout(request: Menu.UserLogout.Request())
        }
    }
}

//MARK:- UICollectionViewDataSource

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor?.options.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MenuCollectionViewCell
        guard let option = interactor?.options[indexPath.row] else {
            fatalError("Option for \(indexPath) does not exist")
        }
        cell.imageView.image = UIImage(named: option.iconName)
        cell.titleLabel.text = option.name
        cell.descriptionLabel.text = option.description
        cell.alpha = 0.9
        
        return cell
    }
}

//MARK: - PostAuthorizationHandler

extension MenuViewController: PostAuthorizationHandler {
    func handleSuccessfullAuthorization(userProfile: UserProfile.Model) {
        updateDeviceToken()
        setProfileInformation(userProfile: userProfile)
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
