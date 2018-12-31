//
//  HealthBeam
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//


import UIKit

extension UIView  {
    
    func addConstraintsForWrappedInsideView(_ childView: UIView, edgeInset: UIEdgeInsets = .zero, respectSafeArea: Bool = false, pinTop: Bool = true, pinBottom: Bool = true) {
        
        if !subviews.contains(childView) {
            return
        }
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: respectSafeArea ? safeAreaLayoutGuide.topAnchor : self.topAnchor, constant: edgeInset.top).isActive = pinTop
        childView.leftAnchor.constraint(equalTo: respectSafeArea ? safeAreaLayoutGuide.leftAnchor : self.leftAnchor, constant: edgeInset.left).isActive = true
        childView.rightAnchor.constraint(equalTo: respectSafeArea ? safeAreaLayoutGuide.rightAnchor : self.rightAnchor, constant: edgeInset.right).isActive = true
        childView.bottomAnchor.constraint(equalTo: respectSafeArea ? safeAreaLayoutGuide.bottomAnchor : self.bottomAnchor, constant: edgeInset.bottom).isActive = pinBottom
    }
    
    func addConstraintForWidth(_ width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addConstraintForHeight(_ height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}