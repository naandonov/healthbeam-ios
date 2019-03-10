//
//  UIViewController+Utilities.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 10.03.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var topMostPresentedViewController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topMostPresentedViewController
        } else {
            return self
        }
    }
    
}
