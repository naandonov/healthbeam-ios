//
//  PatientAlertsViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias PatientAlertsInteractorProtocol = PatientAlertsBusinessLogic & PatientAlertsDataStore
typealias PatientAlertsPresenterProtocol =  PatientAlertsPresentationLogic
typealias PatientAlertsRouterProtocol = PatientAlertsRoutingLogic & PatientAlertsDataPassing

protocol PatientAlertsDisplayLogic: class {
    func processPendingPatientAlertsResult(viewModel: PatientAlerts.Pending.ViewModel)
}

class PatientAlertsViewController: UIViewController, PatientAlertsDisplayLogic {
    
    var interactor: PatientAlertsInteractorProtocol?
    var router: PatientAlertsRouterProtocol?
    
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    private var pageElementsController: PagedElementsController<PatientAlertsViewController>?
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        navigationItem.title = "Pending Alerts".localized()
        pageElementsController = PagedElementsController(tableView: tableView, delegate: self)
        
        pageElementsController?.configureEmptyStateView(emptyStateView)
        emptyStateLabel.text = "No Results Found".localized()
        
        view.setApplicationGradientBackground()
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.registerNib(AlertTableViewCell.self)
        tableView.registerNib(AlertPlaceholderTableViewCell.self)
        
        pageElementsController?.reset()
    }
    
    //MARK: - Displaying logic
    
    func processPendingPatientAlertsResult(viewModel: PatientAlerts.Pending.ViewModel) {
        if !viewModel.isSuccessful {
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
            pageElementsController?.displayEmptyResult()
        }
    }
}

//MARK: - PagedElementsControllerDelegate

extension PatientAlertsViewController: PagedElementsControllerSearchDelegate {
    
    typealias ElementType = PatientAlert
    
    func cellForItem(_ item: PatientAlert, in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AlertTableViewCell
        cell.nameLabel.text = item.patient.fullName
        cell.gatewayLocationLabel.text = item.gateway.name
        cell.timeLabel.text = item.creationDate.passedTime()
 
        cell.selectionStyle = .none
        return cell
    }
    
    func cellForPlaceholderItemIn(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AlertPlaceholderTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func cellHeightIn(tableView: UITableView) -> CGFloat {
        return 161
    }
    
    func requestPage(_ page: Int, in tableView: UITableView, scopeIndex: Int?, handler: @escaping ((BatchResult<PatientAlert>) -> ())) {
        
        interactor?.retrievePendingPatientAlerts(request: PatientAlerts.Pending.Request(page: page,
                                                                                        handler: handler))
    }
    
    func discardRequestForPage(_ page: Int) {
    }
    
    func didSelectItem(_ item: PatientAlert) {
//        LoadingOverlay.showOn(navigationController?.view ?? view)
//        interactor?.retrievePatientAttributes(request: PatientsSearch.Attributes.Request(selectedPatient: item))
    }
}

//MARK: - Properties Injection

extension PatientAlertsViewController {
    func injectProperties(interactor: PatientAlertsInteractorProtocol,
                          presenter: PatientAlertsPresenterProtocol,
                          router: PatientAlertsRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}
