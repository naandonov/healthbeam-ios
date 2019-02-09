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
    
    func routeToAuthorization(withHandler handler: PostAuthorizationHandler?, animated: Bool) {
        if viewController?.presentedViewController != nil {
            return
        }
        let loginViewController = loginViewControllerProvider.get()
        loginViewController.router?.dataStore?.postAuthorizationHandler = handler
        viewController?.present(loginViewController, animated: animated, completion: nil)
    }
    
    func routeToPatientsSearch(cell: MenuCollectionViewCell) {
        guard viewController?.navigationController?.viewControllers.count == 1 else {
            return
        }
        let patientsSearchViewController = patientsSearchViewControllerProvider.get()
        patientsSearchViewController.view.layoutSubviews()
        
        hideableView = cell
        if let view = viewController?.view {
            outerRect = cell.contentView.convert(cell.contentView.frame, to: view)
            innerRect = cell.innerContainerView.convert(cell.innerContainerView.frame, to: view)
        }
        innerSnapshot = cell.innerContainerView.snapshot()
        
        navigationController?.pushViewController(patientsSearchViewController, animated: true)
    }
    
    init(loginViewControllerProvider: Provider<LoginViewController>,
         patientsSearchViewControllerProvider: Provider<PatientsSearchViewController>) {
        self.loginViewControllerProvider = loginViewControllerProvider
        self.patientsSearchViewControllerProvider = patientsSearchViewControllerProvider
    }
}

extension MenuRouter: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        navigationController.navigationBar.prefersLargeTitles = false

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
