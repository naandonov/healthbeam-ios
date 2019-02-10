//
//  MenuNavigationController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit


class MenuNavigationController: UINavigationController {
    
    private var navigationBarBackgroundView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = CAGradientLayer(applicationStyleWithFrame: navigationBar.bounds).gradientImage()
        navigationBar.barTintColor = UIColor(patternImage: backgroundImage!)
//        navigationBar.isTranslucent = false
//        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
//        let navigationBarBackgroundView = UIView(frame: .zero)
//        navigationBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        navigationBar.insertSubview(navigationBarBackgroundView, at: 0)
//        navigationBarBackgroundView.backgroundColor = UIColor(patternImage: backgroundImage ?? UIImage())
//        navigationBar.addConstraintsForWrappedInsideView(navigationBarBackgroundView)
//        self.navigationBarBackgroundView = navigationBarBackgroundView

        
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let navigationBarBackgroundView = navigationBarBackgroundView {
            navigationBar.sendSubviewToBack(navigationBarBackgroundView)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
