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
}

class PatientsSearchViewController: UIViewController, PatientsSearchDisplayLogic {
    
    var interactor: PatientsSearchInteractorProtocol?
    var router: PatientsSearchRouterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var pageElementsController: PagedElementsController<PatientsSearchViewController>?
    private var keyboardScrollHandler: KeyboardScrollHandler?
    @IBOutlet weak var patientsSegmentedControl: UISegmentedControl!
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        pageElementsController = PagedElementsController(tableView: tableView, delegate: self)
        pageElementsController?.configureSearchBarIn(viewController: self)
        pageElementsController?.reset()
        
        keyboardScrollHandler = KeyboardScrollHandler(scrollView: tableView, notificationCenter: NotificationCenter.default)
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        let allSegment = PatientsSearch.Segment.all
        let observedSegment = PatientsSearch.Segment.observed
        patientsSegmentedControl.setTitle(allSegment.title, forSegmentAt: allSegment.rawValue)
        patientsSegmentedControl.setTitle(observedSegment.title, forSegmentAt: observedSegment.rawValue)
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
    
    //MARK: - Displaying Logic
    
    func processPatientsSearchReult(viewModel: PatientsSearch.Retrieval.ViewModel) {
        if !viewModel.isSuccessful {
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
    
    //MARK: - Actions
    @IBAction func patientsSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case PatientsSearch.Segment.all.rawValue:
            break
        case PatientsSearch.Segment.observed.rawValue:
            break
        default:
            break
        }
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

extension PatientsSearchViewController: PagedElementsControllerDelegate {
    
    typealias ElementType = Patient
    
    func cellForItem(_ item: Patient, in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PatientTableViewCell
        
        cell.nameLabel.text = item.fullName
        cell.ageLabel.text = item.birthDate.yearsSince()
        cell.locationLabel.text = item.premiseLocation
        cell.healthRecordsLabel.text = "0"
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
    
    func requestPage(_ page: Int, in tableView: UITableView, handler: @escaping PatientsSearchHandler) {
        guard let segment = PatientsSearch.Segment(rawValue: patientsSegmentedControl.selectedSegmentIndex) else {
            return
        }
        let searchTerm = navigationItem.searchController?.searchBar.text
        interactor?.retrievePatients(request: PatientsSearch.Retrieval.Request(page: page,
                                                                               searchQuery: searchTerm,
                                                                               segment: segment,
                                                                               handler: handler))
    }
    
    func discardRequestForPage(_ page: Int) {
        //        interactor?.cancelSearchRequestFor(page: page)
    }
}

//MARK:- PagedElementsControllerSearchDelegate

extension PatientsSearchViewController: PagedElementsControllerSearchDelegate {
    func searchFor(_ searchTerm: String, handler: @escaping PatientsSearchHandler) {
        guard let segment = PatientsSearch.Segment(rawValue: patientsSegmentedControl.selectedSegmentIndex) else {
            return
        }
        interactor?.retrievePatients(request: PatientsSearch.Retrieval.Request(page: 1,
                                                                               searchQuery: searchTerm,
                                                                               segment: segment,
                                                                               handler: handler))
    }
}
