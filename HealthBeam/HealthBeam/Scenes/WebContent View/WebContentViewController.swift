//
//  WebContentViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import WebKit

typealias WebContentInteractorProtocol = WebContentBusinessLogic & WebContentDataStore
typealias WebContentPresenterProtocol =  WebContentPresentationLogic
typealias WebContentRouterProtocol = WebContentRoutingLogic & WebContentDataPassing

protocol WebContentDisplayLogic: class {
    
}

class WebContentViewController: UIViewController, WebContentDisplayLogic {
    
    var interactor: WebContentInteractorProtocol?
    var router: WebContentRouterProtocol?
    
    @IBOutlet weak var webView: WKWebView!
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupUI()
    }
    
    private func setupWebView() {
        guard let urlString = router?.dataStore?.urlString,
            let url = URL(string: urlString) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.navigationDelegate = self
        LoadingOverlay.showOn(view, completion: nil)
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .applicationGradientColorFoBounds(view.bounds)
        navigationItem.title = router?.dataStore?.title
    }
}

extension WebContentViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.absoluteString == router?.dataStore?.urlString {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LoadingOverlay.hide()
    }
}

//MARK: - Properties Injection

extension WebContentViewController {
    func injectProperties(interactor: WebContentInteractorProtocol,
                          presenter: WebContentPresenterProtocol,
                          router: WebContentRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
