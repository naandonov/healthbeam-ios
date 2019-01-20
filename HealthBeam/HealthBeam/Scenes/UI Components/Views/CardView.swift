//
//  CardView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 20.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class CardView: CustomizableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLeft = true
        topRight = true
        bottomLeft = true
        bottomRight = true
        
        internalColor = .white
        cornerRadius = StyleCoordinator.Metrics.cardViewCornerRadius
        shadowRadius = 3.0
        shadowOpacity = 0.35
        shadowOffset = CGSize(width: 3, height: 3)
        shadowColor = UIColor.shadowColor
    }
}
