//
//  AlertCompletionViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class AlertCompletionViewController: UIViewController {

    weak var output: AlertCompletionViewOutput?
    
    var patient: Patient?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var patientDetailsLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesHeaderView: UIView!
    @IBOutlet weak var notesTitleLabel: UILabel!
    
    @IBOutlet weak var bottomDescriptionLabel: UILabel!
    @IBOutlet weak var completeButton: RoundedAlertButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.applicationAlertColorFoBounds(view.bounds)
        navigationItem.hidesBackButton = true
        title = "Patient Alert".localized()
        
        completeButton.setTitle("Complete".localized(), for: .normal)
        nameLabel.text = patient?.fullName
        nameLabel.textColor = .neutralRed
        patientDetailsLabel.text = patient?.shortDescription
        
        notesTitleLabel.text = "NOTES".localized()
        notesHeaderView.backgroundColor = .subtleGray
        
        bottomDescriptionLabel.text = "The patient was successfully located.".localized()
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        navigationController?.view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func processCompeltion() {
        notesTextView.resignFirstResponder()
        output?.didCompleteAlertWith(notes: notesTextView.text.count > 0 ? notesTextView.text : nil)
    }
    
    @IBAction func completeButtonAction(_ sender: Any) {
        processCompeltion()
    }
}

//MARK: - Gesture recognizers

extension AlertCompletionViewController {
    
    @objc func didTap(_ sender: Any) {
        notesTextView.resignFirstResponder()
    }
}
