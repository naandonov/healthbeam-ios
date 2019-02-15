//
//  HealthRecordModificationViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias HealthRecordModificationInteractorProtocol = HealthRecordModificationBusinessLogic & HealthRecordModificationDataStore
typealias HealthRecordModificationPresenterProtocol =  HealthRecordModificationPresentationLogic
typealias HealthRecordModificationRouterProtocol = HealthRecordModificationRoutingLogic & HealthRecordModificationDataPassing

protocol HealthRecordModificationDisplayLogic: class {
    func displayDatasource(viewModel: HealthRecordModification.DataSource.ViewModel)
    func displayCreatedHealthRecord(viewModel: HealthRecordModification.Create.ViewModel)
    func displayUpdatedHealthRecord(viewModel: HealthRecordModification.Update.ViewModel)
    
}

class HealthRecordModificationViewController: UIViewController, HealthRecordModificationDisplayLogic {
    
    var interactor: HealthRecordModificationInteractorProtocol?
    var router: HealthRecordModificationRouterProtocol?
    
    @IBOutlet weak var tableContainerView: UIView!
    private var modificationController: ModificationElementController<HealthRecord>?
    private var notificationCenter: NotificationCenter?
    
    var mode: Mode?
    
    enum Mode {
        case create
        case update
    }
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.requestDataStore(request: HealthRecordModification.DataSource.Request())
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        view.setApplicationGradientBackground()
        if let mode = mode {
            switch mode {
            case .create:
                let barButtonItem = UIBarButtonItem(title: "Create".localized(), style: .plain, target: self, action: #selector(createButtonTapped))
                navigationItem.rightBarButtonItem = barButtonItem
                navigationItem.title = "Health Record".localized()
            case .update:
                let barButtonItem = UIBarButtonItem(title: "Update".localized(), style: .plain, target: self, action: #selector(updateButtonTapped))
                navigationItem.rightBarButtonItem = barButtonItem
                navigationItem.title = "Health Record".localized()
            }
        }
    }
    
    //MARK: - Display Logic
    
    func displayDatasource(viewModel: HealthRecordModification.DataSource.ViewModel) {
        if let notificationCenter = notificationCenter {
            modificationController = ModificationElementController(containerView: tableContainerView, dataSource: viewModel.dataSource, notificationCenter: notificationCenter)
        }
    }
    
    func displayCreatedHealthRecord(viewModel: HealthRecordModification.Create.ViewModel) {
        if !viewModel.isSuccessful {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        } else {
            if let healthRecord = viewModel.healthRecord {
                interactor?.modificationDelegate?.didCreateHealthRecord(healthRecord)
            }
            LoadingOverlay.hideWithSuccess { [weak self] _ in
                if let healthRecord = viewModel.healthRecord {
                    self?.router?.routeToHealthRecordDetails(healthRecord: healthRecord)
                }
            }
        }
    }
    
    func displayUpdatedHealthRecord(viewModel: HealthRecordModification.Update.ViewModel) {
        if !viewModel.isSuccessful {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        } else {
            if let healthRecord = viewModel.healthRecord {
                interactor?.healthRecordUpdateHandler?.didUpdateHealthRecord(healthRecord)
            }
            LoadingOverlay.hideWithSuccess { [weak self] _ in
                self?.router?.routeToPreviousScreen()
            }
        }
    }
    
    
}

extension HealthRecordModificationViewController {
    
    @objc func createButtonTapped(_ sender: UIBarButtonItem) {
        do {
            if let healthRecord = try modificationController?.requestModifiedElement() {
                interactor?.requestHealthRecordCreation(request: HealthRecordModification.Create.Request(healthRecord: healthRecord))
                LoadingOverlay.showOn(navigationController?.view ?? view)
            }
        }
        catch  {
            if error is ModificationError {
                UIAlertController.presentAlertControllerWithErrorMessage("Required fields are missing".localized(), on: self)
            }
        }
    }
    
    @objc func updateButtonTapped(_ sender: UIBarButtonItem) {
        do {
            if let healthRecord = try modificationController?.requestModifiedElement() {
                interactor?.requestHealthRecordUpdate(request: HealthRecordModification.Update.Request(healthRecord: healthRecord))
                LoadingOverlay.showOn(navigationController?.view ?? view)
            }
        }
        catch  {
            if error is ModificationError {
                UIAlertController.presentAlertControllerWithErrorMessage("Required fields are missing".localized(), on: self)
            }
        }
    }
}

//MARK: - Properties Injection

extension HealthRecordModificationViewController {
    func injectProperties(interactor: HealthRecordModificationInteractorProtocol,
                          presenter: HealthRecordModificationPresenterProtocol,
                          router: HealthRecordModificationRouterProtocol,
                          notificationCenter: NotificationCenter) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
        
        self.notificationCenter = notificationCenter
    }
}
