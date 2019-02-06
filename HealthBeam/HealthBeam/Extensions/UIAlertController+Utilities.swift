//
//  UIAlertController+Utilities.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func presentAlertControllerWithErrorMessage(_ errorMessage: String, on presentingViewControler: UIViewController) {
        presentAlertControllerWithTitleMessage("Something Went Wrong".localized(), message: errorMessage, on: presentingViewControler)
    }
    
    class func presentAlertControllerWithTitleMessage(_ title: String, message: String, confirmationAction: String = "OK".localized(), discardAction: Bool = false, confirmationHandler:(()->Void)? = nil, on presentingViewControler: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: confirmationAction, style: .default, handler: { _ in
            confirmationHandler?()
        })
        alertController.addAction(okAction)
        if discardAction {
            alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        }
        
        presentingViewControler.present(alertController, animated: true, completion: nil)
    }
    
    
}
