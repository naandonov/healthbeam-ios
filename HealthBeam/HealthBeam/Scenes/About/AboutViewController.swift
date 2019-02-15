//
//  AboutViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias AboutInteractorProtocol = AboutBusinessLogic & AboutDataStore
typealias AboutPresenterProtocol =  AboutPresentationLogic
typealias AboutRouterProtocol = AboutRoutingLogic & AboutDataPassing

protocol AboutDisplayLogic: class {
    
}

class AboutViewController: UIViewController, AboutDisplayLogic {

    private let defaultCellIdentifier = "Cell"
    
    enum Option {
        case termsAndConditions
        case privacyPolicy
    }
    
    struct SectionInfo {
        let title: String
        let options: [Option]
    }
    
    var interactor: AboutInteractorProtocol?
    var router: AboutRouterProtocol?

    private let datasource: [SectionInfo] = [
        SectionInfo(title: "General".localized(), options: [.termsAndConditions, .privacyPolicy])
    ]
    
    @IBOutlet weak var tableView: UITableView!
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        navigationItem.title = "About".localized()
        view.backgroundColor = .applicationGradientColorFoBounds(view.bounds)
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

//MARK: - UITableViewDataSource

extension AboutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier) else {
            fatalError("Unable to dequeue cell for \(tableView)")
        }
        cell.accessoryType = .disclosureIndicator
        
        let option = datasource[indexPath.section].options[indexPath.row]
        switch option {
        case .termsAndConditions:
            cell.textLabel?.text = "Terms And Conditions".localized()
        case .privacyPolicy:
            cell.textLabel?.text = "Privacy Policy".localized()
        }
        cell.textLabel?.textColor = .darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].title
    }
    
}

//MARK: - UITableViewDelegate

extension AboutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = datasource[indexPath.section].options[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch option {
        case .termsAndConditions:
            router?.routeToTermsAndConditions()
        case .privacyPolicy:
            router?.routeToPrivacyPolicy()
        }
    }
    
}

//MARK: - Properties Injection

extension AboutViewController {
    func injectProperties(interactor: AboutInteractorProtocol,
                          presenter: AboutPresenterProtocol,
                          router: AboutRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
