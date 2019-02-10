//
//  PatientDetailsViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias PatientDetailsInteractorProtocol = PatientDetailsBusinessLogic & PatientDetailsDataStore
typealias PatientDetailsPresenterProtocol =  PatientDetailsPresentationLogic
typealias PatientDetailsRouterProtocol = PatientDetailsRoutingLogic & PatientDetailsDataPassing

protocol PatientDetailsDisplayLogic: class {
    func displayPatientDetails(viewModel: PatientDetails.AttributeProcessing.ViewModel)
    func displayDeletePatientResult(viewModel: PatientDetails.Delete.ViewModel)
    
    func displayAssignedPatientTag(viewModel: PatientDetails.AssignTag.ViewModel)
    func displayUnassignedPatientTag(viewModel: PatientDetails.UnassignTag.ViewModel)
    func displayPerformedSubscriptionToggle(viewModel: PatientDetails.SubscribeToggle.ViewModel)
}

protocol AttributesUpdateProtocol: class {
    func didUpdatePatient(_: Patient)
}

protocol HealthRecordsModificationProtocol: class {
    func didDeleteHealthRecord(_ healthRecord: HealthRecord)
    func didUpdateHealthRecord(_ healthRecord: HealthRecord)
    func didCreateHealthRecord(_ healthRecord: HealthRecord)
}

protocol PatientTagAssignHandler: class {
    func didAssignBeacon(_ beacon: Beacon)
}

class PatientDetailsViewController: UIViewController, PatientDetailsDisplayLogic, PatientTagAssignHandler {
    
    var interactor: PatientDetailsInteractorProtocol?
    var router: PatientDetailsRouterProtocol?
    
    private var patientDetails: PatientDetails.Model?

    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var premiseLocationLabel: UILabel!
    
    
    @IBOutlet weak var ageValueLabel: UILabel!
    @IBOutlet weak var ageTitleLabel: UILabel!
    
    
    @IBOutlet weak var bloodTypeValueLabel: UILabel!
    @IBOutlet weak var bloodTypeTitleLabel: UILabel!
    
    
    @IBOutlet weak var tagValueLabel: UILabel!
    @IBOutlet weak var tagTitleLabel: UILabel!
    
    @IBOutlet weak var subscibtionButton: RoundedButton!
    @IBOutlet weak var tagAssignButton: RoundedButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var patientDescriptionView: UIView!
    
    @IBOutlet weak var patientInformationLabel: UILabel!
    @IBOutlet weak var patientInformationTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var patientDescriptionHeightConstraint: NSLayoutConstraint!
    
    
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.handlePatientDetails(request: PatientDetails.AttributeProcessing.Request())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        router?.performNavigationCleanupIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let textHeight = patientInformationLabel.text?.height(withConstrainedWidth: patientInformationLabel.bounds.size.width, font: patientInformationLabel.font)
        patientDescriptionHeightConstraint.constant = 348 + (textHeight ?? 0) + patientInformationTopConstraint.constant
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        genderLabel.textColor = .neutralBlue
                
