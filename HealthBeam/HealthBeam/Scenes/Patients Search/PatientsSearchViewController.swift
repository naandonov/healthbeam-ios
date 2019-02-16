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
    func processLocateNearbyPatientsReult(viewModel: PatientsSearch.Nearby.ViewModel)
    func processPatientAttributesReult(viewModel: PatientsSearch.Attributes.ViewModel)
}

protocol PatientsModificationProtocol: class {
    func didDeletePatient(_ patient: Patient)
    func didUpdatePatient(_ patient: Patient)
    func didCreatePatient(_ patient: Patient)
}

class PatientsSearchViewController: UIViewController, PatientsSearchDisplayLogic {
    
    var interactor: PatientsSearchInteractorProtocol?
    var router: PatientsSearchRouterProtocol?
    
    private let allSegment = PatientsSearch.Segment.all
    private let observedSegment = PatientsSearch.Segment.observed
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationContainerView: UIView!
    
    private var notificationCenter: NotificationCenter?
    private var keyboardScrollHandler: KeyboardScrollHandler?
    private var scanningView: ScanningView?
    
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    private var pageElementsController: PagedElementsController<PatientsSearchViewController>?
    
    private var isInitialSetup = true
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        guard let mode = router?.dataStore?.mode else {
            return
        }
        
        
        pageElementsController = PagedElementsController(tableView: tableView, delegate: self)
        switch mode {
        case .searchAll:
            
            pageElementsController?.configureSearchBarIn(viewController: self, style: .light)
            pageElementsController?.configureScopeSelectionControlWith(scopeTitles: [allSegment.title, observedSegment.title], style: .light)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(createPatientBarButtonAction))
            
            if let notificationCenter = notificationCenter {
                keyboardScrollHandler = KeyboardScrollHandler(scrollView: tableView, notificationCenter: notificationCenter, enableTapToDismiss: false)
            }
            
            navigationItem.title = "Patients".localized()

            
        case .locateNearby:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Locate".localized(),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(scanButtonAction))
            
            navigationItem.title = "Nearby Patients".localized()
            if let scanningView = scanningView {
                animationContainerView.addConstraintsForWrappedInsideView(scanningView)
                scanningView.titleLabel.text = "Locating Patients".localized()
                scanningView.subtitleLabel.text = "Get closer to a patient tag".localized()
                scanningView.backgroundColor = .clear
                scanningView.titleLabel.textColor = .white
                scanningView.subtitleLabel.textColor = .white
                animationContainerView.backgroundColor = .white
            }
            
        }
        
        pageElementsController?.configureEmptyStateView(emptyStateView)
        emptyStateLabel.text = "No Results Found".localized()
        
        view.setApplicationGradientBackground()
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .paleGray
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.registerNib(PatientTableViewCell.self)
        tableView.registerNib(PatientPlaceholderTableViewCell.self)
        
        pageElementsController?.reset()
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isInitialSetup {
            animationContainerView.setApplicationGradientBackground()
            isInitialSetup = false
        }
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    //MARK: - Displaying Logic
    
    func processPatientsSearchReult(viewModel: PatientsSearch.Retrieval.ViewModel) {
        if !viewModel.isSuccessful {
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
            pageElementsController?.displayEmptyResult()
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
    
    func processLocateNearbyPatientsReult(viewModel: PatientsSearch.Nearby.ViewModel) {
        animationContainerView.animateFade(positive: false) { [weak self] _ in
            self?.animationContainerView?.isHidden = true
            self?.tableView.isHidden = false
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if !viewModel.isSuccessful {
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
            pageElementsController?.displayEmptyResult()
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
    
    func didCreatePatient(_ patient: Patient) {
        pageElementsController?.reset()
    }
}

//MARK: - Properties Injection

extension PatientsSearchViewController {
    func injectProperties(interactor: PatientsSearchInteractorProtocol,
                          presenter: PatientsSearchPresenterProtocol,
                          router: PatientsSearchRouterProtocol,
                          notificationCenter: NotificationCenter,
                          scanningView: ScanningView) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
        self.notificationCenter = notificationCenter
        
        self.scanningView = scanningView
    }
}

//MARK: - PagedElementsControllerDelegate

extension PatientsSearchViewController: PagedElementsControllerSearchDelegate {
    
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
        guard let mode = router?.dataStore?.mode else {
            return
        }
        
        switch mode {

        case .searchAll:
            let searchTerm = navigationItem.searchController?.searchBar.text
            var segment: PatientsSearch.Segment?
            if let scopeIndex = scopeIndex {
                segment = PatientsSearch.Segment(rawValue: scopeIndex)
            }
            interactor?.retrievePatients(request: PatientsSearch.Retrieval.Request(page: page,
                                                                                   searchQuery: searchTerm,
                                                                                   segment: segment,
                                                                                   handler: handler))
        case .locateNearby:
            navigationItem.rightBarButtonItem?.isEnabled = false
            animationContainerView.isHidden = false
            tableView.isHidden = true
            animationContainerView.animateFade(positive: true, completition: nil)
            interactor?.retrieveNearbyPatients(request: PatientsSearch.Nearby.Request(handler: handler))
        }
    }
    
    func discardRequestForPage(_ page: Int) {
        //        interactor?.cancelSearchRequestFor(page: page)
    }
    
    func didSelectItem(_ item: Patient) {
        LoadingOverlay.showOn(navigationController?.view ?? view)
        interactor?.retrievePatientAttributes(request: PatientsSearch.Attributes.Request(selectedPatient: item))
    }
}

//MARK: - Button Actions

extension PatientsSearchViewController {
    
    @objc func createPatientBarButtonAction(_ sender: UIBarButtonItem) {
        router?.routeToCreatePatient()
    }
    
    @objc func scanButtonAction(_ sender: UIBarButtonItem) {
        pageElementsController?.reset()
    }
}
