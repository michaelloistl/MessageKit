//
//  UITableViewExtension.swift
//  MessageKit
//
//  Created by Michael Loistl on 07/12/2015.
//  Copyright © 2015 Aplo. All rights reserved.
//

import Foundation
import UIKit

public extension UIScrollView {
    
    public func scrollToTop() {
        scrollToTopAnimated(false)
    }
    
    public func scrollToTopAnimated(_ animated: Bool) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
    public func scrollToBottom() {
        scrollToBottomAnimated(false)
    }
    
    public func scrollToBottomAnimated(_ animated: Bool) {
        if self.contentSize.height > self.bounds.height {
            let bottomOffset = CGPoint(x: 0.0, y: self.contentSize.height + self.contentInset.top + self.contentInset.bottom - self.bounds.size.height)
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }
}

public extension UITableView {
    
    public override func scrollToBottom() {
        scrollToBottomAnimated(false)
    }
    
    public override func scrollToBottomAnimated(_ animated: Bool) {
        if self.contentSize.height > self.bounds.height {
            let section = numberOfSections - 1
            let rows = numberOfRows(inSection: section)
            let row = rows - 1
            if row > 0 {
                let indexPath = IndexPath(row: row, section: section)
                scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
}
