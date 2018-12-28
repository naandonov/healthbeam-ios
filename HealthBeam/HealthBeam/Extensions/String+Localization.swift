//
//  String+Localization.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.10.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
}
