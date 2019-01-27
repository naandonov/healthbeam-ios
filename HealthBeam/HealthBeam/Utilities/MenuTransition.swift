//
//  MenuTransition.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 27.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class MenuTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let cardCornerRadius: CGFloat = 30.0
    
    enum Direction {
        case forward
        case backward
    }
    
    
    private weak var cell: MenuCollectionViewCell?
    private let direction: Direction
    

    
    init(cell: MenuCollectionViewCell?, direction: Direction) {
        self.cell = cell
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let cell = cell,
            let innerCellContainerView = cell.innerContainerView
            else {
                return
        }
    
        let contentCellView = cell.contentView
        
        let finalFrame = toViewController.view.frame
        let initialFrame = contentCellView.convert(contentCellView.frame, to: fromViewController.view)
        let initialInnerContainerFrame = innerCellContainerView.convert(innerCellContainerView.frame, to: fromViewController.view)
        
        
        let renderer = UIGraphicsImageRenderer(size: innerCellContainerView.bounds.size)
        let optionCardImage = renderer.image { ctx in
            innerCellContainerView.drawHierarchy(in: innerCellContainerView.bounds, afterScreenUpdates: false)
        }
        let optionCardImageView = UIImageView(image: optionCardImage)
        optionCardImageView.frame = initialInnerContainerFrame

        
        let expandView = UIView(frame: initialFrame)
        expandView.backgroundColor = .white
        expandView.alpha = 0.9
        expandView.layer.cornerRadius = cardCornerRadius
        expandView.clipsToBounds = true
        let expandViewFinalFrame = finalFrame.inset(by: UIEdgeInsets(top: 0,
                                                                     left: 0,
                                                                     bottom: 0,
                                                                     right: 0))
        optionCardImageView.center = expandView.center
        
        transitionContext.containerView.addSubview(toViewController.view)
        transitionContext.containerView.addSubview(expandView)
        transitionContext.containerView.addSubview(optionCardImageView)
        
        toViewController.view.alpha = 0.0
        cell.isHidden = true
        
        toViewController.navigationController?.navigationBar.alpha = 0.0
        toViewController.navigationItem.searchController?.searchBar.alpha = 0.0
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                optionCardImageView.center = toViewController.view.center
                expandView.frame = expandViewFinalFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.0) {
                toViewController.view.alpha = 1.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                optionCardImageView.alpha = 0.0
                expandView.alpha = 0.0
                toViewController.navigationController?.navigationBar.alpha = 1.0
                toViewController.navigationItem.searchController?.searchBar.alpha = 1.0
            }
            }, completion:{ success in
                cell.isHidden = false
                optionCardImageView.removeFromSuperview()
                expandView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
