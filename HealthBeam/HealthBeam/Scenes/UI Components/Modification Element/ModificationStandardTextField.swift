//
//  ModificationStandardTextField.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class ModificationStandardTextField: UITextField {

    var canPerformActions = true
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return canPerformActions
    }

}
