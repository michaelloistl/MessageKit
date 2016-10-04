//
//  MessageKitRightTableViewCell.swift
//  MessageKit
//
//  Created by Michael Loistl on 03/11/2014.
//  Copyright (c) 2014 Aplo. All rights reserved.
//

import Foundation
import UIKit

open class MessageKitRightTableViewCell: MessageKitTableViewCell {
    
    // MARK: - Methods
    
    // MARK: Setup
    
    override open func setupUI() {
        
        leftImageView.isHidden = true
        leftImageViewSize = CGSize.zero
        leftImageViewInsets = UIEdgeInsets.zero

        contentBackgroundViewInsets = UIEdgeInsetsMake(11, 55, 11, 55)
        contentBackgroundViewLeftRelation = .greaterThanOrEqual
        
        topLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        contentLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        bottomLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
        rightImageViewSize = CGSize(width: 33, height: 33)
        rightImageViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    }
}