        tableView.registerNib(ListItemTableViewCell.self)
        tableView.registerNib(HealthRecordPreviewTableViewCell.self)
        tableView.registerNib(AddHealthRecordTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.tableHeaderView = patientDescriptionView
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = patientDescriptionView
        
        view.setApplicationGradientBackground()
        navigationItem.title = "Details".localized()
        
        let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonAction))
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editBarButtonAction))
        navigationItem.setRightBarButtonItems([deleteBarButton, editBarButton], animated: false)

    }
    
    func didAssignBeacon(_ beacon: Beacon) {
        router?.dimissPopUpContainer() { [weak self] in
            guard let strongSelf = self else {
                return
            }
            LoadingOverlay.showOn(strongSelf.navigationController?.view ?? strongSelf.view)
            strongSelf.interactor?.assignPatientTag(request: PatientDetails.AssignTag.Request(beacon: beacon))
        }
    }
    
    //MARK: - Displaying Logic
    
    func displayPatientDetails(viewModel: PatientDetails.AttributeProcessing.ViewModel) {
        patientDetails = viewModel.patientDetails
        updateDetails()
    }
    
    private func updateDetails() {
        guard let patient = patientDetails?.patient else {
            return
        }
        genderLabel.text = patient.gender
        nameLabel.text = patient.fullName
        premiseLocationLabel.text = patient.premiseLocation
        patientInformationLabel.text = patient.notes
        
        ageValueLabel.text = patient.birthDate?.yearsSince() ?? ""
        ageTitleLabel.text = "Age".localized()
        
        bloodTypeValueLabel.text = patient.bloodType
        bloodTypeTitleLabel.text = "Blood Type".localized()
        
        if patientDetails?.isObserved ?? false {
            subscibtionButton.prominentStyle = false
            subscibtionButton.setTitle("Unsubscribe".localized(), for: .normal)
        } else {
            subscibtionButton.prominentStyle = true
            subscibtionButton.setTitle("Subscribe".localized(), for: .normal)
        }
        
        if let tag = patientDetails?.patientTag {
            tagValueLabel.text = "\(tag.minor)-\(tag.major)"
            tagAssignButton.prominentStyle = false
            tagAssignButton.setTitle("Unassign Tag".localized(), for: .normal)
        } else {
            tagValueLabel.text = "Unassigned".localized()
            tagAssignButton.prominentStyle = true
            tagAssignButton.setTitle("Assign Tag".localized(), for: .normal)
        }
        tagTitleLabel.text = "Tag".localized()
        
        tableView.reloadData()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        
    }
    
    func displayDeletePatientResult(viewModel: PatientDetails.Delete.ViewModel) {
        if viewModel.isSuccessful {
            LoadingOverlay.hideWithSuccess { [unowned self] _ in
                self.interactor?.modificationDelegate?.didDeletePatient(viewModel.deletedPatient)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
    
    func displayAssignedPatientTag(viewModel: PatientDetails.AssignTag.ViewModel) {
        if viewModel.isSuccessful {
            LoadingOverlay.hideWithSuccess { [unowned self] _ in
                self.patientDetails?.patientTag = viewModel.patientTag
                self.interactor?.handlePatientDetails(request: PatientDetails.AttributeProcessing.Request())
            }
        } else {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
    
    func displayUnassignedPatientTag(viewModel: PatientDetails.UnassignTag.ViewModel) {
        if viewModel.isSuccessful {
            LoadingOverlay.hideWithSuccess { [unowned self] _ in
                self.patientDetails?.patientTag = nil
                self.interactor?.handlePatientDetails(request: PatientDetails.AttributeProcessing.Request())
            }
        } else {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
    
    func displayPerformedSubscriptionToggle(viewModel: PatientDetails.SubscribeToggle.ViewModel) {
        if viewModel.isSuccessful {
            LoadingOverlay.hideWithSuccess { [unowned self] _ in
                self.interactor?.handlePatientDetails(request: PatientDetails.AttributeProcessing.Request())
                if let patient = self.router?.dataStore?.patient {
                    self.router?.dataStore?.modificationDelegate?.didUpdatePatient(patient)
                }
            }
        } else {
            LoadingOverlay.hide()
            UIAlertController.presentAlertControllerWithErrorMessage(viewModel.errorMessage ?? "", on: self)
        }
    }
    
}

//MARK:- Button Actions

extension PatientDetailsViewController {
    
    @objc private func deleteBarButtonAction(barButton: UIBarButtonItem) {
        UIAlertController.presentAlertControllerWithTitleMessage("Delete Confirmation".localized(),
                                                                 message: "Are you sure you want to delete \(patientDetails?.patient.fullName ?? "the patient")",
            confirmationAction: "Yes".localized(),
            discardAction: true,
            confirmationHandler: { [weak self] in
                guard let patient = self?.patientDetails?.patient,
                      let strongSelf = self else {
                    return
                }
                strongSelf.interactor?.deletePatient(request: PatientDetails.Delete.Request(patient: patient))
                LoadingOverlay.showOn(strongSelf.navigationController?.view ?? strongSelf.view)
        }, on: self)
    }
    
    @objc private func editBarButtonAction(barButton: UIBarButtonItem) {
        guard let patient = patientDetails?.patient else {
            return
        }
        router?.routeToUpdatePatientScreen(for: patient)
    }
    
    @IBAction func subscriptionButtonAction(_ sender: UIButton) {
        LoadingOverlay.showOn(navigationController?.view ?? view)
        interactor?.performSubscriptionToggle(request: PatientDetails.SubscribeToggle.Request())
    }
    
    @IBAction func tagAssignButtonAction(_ sender: UIButton) {
        if let _ = patientDetails?.patientTag {
            LoadingOverlay.showOn(navigationController?.view ?? view)
            interactor?.unassignPatientTag(request: PatientDetails.UnassignTag.Request())
            
        } else {
            router?.routeToPatientTagsSearch()
        }
    }
}

//MARK: - Properties Injection

extension PatientDetailsViewController {
    func injectProperties(interactor: PatientDetailsInteractorProtocol,
                          presenter: PatientDetailsPresenterProtocol,
                          router: PatientDetailsRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
    }
}

//MARK: - UITableViewDelegate

extension PatientDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if PatientDetailsSection(rawValue: indexPath.section) == .healthRecords,
            let healthRecords = patientDetails?.healthRecords {
            //Create Health Record
            if indexPath.row >= healthRecords.count {
                interactor?.getExternalUser(completion: { [weak self] user in
                    self?.router?.routeToCreateHealthRecord(creator: user)
                })
            } else {
                router?.routeToHealthRecord(healthRecords[indexPath.row])
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension PatientDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let patientDetailsSection = PatientDetailsSection(rawValue: section),
            let patientDetails = patientDetails {
            
            switch patientDetailsSection {
                
            case .alergies:
                let alergies = patientDetails.patient.alergies
                return alergies.count > 0 ? alergies.count : 1
            case .chronicConditions:
                let chronicConditions = patientDetails.patient.chronicConditions
                return chronicConditions.count > 0 ? chronicConditions.count : 1
            case .healthRecords:
                return patientDetails.healthRecords.count + 1
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let returnCell: UITableViewCell
        if let patientDetailsSection = PatientDetailsSection(rawValue: indexPath.section),
            let patientDetails = patientDetails {
            
            switch patientDetailsSection {
            case .alergies:
                let cell: ListItemTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                if patientDetails.patient.alergies.count == 0 {
                    cell.titleLabel.text = "None".localized()
                    cell.indicatorImageView.isHidden = true
                } else {
                    let alergy = patientDetails.patient.alergies[indexPath.row]
                    cell.titleLabel.text = alergy
                    cell.indicatorImageView.image = UIImage(named: "pointDarkIcon")
                }
                returnCell = cell
            case .chronicConditions:
                let cell: ListItemTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                if patientDetails.patient.chronicConditions.count == 0 {
                    cell.titleLabel.text = "None".localized()
                    cell.indicatorImageView.isHidden = true
                } else  {
                    let chronicCondition = patientDetails.patient.chronicConditions[indexPath.row]
                    cell.indicatorImageView.image = UIImage(named: "pointLightIcon")
                    cell.titleLabel.text = chronicCondition
                }
                returnCell = cell
            case .healthRecords:
                //Add More
                if indexPath.row >= patientDetails.healthRecords.count {
                    let cell: AddHealthRecordTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.titleLabel.text = "Create Health Record".localized()
                    returnCell = cell
                }
                else {
                    let cell: HealthRecordPreviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    let healthRecord = patientDetails.healthRecords[indexPath.row]
                    cell.diagnosisLabel.text = healthRecord.diagnosis
                    cell.dateLabel.text = healthRecord.createdDate.simpleDateString()
                    cell.containerView.internalColor = indexPath.row % 2 == 0 ? UIColor.neutralBlue : UIColor.lightBlue
                    returnCell = cell
                }
            }
        } else {
            returnCell = UITableViewCell()
        }
        
        returnCell.selectionStyle = .none
        return returnCell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PatientDetailsSection(rawValue: section)?.sectionTitle ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let patientDetailsSection = PatientDetailsSection(rawValue: indexPath.section),
            let patientDetails = patientDetails {
            
            switch patientDetailsSection {
                
            case .alergies:
                return 60
            case .chronicConditions:
                return 60
            case .healthRecords:
                return indexPath.row >= patientDetails.healthRecords.count ? 70 : 92
            }
        }
        return 0
    }
}

//MARK: - AttributesUpdateProtocol

extension PatientDetailsViewController: AttributesUpdateProtocol {
    func didUpdatePatient(_ patient: Patient) {
    patientDetails?.patient = patient
        updateDetails()
    }
}

//MARK: - HealthRecordsModificationProtocol

extension PatientDetailsViewController: HealthRecordsModificationProtocol {
    
    func didDeleteHealthRecord(_ healthRecord: HealthRecord) {
        guard let patientDetailsUnwrapped = patientDetails else {
            return
        }
        
        for (index, value) in patientDetailsUnwrapped.healthRecords.enumerated() {
            if value.id == healthRecord.id {
                let deletionIndexPath = IndexPath(row: index, section: PatientDetailsSection.healthRecords.rawValue)
                patientDetails?.healthRecords.remove(at: index)
                tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
                break
            }
        }
    }
    
    func didUpdateHealthRecord(_ healthRecord: HealthRecord) {
        guard let patientDetailsUnwrapped = patientDetails else {
            return
        }
        
        for (index, value) in patientDetailsUnwrapped.healthRecords.enumerated() {
            if value.id == healthRecord.id {
                let reloadIndexePaths = IndexPath(row: index, section: PatientDetailsSection.healthRecords.rawValue)
                patientDetails?.healthRecords[index] = healthRecord
                tableView.reloadRows(at: [reloadIndexePaths], with: .automatic)
                break
            }
        }
    }
    
    func didCreateHealthRecord(_ healthRecord: HealthRecord) {
        patientDetails?.healthRecords.append(healthRecord)
        if let patientDetails = patientDetails {
            let newIndexPath = IndexPath(row: patientDetails.healthRecords.count - 1, section: PatientDetailsSection.healthRecords.rawValue)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

}
