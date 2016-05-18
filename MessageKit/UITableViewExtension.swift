//
//  UITableViewExtension.swift
//  MessageKit
//
//  Created by Michael Loistl on 07/12/2015.
//  Copyright © 2015 Aplo. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {

    public func scrollToBottomAnimated(animated: Bool) {
        let section = numberOfSections - 1
        if section >= 0 {
            scrollToBottomOfSection(section, animated: animated)
        }
    }
    
    public func scrollToBottomOfSection(section: Int = 0, animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) { 
            if self.numberOfRowsInSection(section) > 0 {
                let row = self.numberOfRowsInSection(section) - 1
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: animated)
            }
        }
    }
    
    func finishReceivingMessageAnimated(animated: Bool) {
        
    }

    func finishSendingMessageAnimated(animated: Bool) {
        
    }

}