//
//  HealthRecordViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 5.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias HealthRecordInteractorProtocol = HealthRecordBusinessLogic & HealthRecordDataStore
typealias HealthRecordPresenterProtocol =  HealthRecordPresentationLogic
typealias HealthRecordRouterProtocol = HealthRecordRoutingLogic & HealthRecordDataPassing

protocol HealthRecordDisplayLogic: class {
    func displayHealthRecords(viewModel: HealthRecordModel.Get.ViewModel)
    func displayDeleteHealthRecordResult(viewModel: HealthRecordModel.Delete.ViewModel)
}

protocol HealthRecordUpdateProtocol: class {
    func didUpdateHealthRecord(_ healthRecord: HealthRecord)
}

class HealthRecordViewController: UIViewController, HealthRecordDisplayLogic {
    
    var interactor: HealthRecordInteractorProtocol?
    var router: HealthRecordRouterProtocol?
    
    @IBOutlet weak var containerView: UIView!
    private var contentDisplayController: ContentDisplayController?
    private var informationCardView: InformationCardView?
    private var dataSource: HealthRecordModel.DataSource?
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        interactor?.requestHealthRecords(request: HealthRecordModel.Get.Request())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        router?.performNavigationCleanupIfNeeded()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
    
        contentDisplayController = ContentDisplayController(containerView: containerView)
        
        view.setApplicationGradientBackground()
        navigationItem.title = "Health Record".localized()
        
        if let informationCardView = informationCardView, let tableView = contentDisplayController?.tableView {
            tableView.tableHeaderView = informationCardView
            informationCardView.addConstraintForHeight(216)
            informationCardView.setEqualWidthTo(view: tableView)
        }
        
        let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonAction))
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editBarButtonAction))
        navigationItem.setRightBarButtonItems([deleteBarButton, editBarButton], animated: false)
        
        updateContent()
    }
    
    private func updateContent() {
        guard let dataSource = dataSource else {
            return
        }
        
        informationCardView?.outerTitleLabel.text = dataSource.disgnosis
        informationCardView?.outerSubtitleLabel.text = dataSource.creationDate
        
        informationCardView?.innerTitleLabel.text = "Created by".localized()
        informationCardView?.innerValueLabel.text = dataSource.creatorName
        informationCardView?.innerSubtitleLabel.text = dataSource.creatorDesignation
        
        contentDisplayController?.setDisplayElements(dataSource.displayElements)
    }
    
    //MARK: - Displaying Logic
    
    func displayHealthRecords(viewModel: HealthRecordModel.Get.ViewModel) {
        dataSource = viewModel.dataSource
        updateContent()
    }
    
    func displayDeleteHealthRecordResult(viewModel: HealthRecordModel.Delete.ViewModel) {
        if viewModel.isSuccessful {
            LoadingOverlay.hideWithSuccess { [unowned self] _ in
                self.interactor?.modificationDelegate?.didDeleteHealthRecord(viewModel.healthRecord)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
}

//MARK: - Button Actions

extension HealthRecordViewController {
    
    @objc private func deleteBarButtonAction(barButton: UIBarButtonItem) {
        UIAlertController.presentAlertControllerWithTitleMessage("Delete Confirmation".localized(),
                                                                 message: "Are you sure you want to delete this health record?",
            confirmationAction: "Yes".localized(),
            discardAction: true,
            confirmationHandler: { [weak self] in
                guard let healthRecord = self?.router?.dataStore?.healthRecord,
                    let strongSelf = self else {
                        return
                }
                strongSelf.interactor?.deleteHealthRecord(request: HealthRecordModel.Delete.Request(healthRecord: healthRecord))
                LoadingOverlay.showOn(strongSelf.navigationController?.view ?? strongSelf.view)
            }, on: self)
    }
    
    @objc private func editBarButtonAction(barButton: UIBarButtonItem) {
        guard let healthRecord = router?.dataStore?.healthRecord else {
            return
        }
        router?.routeToUpdateHealthRecord(for: healthRecord)
    }
}

//MARK: - Properties Injection

extension HealthRecordViewController {
    func injectProperties(interactor: HealthRecordInteractorProtocol,
                          presenter: HealthRecordPresenterProtocol,
                          router: HealthRecordRouterProtocol,
                          informationCardView: InformationCardView) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
        
        self.informationCardView = informationCardView
    }
}

//MARK: - HealthRecordModificationProtocol

extension HealthRecordViewController: HealthRecordUpdateProtocol {
    func didUpdateHealthRecord(_ healthRecord: HealthRecord) {
        router?.dataStore?.healthRecord = healthRecord
        interactor?.requestHealthRecords(request: HealthRecordModel.Get.Request())
        interactor?.modificationDelegate?.didUpdateHealthRecord(healthRecord)
    }
}

