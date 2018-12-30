//
//  TopLogoView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit

class LightLogoView: UIView {
    
    @IBOutlet weak var containerView: CustomizableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       containerView.setLinearGradientBackground(colors: .darkBlue, .lightBlue)
    }

}
