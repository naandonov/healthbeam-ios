//
//  LoadingIndicator.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 31.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit
import Lottie

class LoadingOverlayView: UIView {

    @IBOutlet weak var animationsContainer: CustomizableView!
    @IBOutlet weak var loadingAnimationView: LOTAnimationView!

    @IBOutlet weak var successAnimationView: LOTAnimationView!
    
    var successAnimationColor: LOTColorValueCallback!
    var loadingAnimationColor: LOTColorValueCallback!

    
    override func awakeFromNib() {
        configureLoadingAnimation()
        configureSuccessAnimation()
    }
    
    private func configureLoadingAnimation() {
        loadingAnimationView.play()
        loadingAnimationView.contentMode = .scaleAspectFill
        loadingAnimationView.loopAnimation = true
        
        let color = UIColor.lightBlue
        loadingAnimationColor = LOTColorValueCallback(color:color.cgColor)
        let strokePath = "Shape Layer 1.Stroke 1.Color"
        let strokeKeypath = LOTKeypath(string: strokePath)
        
        loadingAnimationView.setValueDelegate(loadingAnimationColor, for: strokeKeypath)
    }
    

    
    private func configureSuccessAnimation() {
        let pathStroke1 = "ae_demo Outlines.Group 1.Stroke 1.Color"
        let pathStroke2 = "ae_demo Outlines.Group 2.Stroke 1.Color"
        
        let keypathStroke1 = LOTKeypath(string: pathStroke1)
        let keypathStroke2 = LOTKeypath(string: pathStroke2)
        
        let color = UIColor.lightBlue
        successAnimationColor = LOTColorValueCallback(color:color.cgColor)
        successAnimationView.setValueDelegate(successAnimationColor, for: keypathStroke1)
        successAnimationView.setValueDelegate(successAnimationColor, for: keypathStroke2)
        
    }

}
