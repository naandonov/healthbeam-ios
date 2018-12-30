//
//  FloatingTextField.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 30.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit
import UnderLineTextField

class FloatingTextField: UnderLineTextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        activeLineWidth = 2
        inactiveLineWidth = 1
        
        activeLineColor = .neutralBlue
        inactiveLineColor = .neutralBlue
        
        inactivePlaceholderTextColor = .lightGray
        activePlaceholderTextColor = .lightGray
        
        errorTextColor = .red
        errorPlaceholderColor = .lightGray
    }

}
