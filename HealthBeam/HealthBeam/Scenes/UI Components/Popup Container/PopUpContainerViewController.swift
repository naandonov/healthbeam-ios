//
//  PopUpContainerViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 10.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class PopUpContainerViewController: UIViewController {

    @IBOutlet weak var containerView: CardView!
    
    private weak var containedViewController: UIViewController?
    
    static func generate(forContainedViewController containedViewController: UIViewController) -> PopUpContainerViewController {
        let viewController = PopUpContainerViewController(nibName: "PopUpContainerViewController", bundle: nil)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        viewController.containedViewController = containedViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let containedViewController = containedViewController {
//            containerView.clipsToBounds = true
//            containerView.layer.cornerRadius = StyleCoordinator.Metrics.cardViewCornerRadius
            addContainedViewController(containedViewController)
        }
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        removeContainedViewController()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let maskLayer = containerView.layer.sublayers?.first as? CAShapeLayer {
            let contentMaskLayer = CAShapeLayer()
            contentMaskLayer.frame = containerView.bounds
            contentMaskLayer.path = maskLayer.path
            containedViewController!.view.layer.mask = contentMaskLayer
        }

    }
}


//MARK: - Utilities

extension PopUpContainerViewController {
    
    private func addContainedViewController(_ containedViewController: UIViewController) {
        addChild(containedViewController)
        containedViewController.view.layer.mask = containerView.layer.mask
        
        containerView.addConstraintsForWrappedInsideView(containedViewController.view)
        containedViewController.didMove(toParent: self)
        self.containedViewController = containedViewController
    }
    
    func removeContainedViewController() {
        willMove(toParent: nil)
        containedViewController?.view.removeFromSuperview()
        removeFromParent()
    }
}
