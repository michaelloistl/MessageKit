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
    func scrollToBottomOfSection(section: Int, animated: Bool)
}

public extension MessageKitTableViewControllerProtocol {
    
    // MARK: - Methods
    
    func setTableViewContentInset() {
        tableView.contentInset.bottom = composerView.bounds.height + composerView.keyBoardRect.height + 11
    }
    
    func scrollToBottomOfSection(section: Int, animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            if self.tableView.numberOfRowsInSection(section) > 0 {
                let row = self.tableView.numberOfRowsInSection(section) - 1
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: animated)
            }
        }
    }
}

public class MessageKitTableViewController: UITableViewController, MessageKitTableViewControllerProtocol, MessageKitComposerViewDataSource, MessageKitComposerViewDelegate {
    
    public lazy var composerView: MessageKitComposerView = {
        let _view = MessageKitComposerView(dataSource: self, delegate: self)
        _view.inputBackgroundViewInsets = UIEdgeInsetsMake(8, 53.5, 8, 53.5)
        _view.inputBackgroundView.backgroundColor = UIColor.clearColor()
        
        _view.textViewInsets = UIEdgeInsetsZero
        _view.textViewContentInset = UIEdgeInsetsMake(3, 0, 0, 0)
        _view.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
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
    
    public func messageKitComposerView(sender: MessageKitComposerView, didChangeComposerHeight height: CGFloat) {
        
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




//// MARK: ScrollViewDelegate
//
//func scrollViewDidScroll(scrollView: UIScrollView) {
//    if scrollView.contentOffset.y > scrollToBottomContentOffsetY - 44.0 {
//        shouldScroll = true
//    }
//}
//
//func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//    draggingTableView = true
//    shouldScroll = false
//}
//
//func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//    if decelerate == false {
//        draggingTableView = false
//    }
//}
//
//func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//    draggingTableView = false
//}