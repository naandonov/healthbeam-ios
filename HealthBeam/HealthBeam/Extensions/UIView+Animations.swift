//
//  HealthBeam
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//


import UIKit

typealias AnimationCompletition = (Bool)->()

extension UIView {
    
    func animateScaleDownToIdentityTransformation(withDuration duration: TimeInterval, scaleDownValue: CGFloat, completion:AnimationCompletition? = nil) {
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic], animations: { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self?.transform = CGAffineTransform(scaleX: scaleDownValue, y: scaleDownValue)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self?.transform = CGAffineTransform.identity
            })
            }, completion:{ success in
                if let completion = completion {
                    completion(success)
                }
        })
    }
    
    func animateShake(withDuration duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10) {
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) {
            self.transform = CGAffineTransform(translationX: translation, y: 0)
        }
        
        propertyAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.2)
        
        propertyAnimator.startAnimation()
    }
    
    func animateFade(positive: Bool, duration: TimeInterval = 0.3, completition: AnimationCompletition?) {
        let endAlpha: CGFloat = positive ? 1.0 : 0.0
        let startAlpha: CGFloat = positive ? 0.0 : 1.0
        alpha = startAlpha
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = endAlpha
        }) { (success) in
            if let completition = completition {
                completition(success)
            }
        }
    }
}
