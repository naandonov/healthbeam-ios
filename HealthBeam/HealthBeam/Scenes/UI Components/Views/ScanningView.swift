//
//  ScanningView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 9.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Lottie

class ScanningView: UIView {

    var pulsingAnimationColor: LOTColorValueCallback!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var animationView: LOTAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurePulsingAnimation()
        animationView.play()
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        
        titleLabel.textColor = .neutralBlue
        
    }
    
    private func configurePulsingAnimation() {
    
        let pathStroke1 = "Shape Layer 1.Ellipse 1.Stroke 1.Color"
        let pathStroke2 = "Shape Layer 2.Ellipse 1.Stroke 1.Color"
        let pathStroke3 = "Shape Layer 3.Ellipse 1.Stroke 1.Color"
        let pathStroke4 = "Shape Layer 4.Ellipse 1.Stroke 1.Color"
        
        let keypathStroke1 = LOTKeypath(string: pathStroke1)
        let keypathStroke2 = LOTKeypath(string: pathStroke2)
        let keypathStroke3 = LOTKeypath(string: pathStroke3)
        let keypathStroke4 = LOTKeypath(string: pathStroke4)
        
        let color = UIColor.lightBlue
        pulsingAnimationColor = LOTColorValueCallback(color:color.cgColor)
        animationView.setValueDelegate(pulsingAnimationColor, for: keypathStroke1)
         animationView.setValueDelegate(pulsingAnimationColor, for: keypathStroke2)
        animationView.setValueDelegate(pulsingAnimationColor, for: keypathStroke3)
        animationView.setValueDelegate(pulsingAnimationColor, for: keypathStroke4)
    }
    

}
