//
//  MenuRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol MenuRoutingLogic {
    var viewController: MenuViewController? { get set }
    
    func routeToAuthorization(withHandler handler: PostAuthorizationHandler?, animated: Bool)
    func routeToPatientsSearch(cell: MenuCollectionViewCell)
    func routeToLocatePatients(cell: MenuCollectionViewCell)
    func routeToAboutSection(cell: MenuCollectionViewCell)
    func routeToPatientAlerts(cell: MenuCollectionViewCell)
}

protocol MenuDataPassing {
    var dataStore: MenuDataStore? {get set}
}

class MenuRouter: NSObject, MenuRoutingLogic, MenuDataPassing {
    
    weak var viewController: MenuViewController?
    private lazy var navigationController: UINavigationController? = {
        let navigationController = viewController?.navigationController
        navigationController?.delegate = self
        return navigationController
    }()
    
    var dataStore: MenuDataStore?
    
    private weak var hideableView: UIView?
    private var outerRect: CGRect?
    private var innerRect: CGRect?
    private var innerSnapshot: UIImage?
    
    
    private let loginViewControllerProvider: Provider<LoginViewController>
    private let patientsSearchViewControllerProvider: Provider<PatientsSearchViewController>
    private let locatePatientsViewControllerProvider: Provider<LocatePatientsViewController>
    private let aboutViewControllerProvider: Provider<AboutViewController>
    private let patientAlertsControllerProvider: Provider<PatientAlertsViewController>
    
    func routeToAuthorization(withHandler handler: PostAuthorizationHandler?, animated: Bool) {
        if viewController?.presentedViewController != nil {
            return
        }
        let loginViewController = loginViewControllerProvider.get()
        loginViewController.router?.dataStore?.postAuthorizationHandler = handler
        viewController?.present(loginViewController, animated: animated, completion: nil)
    }
    
    func routeToPatientsSearch(cell: MenuCollectionViewCell) {
        let patientsSearchViewController = patientsSearchViewControllerProvider.get()
        patientsSearchViewController.router?.dataStore?.mode = .searchAll
        animatedTransitionToViewController(patientsSearchViewController, cell: cell)
    }
    
    func routeToLocatePatients(cell: MenuCollectionViewCell) {
        let locatePatientsViewController = patientsSearchViewControllerProvider.get()
        locatePatientsViewController.router?.dataStore?.mode = .locateNearby
       animatedTransitionToViewController(locatePatientsViewController, cell: cell)
    }
    
    func routeToAboutSection(cell: MenuCollectionViewCell) {
        let aboutViewController = aboutViewControllerProvider.get()
        animatedTransitionToViewController(aboutViewController, cell: cell)
    }
    
    func routeToPatientAlerts(cell: MenuCollectionViewCell) {
        let patientAlertsController = patientAlertsControllerProvider.get()
        animatedTransitionToViewController(patientAlertsController, cell: cell)
    }
    
    private func animatedTransitionToViewController(_ providedViewController: UIViewController, cell: MenuCollectionViewCell) {
        guard viewController?.navigationController?.viewControllers.count == 1 else {
            return
        }
        providedViewController.view.layoutSubviews()
        
        hideableView = cell
        if let view = viewController?.view {
            outerRect = cell.contentView.convert(cell.contentView.frame, to: view)
            innerRect = cell.innerContainerView.convert(cell.innerContainerView.frame, to: view)
        }
        innerSnapshot = cell.innerContainerView.snapshot()
        
        navigationController?.pushViewController(providedViewController, animated: true)
    }
    
    init(loginViewControllerProvider: Provider<LoginViewController>,
         patientsSearchViewControllerProvider: Provider<PatientsSearchViewController>,
         locatePatientsViewControllerProvider: Provider<LocatePatientsViewController>,
         aboutViewControllerProvider: Provider<AboutViewController>,
         patientAlertsControllerProvider: Provider<PatientAlertsViewController>) {
        self.loginViewControllerProvider = loginViewControllerProvider
        self.patientsSearchViewControllerProvider = patientsSearchViewControllerProvider
        self.locatePatientsViewControllerProvider = locatePatientsViewControllerProvider
        self.aboutViewControllerProvider = aboutViewControllerProvider
        self.patientAlertsControllerProvider = patientAlertsControllerProvider
    }
}

extension MenuRouter: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if toVC is PatientsSearchViewController ||
            toVC is PatientAlertsViewController {
            navigationController.navigationBar.prefersLargeTitles = true
        } else {
            navigationController.navigationBar.prefersLargeTitles = false
        }
        
        guard let hideableView = hideableView,
            let innerRect = innerRect,
            let outerRect = outerRect,
            let innerSnapshot = innerSnapshot,
            (operation == .push && navigationController.viewControllers.count == 2) ||
                (operation == .pop && navigationController.viewControllers.count == 1)
            else {
                return nil
        }
        
        switch operation {
        case .push:
            return MenuTransition(direction: .forward,
                                  hideableView: hideableView,
                                  outerRect: outerRect,
                                  innerRect: innerRect,
                                  innerSnapshot: innerSnapshot,
                                  cornerRadius: 30)
        case .pop:
            return MenuTransition(direction: .backward,
                                  hideableView: hideableView,
                                  outerRect: outerRect,
                                  innerRect: innerRect,
                                  innerSnapshot: innerSnapshot,
                                  cornerRadius: 30)
        default:
            return nil
        }
    }
}
