//
//  AlertLocatingViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class AlertLocatingViewController: UIViewController {

    weak var output: AlertLocatingViewOutput?
    var patient: Patient?
    var tagCharecteristics: TagCharacteristics?
    
    private var scanningView: ScanningView?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        if let scanningView = scanningView {
            view.addConstraintsForWrappedInsideView(scanningView)
            scanningView.mode = .alert
            
            scanningView.titleLabel.text = "Locating".localized() + " " + (patient?.fullName ?? "Patient".localized())
            scanningView.subtitleLabel.text = "Get in proximity to Patient Tag".localized() + " " + (tagCharecteristics?.representationName ?? "Unknowned".localized())
        }
    }
}

//MARK: - Properties Injection

extension AlertLocatingViewController {
    func injectProperties(scanningView: ScanningView) {
        self.scanningView = scanningView
    }
}
