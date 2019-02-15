//
//  AboutRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol AboutRoutingLogic {
    var viewController: AboutViewController? { get set }
    func routeToTermsAndConditions()
    func routeToPrivacyPolicy()
}

protocol AboutDataPassing {
    var dataStore: AboutDataStore? {get set}
}

class AboutRouter:  AboutRoutingLogic, AboutDataPassing {
    
  weak var viewController: AboutViewController?
  var dataStore: AboutDataStore?
    
    let webContentViewControllerProvider: Provider<WebContentViewController>
    
    func routeToTermsAndConditions() {
        let webContentViewController = webContentViewControllerProvider.get()
         let url = APIConstants.BaseURL.healthBeamWeb.urlString + APIConstants.EndPoint.termsAndConditions.endpointString
        webContentViewController.router?.dataStore?.urlString = url
        webContentViewController.router?.dataStore?.title = "Terms And Conditions".localized()
        viewController?.navigationController?.pushViewController(webContentViewController, animated: true)
    }
    
    func routeToPrivacyPolicy() {
        let webContentViewController = webContentViewControllerProvider.get()
        let url = APIConstants.BaseURL.healthBeamWeb.urlString + APIConstants.EndPoint.privacyPolicy.endpointString
        webContentViewController.router?.dataStore?.urlString = url
        webContentViewController.router?.dataStore?.title = "Privacy Policy".localized()
        viewController?.navigationController?.pushViewController(webContentViewController, animated: true)
    }
    
    init(webContentViewControllerProvider: Provider<WebContentViewController>) {
        self.webContentViewControllerProvider = webContentViewControllerProvider
    }
}
