//
//  MessageKitRightTableViewCell.swift
//  MessageKit
//
//  Created by Michael Loistl on 03/11/2014.
//  Copyright (c) 2014 Aplo. All rights reserved.
//

import Foundation
import UIKit

public class MessageKitRightTableViewCell: MessageKitTableViewCell {
    
    // MARK: - Methods
    
    // MARK: Setup
    
    override public func setupUI() {
        
        leftImageView.hidden = true
        leftImageViewSize = CGSizeZero
        leftImageViewInsets = UIEdgeInsetsZero

        contentBackgroundViewInsets = UIEdgeInsetsMake(11, 55, 11, 55)
        contentBackgroundViewLeftRelation = .GreaterThanOrEqual
        
        topLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        contentLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        bottomLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        rightImageViewSize = CGSizeMake(33, 33)
        rightImageViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    }
}
