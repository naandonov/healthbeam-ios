//
//  String+Validation.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 31.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
