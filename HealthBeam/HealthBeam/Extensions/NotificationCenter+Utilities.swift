//
//  NSNotificationCenter+Utilities.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.10.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation

extension NotificationCenter {
    func setObserver(_ observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject?) {
        removeObserver(observer, name: name, object: object)
        addObserver(observer, selector: selector, name: name, object: object)
    }
}
