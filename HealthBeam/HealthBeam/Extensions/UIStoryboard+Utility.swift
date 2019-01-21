//
//  HealthBeam
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//


import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T? {
        return instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
    }
}

extension UIStoryboard {
    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class var authentication: UIStoryboard {
        return UIStoryboard(name: "Authentication", bundle: nil)
    }
    
    class var menu: UIStoryboard {
        return UIStoryboard(name: "Menu", bundle: nil)
    }
    
    class var patients: UIStoryboard {
        return UIStoryboard(name: "Patients", bundle: nil)
    }
}

extension UIViewController {
    class var storyboardIdentifier: String {
        let result = String(describing: self)
        return result
    }
}
