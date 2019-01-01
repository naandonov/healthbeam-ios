//
//  LoadingOverlay.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

typealias LoadingOverlayAnimationCompletion = (Bool) -> ()

class LoadingOverlay {
    
    private static let animationDuration = 0.3
    
    private static var loadingOverlayView: LoadingOverlayView = LoadingOverlayView.fromNib()
    
    //No instances should be created
    private init() { }
    
    static func showOn(_ view: UIView, completion: LoadingOverlayAnimationCompletion? = nil) {
        loadingOverlayView.alpha = 0.0
        view.addSubview(loadingOverlayView)
        view.addConstraintsForWrappedInsideView(loadingOverlayView)
        UIView.animate(withDuration: animationDuration, animations: {
            loadingOverlayView.alpha = 1.0
        }, completion: completion)
    }
    
    static func hide(_ completion: LoadingOverlayAnimationCompletion? = nil) {
        UIView.animate(withDuration: animationDuration, animations: {
            loadingOverlayView.alpha = 0.0
        }, completion: { success in
            loadingOverlayView.removeFromSuperview()
            if let completion = completion {
                completion(success)
            }
        })
    }
    
    static func hideWithSuccess(_ completion: LoadingOverlayAnimationCompletion? = nil) {
        UIView.animate(withDuration: animationDuration, animations: {
            loadingOverlayView.loadingAnimationView.alpha = 0.0
        }, completion: { success in
            loadingOverlayView.successAnimationView.play(completion: { success in
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
                UIView.animate(withDuration: animationDuration, animations: {
                    loadingOverlayView.alpha = 0.0
                }, completion: { success in
                    loadingOverlayView.successAnimationView.animationProgress = 0
                    loadingOverlayView.removeFromSuperview()
                    loadingOverlayView.loadingAnimationView.alpha = 1.0
                    if let completion = completion {
                        completion(success)
                    }
                })
            })
        })
    }
}
