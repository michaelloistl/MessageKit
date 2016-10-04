//
//  MessageComposerInputAccessoryView.swift
//  MessageKit
//
//  Created by Michael Loistl on 08/12/2015.
//  Copyright © 2015 Aplo. All rights reserved.
//

import Foundation
import UIKit

public let KeyboardFrameDidChangeNotification = "com.aplo.KeyboardFrameDidChangeNotification"

open class MessageKitComposerInputAccessoryView: UIView {
    
    weak var observedSuperview: UIView?
    
    // MARK: - Initializers
    
    deinit {
        removeSuperviewObserver()
    }
    
    // MARK: - Super
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        removeSuperviewObserver()
        addSuperviewObserver(newSuperview)
        super.willMove(toSuperview: newSuperview)
    }
    
    // MARK: KVO Listener
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let keyPath = keyPath, let object = object as? UIView, let observedSuperview = observedSuperview {
            if object == observedSuperview && keyPath == "center" {
                didChangeKeyboardFrame(observedSuperview.frame)
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Methods
    
    func addSuperviewObserver(_ superview: UIView?) {
        if observedSuperview != nil {
            return
        }
        
        if let superview = superview {
            observedSuperview = superview
            observedSuperview?.addObserver(self, forKeyPath: "center", options: [], context: nil)
        }
    }
    
    func removeSuperviewObserver() {
        if observedSuperview == nil {
            return
        }
        
        observedSuperview?.removeObserver(self, forKeyPath: "center")
        observedSuperview = nil
    }
    
    func didChangeKeyboardFrame(_ frame: CGRect) {
        let userInfo: [AnyHashable: Any] = [UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: frame)]
        NotificationCenter.default.post(name: Notification.Name(rawValue: KeyboardFrameDidChangeNotification), object: nil, userInfo: userInfo)
    }
}
