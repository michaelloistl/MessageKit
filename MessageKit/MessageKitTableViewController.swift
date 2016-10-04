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
    
    func shouldScrollToBottomOfSection(section: Int) -> Bool
    
    // MARK: Optional (Already implemented via Protocol Extension)
    
    func setTableViewContentInset()
}

public extension MessageKitTableViewControllerProtocol {
    
    // MARK: - Methods
    
    func setTableViewContentInset() {
        tableView.contentInset.bottom = composerView.bounds.height + composerView.keyBoardRect.height + 11
    }
}

public class MessageKitTableViewController: UITableViewController, MessageKitTableViewControllerProtocol, MessageKitComposerViewDataSource, MessageKitComposerViewDelegate {
    
    public lazy var composerView: MessageKitComposerView = {
        let _view = MessageKitComposerView(dataSource: self, delegate: self)
        _view.inputBackgroundViewInsets = UIEdgeInsetsMake(8, 53.5, 8, 53.5)
        _view.inputBackgroundView.backgroundColor = UIColor.clearColor()
        
        _view.textViewInsets = UIEdgeInsetsZero
    
//        _view.leftButton.setTitle(nil, forState: .Normal)
//        _view.leftButton.setImage(UIImage(named: "ic_nav_add"), forState: .Normal)
        
        _view.rightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        _view.rightButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        
        _view.placeholder = "Write a message..."
        
        return _view
    }()
    
    // MARK: - Protocols
    
    // MARK: MessageKitTableViewControllerProtocol
    
    public func shouldScrollToBottomOfSection(section: Int) -> Bool {
        return true
    }
    
    // MARK: MessageKitComposerViewDataSource
    public func viewControllerForMessageKitComposerView(sender: MessageKitComposerView) -> UIViewController? {
        return self
    }
    
    // MARK:  MessageKitComposerViewDelegate
    public func messageKitComposerView(sender: MessageKitComposerView, touchedUpInsideLeftButton button: UIButton) {
        
    }
    
    public func messageKitComposerView(sender: MessageKitComposerView, touchedUpInsideRightButton button: UIButton) {
        
    }
    
    public func messageKitComposerView(sender: MessageKitComposerView, didChangeComposerHeightFrom from: CGFloat, to: CGFloat) {
        
    }
    
    public func messageKitComposerView(sender: MessageKitComposerView, didChangeKeyboardRect rect: CGRect) {
        
    }
    
    public func messageKitComposerView(sender: MessageKitComposerView, textViewDidBeginEditing textView: UITextView) {
        
    }
    
    public func messageKitComposerView(sender: MessageKitComposerView, textViewDidEndEditing textView: UITextView) {
        
    }
    
    public func messageKitComposerView(sender: MessageKitComposerView, textViewDidChange textView: UITextView) {
        
    }
}
