//
//  RoundedAlertButton.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class RoundedAlertButton: RoundedButton {
    
    override var startColor: UIColor {
        return .darkRed
    }
    
    override var middleColor: UIColor {
        return .neutralRed
    }
    
    override var endColor: UIColor {
        return .lightRed
    }
}
