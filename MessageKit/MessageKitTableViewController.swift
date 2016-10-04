//
//  MessageKitTableViewController.swift
//  MessageKit
//
//  Created by Michael Loistl on 06/02/2016.
//  Copyright © 2016 Aplo. All rights reserved.
//

import Foundation
import UIKit

public protocol MessageKitTableViewControllerProtocol {
    
    // MARK: - Variables
    
    var tableView: UITableView! { get set }
    var composerView: MessageKitComposerView { get set }
    
    // MARK: - Methods
    
    // MARK: Required
    
    func shouldScrollToBottomOfSection(_ section: Int) -> Bool
    
    // MARK: Optional (Already implemented via Protocol Extension)
    
    func setTableViewContentInset()
}

public extension MessageKitTableViewControllerProtocol {
    
    // MARK: - Methods
    
    func setTableViewContentInset() {
        tableView.contentInset.bottom = composerView.bounds.height + composerView.keyBoardRect.height + 11
    }
}

open class MessageKitTableViewController: UITableViewController, MessageKitTableViewControllerProtocol, MessageKitComposerViewDataSource, MessageKitComposerViewDelegate {
    
    open lazy var composerView: MessageKitComposerView = {
        let _view = MessageKitComposerView(dataSource: self, delegate: self)
        _view.inputBackgroundViewInsets = UIEdgeInsetsMake(8, 53.5, 8, 53.5)
        _view.inputBackgroundView.backgroundColor = UIColor.clear
        
        _view.textViewInsets = UIEdgeInsets.zero
    
//        _view.leftButton.setTitle(nil, forState: .Normal)
//        _view.leftButton.setImage(UIImage(named: "ic_nav_add"), forState: .Normal)
        
        _view.rightButton.setTitleColor(UIColor.black, for: UIControlState())
        _view.rightButton.setTitleColor(UIColor.lightGray, for: .disabled)
        
        _view.placeholder = "Write a message..."
        
        return _view
    }()
    
    // MARK: - Protocols
    
    // MARK: MessageKitTableViewControllerProtocol
    
    open func shouldScrollToBottomOfSection(_ section: Int) -> Bool {
        return true
    }
    
    // MARK: MessageKitComposerViewDataSource
    open func viewControllerForMessageKitComposerView(_ sender: MessageKitComposerView) -> UIViewController? {
        return self
    }
    
    // MARK:  MessageKitComposerViewDelegate
    open func messageKitComposerView(_ sender: MessageKitComposerView, touchedUpInsideLeftButton button: UIButton) {
        
    }
    
    open func messageKitComposerView(_ sender: MessageKitComposerView, touchedUpInsideRightButton button: UIButton) {
        
    }
    
    open func messageKitComposerView(_ sender: MessageKitComposerView, didChangeComposerHeightFrom from: CGFloat, to: CGFloat) {
        
    }
    
    open func messageKitComposerView(_ sender: MessageKitComposerView, didChangeKeyboardRect rect: CGRect) {
        
    }
    
    open func messageKitComposerView(_ sender: MessageKitComposerView, textViewDidBeginEditing textView: UITextView) {
        
    }
    
    open func messageKitComposerView(_ sender: MessageKitComposerView, textViewDidEndEditing textView: UITextView) {
        
    }
    
    open func messageKitComposerView(_ sender: MessageKitComposerView, textViewDidChange textView: UITextView) {
        
    }
}
