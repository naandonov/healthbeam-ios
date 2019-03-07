//
//  AlertLocatingViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class AlertLocatingViewController: UIViewController {

    private var scanningView: ScanningView?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        if let scanningView = scanningView {
            view.addConstraintsForWrappedInsideView(scanningView)
            scanningView.mode = .alert
        }
    }
}

//MARK: - Properties Injection

extension AlertLocatingViewController {
    func injectProperties(scanningView: ScanningView) {
        self.scanningView = scanningView
    }
}
