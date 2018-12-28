//
//  HealthBeam
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//


import UIKit
import Foundation

extension UIView {
    
    class var nibName: String {
        let name = String(describing: self).components(separatedBy: ".").first ?? ""
        return name
    }
    
    class func fromNib<T: UIView>() -> T {
        let nibViews = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!
        let view = nibViews.first as! T
        return view
    }
}
