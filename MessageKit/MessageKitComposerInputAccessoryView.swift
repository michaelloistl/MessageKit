//
//  MessageComposerInputAccessoryView.swift
//  MessageKit
//
//  Created by Michael Loistl on 08/12/2015.
//  Copyright © 2015 Aplo. All rights reserved.
//

import Foundation
import UIKit

let KeyboardFrameDidChangeNotification = "com.aplo.KeyboardFrameDidChangeNotification"

public class MessageKitComposerInputAccessoryView: UIView {
    
    weak var observedSuperview: UIView?
    
    // MARK: - Initializers
    
    deinit {
        removeSuperviewObserver()
    }
    
    // MARK: - Super
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        removeSuperviewObserver()
        addSuperviewObserver(newSuperview)
        super.willMoveToSuperview(newSuperview)
    }
    
    // MARK: KVO Listener
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let keyPath = keyPath, object = object as? UIView, observedSuperview = observedSuperview {
            if object == observedSuperview && keyPath == "center" {
                didChangeKeyboardFrame(observedSuperview.frame)
            } else {
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: - Methods
    
    func addSuperviewObserver(superview: UIView?) {
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
    
    func didChangeKeyboardFrame(frame: CGRect) {
        let userInfo: [NSObject: AnyObject] = [UIKeyboardFrameEndUserInfoKey: NSValue(CGRect: frame)]
        NSNotificationCenter.defaultCenter().postNotificationName(KeyboardFrameDidChangeNotification, object: nil, userInfo: userInfo)
    }
}