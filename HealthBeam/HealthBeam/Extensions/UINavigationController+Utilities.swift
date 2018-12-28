//
//  UINavigationController+Utilities.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 22.10.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func viewControllerInStack<T: UIViewController>() -> T? {
        for viewController in viewControllers.reversed() {
            if let resultViewController = viewController as? T {
                return resultViewController
            }
        }
        return nil
    }
    
}
