//
//  HealthBeam
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//


import Foundation
import UIKit

protocol NibLoadableView: class {
    static var nib: UINib { get }
}

extension NibLoadableView where Self: UIView {
    static var nib: UINib {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib
    }
}

