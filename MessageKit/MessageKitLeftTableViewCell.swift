//
//  MessageKitLeftTableViewCell.swift
//  MessageKit
//
//  Created by Michael Loistl on 03/11/2014.
//  Copyright (c) 2014 Aplo. All rights reserved.
//

import Foundation
import UIKit

public class MessageKitLeftTableViewCell: MessageKitTableViewCell {
    
    // MARK: - Methods
    
    // MARK: Setup
    
    override public func setupUI() {
        
        rightImageView.hidden = true
        rightImageViewSize = CGSizeZero
        rightImageViewInsets = UIEdgeInsetsZero
        
        contentBackgroundViewInsets = UIEdgeInsetsMake(11, 55, 11, 55)
        contentBackgroundViewRightRelation = .GreaterThanOrEqual
        
        topLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        contentLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        bottomLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        rightImageViewSize = CGSizeMake(33, 33)
        rightImageViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    }
    
}