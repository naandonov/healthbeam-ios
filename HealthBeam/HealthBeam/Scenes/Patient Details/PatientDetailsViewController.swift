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
    
}

class PatientDetailsViewController: UIViewController, PatientDetailsDisplayLogic {
    
    var interactor: PatientDetailsInteractorProtocol?
    var router: PatientDetailsRouterProtocol?
    
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        
        let h = patientInformationLabel.text?.height(withConstrainedWidth: patientInformationLabel.bounds.size.width, font: patientInformationLabel.font)
        patientDescriptionHeightConstraint.constant = 348 + (h ?? 0) + patientInformationTopConstraint.constant
      
        
    
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        tableView.registerNib(ListItemTableViewCell.self)
        tableView.registerNib(HealthRecordPreviewTableViewCell.self)
        tableView.registerNib(AddHealthRecordTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.tableHeaderView = patientDescriptionView
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = patientDescriptionView
    }
   

}

//MARK:- Button Actions

extension PatientDetailsViewController {
  
    @IBAction func subscriptionButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func tagAssignButtonAction(_ sender: Any) {
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
    
}

//MARK: - UITableViewDataSource

extension PatientDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0  {
            let cell: ListItemTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.titleLabel.text = "Paracetamol"
            return cell
        } else if indexPath.section == 1  {
            if indexPath.row == 2 {
                let cell: AddHealthRecordTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.titleLabel.text = "Create Health Record"
                return cell
            }
            
            let cell: HealthRecordPreviewTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.diagnosisLabel.text = "Metatarsal bone fracture"
            cell.dateLabel.text = "June 12 2018"
            cell.containerView.internalColor = indexPath.row % 2 == 0 ? UIColor.neutralBlue : UIColor.lightBlue
            return cell
        }
       
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Alergies"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                return 62
            } else {
                return 92
            }
        
        }
        
        return 60
    }
    
}
