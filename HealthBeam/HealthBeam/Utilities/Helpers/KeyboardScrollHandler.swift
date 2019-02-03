//
//  KeyboardScrollHandler.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 31.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit

class KeyboardScrollHandler {
    
    private weak var scrollView: UIScrollView!
    private var keyboardHeight: CGFloat?
    private let notificationCenter: NotificationCenter
    
    init(scrollView: UIScrollView, notificationCenter: NotificationCenter, enableTapToDismiss: Bool = true) {
//        scrollView.bounces = false
        self.scrollView = scrollView
        scrollView.keyboardDismissMode = .interactive
        self.notificationCenter = notificationCenter
        
        registerForKeyboardEvents()
        if enableTapToDismiss {
            setTapGestureRecognizer()
        }
    }
    
    deinit {
        unregisterForEvnets()
    }
    
    private func setTapGestureRecognizer() {
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    
    private func registerForKeyboardEvents() {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterForEvnets() {
        notificationCenter.removeObserver(self)
    }
    
}

//MARK: - Gesture Recognizer
extension KeyboardScrollHandler {
    @objc func tapAction(gesture: UIGestureRecognizer) {
        scrollView.firstResponder()?.resignFirstResponder()
    }
}

// MARK: - Notification Events Handling

extension KeyboardScrollHandler {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let strongSelf = self, let keyboardHeight = strongSelf.keyboardHeight else {
                    return
                }
                strongSelf.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.scrollView.contentInset = .zero
            }, completion: { [weak self] success in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.keyboardHeight = nil
        })
    }
}
