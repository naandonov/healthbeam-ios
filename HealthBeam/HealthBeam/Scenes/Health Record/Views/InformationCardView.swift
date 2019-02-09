//
//  InformationCardView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class InformationCardView: UIView {

    @IBOutlet weak var innerContainerView: CustomizableView!
    @IBOutlet weak var outerContainerView: CustomizableView!
    
    @IBOutlet weak var outerTitleLabel: UILabel!
    @IBOutlet weak var outerSubtitleLabel: UILabel!
    
    
    @IBOutlet weak var innerTitleLabel: UILabel!
    @IBOutlet weak var innerValueLabel: UILabel!
    @IBOutlet weak var innerSubtitleLabel: UILabel!
    
    @IBOutlet weak var innerImageView: UIImageView!
    
    override func awakeFromNib() {
        
        outerTitleLabel.text = ""
        outerSubtitleLabel.text = ""
        
        innerTitleLabel.text = ""
        innerValueLabel.text = ""
        innerSubtitleLabel.text = ""

        outerContainerView.cornerRadius = StyleCoordinator.Metrics.subCardViewCornerRadius
        outerContainerView.backgroundColor = .clear
        outerContainerView.internalColor = .white
        outerContainerView.setLinearGradientBackground(colors: StyleCoordinator.Colors.applicationProminent, StyleCoordinator.Colors.applicationDiscrete)

        innerContainerView.cornerRadius = StyleCoordinator.Metrics.subCardViewCornerRadius
    }

}
