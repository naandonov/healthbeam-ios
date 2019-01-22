//
//  PatientsSearchViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias PatientsSearchInteractorProtocol = PatientsSearchBusinessLogic & PatientsSearchDataStore
typealias PatientsSearchPresenterProtocol =  PatientsSearchPresentationLogic
typealias PatientsSearchRouterProtocol = PatientsSearchRoutingLogic & PatientsSearchDataPassing

protocol PatientsSearchDisplayLogic: class {
    
}

class PatientsSearchViewController: UIViewController, PatientsSearchDisplayLogic {
    
    var interactor: PatientsSearchInteractorProtocol?
    var router: PatientsSearchRouterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var pageElementsController: PagedElementsController<PatientsSearchViewController>?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        pageElementsController = PagedElementsController(tableView: tableView, delegate: self)
//        pageElementsController?.configureSearchBarIn(viewController: self)
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        navigationItem.title = "Patients".localized()
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.tableFooterView = UIView()
        tableView.registerNib(PatientTableViewCell.self)
    }
}

//MARK: - Properties Injection

extension PatientsSearchViewController {
    func injectProperties(interactor: PatientsSearchInteractorProtocol,
                          presenter: PatientsSearchPresenterProtocol,
                          router: PatientsSearchRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}

//MARK: - PagedElementsControllerDelegate

extension PatientsSearchViewController: PagedElementsControllerDelegate {
    
    typealias ElementType = Patient
    
    func cellForItem(_ item: Patient, in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PatientTableViewCell
        
        cell.nameLabel.text = item.fullName
        cell.ageLabel.text = item.birthDate.yearsSince()
        cell.locationLabel.text = item.premiseLocation
        cell.healthRecordsLabel.text = "0"
        return cell
    }
    
    func cellForPlaceholderItemIn(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PatientTableViewCell
        return cell
    }
    
    func cellHeightIn(tableView: UITableView) -> CGFloat {
        return 161.5
    }
    
    func requestPage(_ page: Int, in tableView: UITableView, handler: @escaping ((BatchResult<Patient>) -> ())) {
        let operation = GetPatientsOperation(pageQuery: page) { result in
            switch result {
                
            case let .success(response):
                handler(response.value!)
            case .failure(_):
                print("bad")
            }
        }
        
        NetworkingManager.shared.addNetwork(operation: operation)
    }
    
    func discardRequestForPage(_ page: Int) {
        
    }
}
