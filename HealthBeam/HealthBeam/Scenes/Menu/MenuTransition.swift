//
//  MenuTransition.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 27.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class MenuTransition: NSObject, UIViewControllerAnimatedTransitioning {

    enum Direction {
        case forward
        case backward
    }

    private let direction: Direction

    private weak var hideableView: UIView?
    private let outerRect: CGRect
    private let innerRect: CGRect
    private let innerSnapshot: UIImage
    private let cornerRadius: CGFloat
    
    init(direction: Direction,
         hideableView: UIView,
         outerRect: CGRect,
         innerRect: CGRect,
         innerSnapshot: UIImage,
         cornerRadius: CGFloat) {
        self.direction = direction
        self.hideableView = hideableView
        self.outerRect = outerRect
        self.innerRect = innerRect
        self.innerSnapshot = innerSnapshot
        self.cornerRadius = cornerRadius
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let hideableView = hideableView
            else {
                return
        }

        let isForwardDirection = direction == .forward

        let finalFrame = toViewController.view.frame
       // let initialFrame = outerRect//contentCellView.convert(contentCellView.frame, to: fromViewController.view)
        //let initialInnerContainerFrame = innerCellContainerView.convert(innerCellContainerView.frame, to: fromViewController.view)
        
        
//        let renderer = UIGraphicsImageRenderer(size: innerCellContainerView.bounds.size)
//        let optionCardImage = renderer.image { ctx in
//            innerCellContainerView.drawHierarchy(in: innerCellContainerView.bounds, afterScreenUpdates: false)
//        }
        let optionCardImageView = UIImageView(image: innerSnapshot)
        optionCardImageView.frame = innerRect
        optionCardImageView.alpha = isForwardDirection ? 1.0 : 0.0

        let expandView = UIView(frame: isForwardDirection ? outerRect : finalFrame)
        expandView.backgroundColor = .white
        expandView.alpha = isForwardDirection ? 0.9 : 0.0
        expandView.layer.cornerRadius = cornerRadius
        expandView.clipsToBounds = true

        let expandViewFinalFrame = isForwardDirection ? finalFrame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) : outerRect
        optionCardImageView.center = expandView.center
        
        transitionContext.containerView.addSubview(toViewController.view)
        transitionContext.containerView.addSubview(expandView)
        transitionContext.containerView.addSubview(optionCardImageView)
        
        toViewController.view.alpha = 0.0
        hideableView.isHidden = true

        switch direction {
        case .forward:
            toViewController.navigationController?.navigationBar.alpha = 0.0
            toViewController.navigationItem.searchController?.searchBar.alpha = 0.0
        case .backward:
            fromViewController.navigationController?.navigationBar.alpha =  0.5
            fromViewController.navigationItem.searchController?.searchBar.alpha = 0.5
        }
        

        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {  [weak self] in
                guard let direction = self?.direction else {
                    return
                }

                switch direction {
                case .forward:
                    optionCardImageView.center = toViewController.view.center
                    expandView.frame = expandViewFinalFrame
                    toViewController.navigationController?.navigationBar.alpha = 0.0
                    toViewController.navigationItem.searchController?.searchBar.alpha = 0.0
                case .backward:
                    optionCardImageView.alpha = 1.0
                    expandView.alpha = 0.9
                    fromViewController.navigationController?.navigationBar.alpha = 0.0
                    fromViewController.navigationItem.searchController?.searchBar.alpha = 0.0
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.0) {
                toViewController.view.alpha = 1.0
                toViewController.navigationItem.searchController?.searchBar.alpha = 1.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) { [weak self] in
                guard let direction = self?.direction else {
                    return
                }

                switch direction {
                case .forward:
                    toViewController.navigationController?.navigationBar.alpha = 1.0
                    optionCardImageView.alpha = 0.0
                    expandView.alpha = 0.0
                case .backward:
                    expandView.frame = self?.outerRect ?? .zero
                    optionCardImageView.center = expandView.center
                    break
                }
            }
            }, completion:{ success in
                hideableView.isHidden = false
                optionCardImageView.removeFromSuperview()
                expandView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
