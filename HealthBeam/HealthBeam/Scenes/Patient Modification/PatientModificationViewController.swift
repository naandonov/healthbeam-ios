//
//  PatientModificationViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias PatientModificationInteractorProtocol = PatientModificationBusinessLogic & PatientModificationDataStore
typealias PatientModificationPresenterProtocol =  PatientModificationPresentationLogic
typealias PatientModificationRouterProtocol = PatientModificationRoutingLogic & PatientModificationDataPassing

protocol PatientModificationDisplayLogic: class {
    func displayDatasource(viewModel: PatientModification.DataSource.ViewModel)
    func displayCreatedPatient(viewModel: PatientModification.Create.ViewModel)
    func displayUpdatedPatient(viewModel: PatientModification.Update.ViewModel)
}

class PatientModificationViewController: UIViewController, PatientModificationDisplayLogic {
    
    enum Mode {
        case create
        case update
    }
    
    var interactor: PatientModificationInteractorProtocol?
    var router: PatientModificationRouterProtocol?
    
    @IBOutlet weak var tableContainerView: UIView!
    private var modificationController: ModificationElementController<Patient>?
    private var notificationCenter: NotificationCenter?
    
    weak var attributesUpdateHandler: AttributesUpdateProtocol?

    private var dataSource: ModificationDatasource<Patient>?
    var mode: Mode?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.requestDataSource(request: PatientModification.DataSource.Request())
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        view.setApplicationGradientBackground()
        if let mode = mode {
            switch mode {
            case .create:
                let barButtonItem = UIBarButtonItem(title: "Create".localized(), style: .plain, target: self, action: #selector(createButtonTapped))
                navigationItem.rightBarButtonItem = barButtonItem
                navigationItem.title = "Create Patient".localized()
            case .update:
                let barButtonItem = UIBarButtonItem(title: "Update".localized(), style: .plain, target: self, action: #selector(updateButtonTapped))
                navigationItem.rightBarButtonItem = barButtonItem
                navigationItem.title = "Update Patient".localized()
            }
        }
    }
    
    //MARK: - Displaying Logic
    
    func displayDatasource(viewModel: PatientModification.DataSource.ViewModel) {
        if let notificationCenter = notificationCenter {
            modificationController = ModificationElementController(containerView: tableContainerView, dataSource: viewModel.dataSource, notificationCenter: notificationCenter)
            dataSource = viewModel.dataSource
        }
    }
    
    func displayCreatedPatient(viewModel: PatientModification.Create.ViewModel) {
        if !viewModel.isSuccessful {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        } else {
            if let patient = viewModel.patient {
                interactor?.modificationDelegate?.didCreatePatient(patient)
            }
            LoadingOverlay.hideWithSuccess { [weak self] _ in
                self?.interactor?.getExternalUser(completion: { [weak self]  user in
                    let patientAttributes = PatientAttributes(observers: [user],
                                                              healthRecords: [],
                                                              patientTag: nil)
                    self?.router?.routeToPatientDetails(witAttributes: patientAttributes)
                })
            }
        }
    }
    
    func displayUpdatedPatient(viewModel: PatientModification.Update.ViewModel) {
        if !viewModel.isSuccessful {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        } else {
            if let patient = viewModel.patient {
                interactor?.modificationDelegate?.didUpdatePatient(patient)
                attributesUpdateHandler?.didUpdatePatient(patient)
            }
            LoadingOverlay.hideWithSuccess { [weak self] _ in
                self?.router?.routeToPreviousScreen()
            }
        }
    }
}

//MARK: - Button Actions

extension PatientModificationViewController {
    
    @objc func createButtonTapped(_ sender: UIBarButtonItem) {
        do {
            if let patient = try modificationController?.requestModifiedElement() {
                interactor?.requestPatientCreation(request: PatientModification.Create.Request(patient: patient))
                LoadingOverlay.showOn(navigationController?.view ?? view)
            }
        }
        catch  {
            if error is ModificationError {
                UIAlertController.presentAlertControllerWithErrorMessage("Missing required fields".localized(), on: self)
            }
        }
    }
    
    @objc func updateButtonTapped(_ sender: UIBarButtonItem) {
        do {
            if let patient = try modificationController?.requestModifiedElement() {
                interactor?.requestPatientUpdate(request: PatientModification.Update.Request(patient: patient))
                LoadingOverlay.showOn(navigationController?.view ?? view)
            }
        }
        catch  {
            if error is ModificationError {
                UIAlertController.presentAlertControllerWithErrorMessage("Missing required fields".localized(), on: self)
            }
        }
    }
}

//MARK: - Properties Injection

extension PatientModificationViewController {
    func injectProperties(interactor: PatientModificationInteractorProtocol,
                          presenter: PatientModificationPresenterProtocol,
                          router: PatientModificationRouterProtocol,
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
