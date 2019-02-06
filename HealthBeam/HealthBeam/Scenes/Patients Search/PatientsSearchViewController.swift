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
    func processPatientsSearchReult(viewModel: PatientsSearch.Retrieval.ViewModel)
    func processPatientAttributesReult(viewModel: PatientsSearch.Attributes.ViewModel)
}

protocol PatientsModificationProtocol: class {
    func didDeletePatient(_ patient: Patient)
    func didUpdatePatient(_ patient: Patient)
}

class PatientsSearchViewController: UIViewController, PatientsSearchDisplayLogic {
    
    var interactor: PatientsSearchInteractorProtocol?
    var router: PatientsSearchRouterProtocol?
    
    private let allSegment = PatientsSearch.Segment.all
    private let observedSegment = PatientsSearch.Segment.observed
    
    @IBOutlet weak var tableView: UITableView!
    
    private var pageElementsController: PagedElementsController<PatientsSearchViewController>?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        pageElementsController = PagedElementsController(tableView: tableView, delegate: self)
        pageElementsController?.configureSearchBarIn(viewController: self, style: .light)
        pageElementsController?.configureScopeSelectionControlWith(scopeTitles: [allSegment.title, observedSegment.title], style: .light)
        pageElementsController?.reset()
                
//        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        navigationItem.title = "Patients".localized()
        navigationItem.largeTitleDisplayMode = .always
    
        view.backgroundColor = .paleGray
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.registerNib(PatientTableViewCell.self)
        tableView.registerNib(PatientPlaceholderTableViewCell.self)
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    //MARK: - Displaying Logic
    
    func processPatientsSearchReult(viewModel: PatientsSearch.Retrieval.ViewModel) {
        if !viewModel.isSuccessful {
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
    
    func processPatientAttributesReult(viewModel: PatientsSearch.Attributes.ViewModel) {
        LoadingOverlay.hide()
        if !viewModel.isSuccessful {
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        } else {
            router?.routeToPatientDetails()
        }
    }
}

//MARK: - PatientsModificationProtocol

extension PatientsSearchViewController: PatientsModificationProtocol {
    func didDeletePatient(_ patient: Patient) {
        pageElementsController?.reset()
    }
    
    func didUpdatePatient(_ patient: Patient) {
        pageElementsController?.reset()
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

extension PatientsSearchViewController: PagedElementsControllerSearchDelegate {
    
    typealias ElementType = Patient
    
    func cellForItem(_ item: Patient, in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PatientTableViewCell
        
        cell.nameLabel.text = item.fullName
        cell.ageLabel.text = item.birthDate.yearsSince()
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
        let searchTerm = navigationItem.searchController?.searchBar.text
        var segment: PatientsSearch.Segment?
        if let scopeIndex = scopeIndex {
            segment = PatientsSearch.Segment(rawValue: scopeIndex)
        }
        interactor?.retrievePatients(request: PatientsSearch.Retrieval.Request(page: page,
                                                                               searchQuery: searchTerm,
                                                                               segment: segment,
                                                                               handler: handler))
    }
    
    func discardRequestForPage(_ page: Int) {
        //        interactor?.cancelSearchRequestFor(page: page)
    }
    
    func didSelectItem(_ item: Patient) {
        LoadingOverlay.showOn(navigationController?.view ?? view)
        interactor?.retrievePatientAttributes(request: PatientsSearch.Attributes.Request(selectedPatient: item))
    }
}
