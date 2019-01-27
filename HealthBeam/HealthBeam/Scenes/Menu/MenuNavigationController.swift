//
//  MenuNavigationController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit


class MenuNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        let backgroundImage = CAGradientLayer(applicationStyleWithFrame: navigationBar.bounds).gradientImage()
        navigationBar.barTintColor = UIColor(patternImage: backgroundImage!)
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }
}
