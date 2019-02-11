//
//  LocatePatientsViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 11.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias LocatePatientsInteractorProtocol = LocatePatientsBusinessLogic & LocatePatientsDataStore
typealias LocatePatientsPresenterProtocol =  LocatePatientsPresentationLogic
typealias LocatePatientsRouterProtocol = LocatePatientsRoutingLogic & LocatePatientsDataPassing

protocol LocatePatientsDisplayLogic: class {
    
}

class LocatePatientsViewController: UIViewController, LocatePatientsDisplayLogic {
    
    var interactor: LocatePatientsInteractorProtocol?
    var router: LocatePatientsRouterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var pageElementsController: PagedElementsController<LocatePatientsViewController>?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        pageElementsController = PagedElementsController(tableView: tableView, delegate: self)
        pageElementsController?.reset()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scan".localized(),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(scanButtonAction))
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
    }
    
}

//MARK: - PagedElementsControllerDelegate

extension LocatePatientsViewController: PagedElementsControllerSearchDelegate {
    
    typealias ElementType = Patient
    
    func cellForItem(_ item: Patient, in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PatientTableViewCell
        
        cell.nameLabel.text = item.fullName
        cell.ageLabel.text = item.birthDate?.yearsSince() ?? ""
        cell.locationLabel.text = item.premiseLocation
        cell.healthRecordsLabel.text = item.personalIdentification
        cell.selectionStyle = .none
        return cell
    }
    
    func cellForPlaceholderItemIn(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PatientPlaceholderTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func cellHeightIn(tableView: UITableView) -> CGFloat {
        return 141.5
    }
    
    func requestPage(_ page: Int, in tableView: UITableView, scopeIndex: Int?, handler: @escaping ((BatchResult<Patient>) -> ())) {
        
    }
    
    func discardRequestForPage(_ page: Int) {
        //        interactor?.cancelSearchRequestFor(page: page)
    }
    
    func didSelectItem(_ item: Patient) {
        LoadingOverlay.showOn(navigationController?.view ?? view)
//        interactor?.retrievePatientAttributes(request: PatientsSearch.Attributes.Request(selectedPatient: item))
    }
}

//MARK: - Button Actions

extension LocatePatientsViewController {
    
    @objc func scanButtonAction(_ sender: UIBarButtonItem) {
    }
}

//MARK: - Properties Injection

extension LocatePatientsViewController {
    func injectProperties(interactor: LocatePatientsInteractorProtocol,
                          presenter: LocatePatientsPresenterProtocol,
                          router: LocatePatientsRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
