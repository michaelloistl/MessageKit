//
//  MessageKitTableViewCell.swift
//  MessageKit
//
//  Created by Michael Loistl on 03/11/2014.
//  Copyright (c) 2014 Aplo. All rights reserved.
//

import Foundation
import UIKit
import ContextLabel
import PureLayout

public protocol MessageKitTableViewCellDelegate {
    func messageTableViewCell(sender: MessageKitTableViewCell, didSelectContextLabelText text: String)
}

public class MessageKitTableViewCell: UITableViewCell, ContextLabelDelegate {
    
    private var contextLabelTouched = false
    
    public var delegate: MessageKitTableViewCellDelegate?
    
    public var leftImageViewSize = CGSizeMake(33, 33)
    public var leftImageViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    public var contentBackgroundViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    public var topLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    public var contentLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    public var bottomLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)

    public var rightImageViewSize = CGSizeMake(33, 33)
    public var rightImageViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    public var contentBackgroundViewLeftRelation: NSLayoutRelation = .Equal
    public var contentBackgroundViewRightRelation: NSLayoutRelation = .Equal
    
    public lazy var headerContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        
        return _view
    }()

    public lazy var leftContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        
        return _view
    }()

    public lazy var leftImageView: UIImageView = {
        let _imageView = UIImageView(forAutoLayout: ())
        _imageView.backgroundColor = UIColor.clearColor()
        _imageView.clipsToBounds = true
        
        return _imageView
    }()

    public lazy var contentBackgroundView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor.clearColor()
        _view.layer.cornerRadius = 16.0
        
        return _view
        }()
    
    public lazy var topLabel: UILabel = {
        let _label = UILabel(forAutoLayout: ())
        _label.numberOfLines = 0
        
        return _label
        }()
    
    public lazy var contentLabel: ContextLabel = {
        let _label = ContextLabel(forAutoLayout: ())
        _label.numberOfLines = 0
        _label.backgroundColor = UIColor.clearColor()
        _label.clipsToBounds = false
        _label.delegate = self
        
        return _label
        }()
    
    public lazy var bottomLabel: UILabel = {
        let _label = UILabel(forAutoLayout: ())
        _label.numberOfLines = 0
        
        return _label
    }()
    
    public lazy var rightImageView: UIImageView = {
        let _imageView = UIImageView(forAutoLayout: ())
        _imageView.backgroundColor = UIColor.clearColor()
        _imageView.clipsToBounds = true
        
        return _imageView
    }()
    
    public lazy var rightContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        
        return _view
    }()
    
    public lazy var footerContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        
        return _view
    }()
    
    // MARK: Initializers
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        contentView.addSubview(headerContentView)
        contentView.addSubview(topLabel)
        contentView.addSubview(leftContentView)
        contentView.addSubview(leftImageView)
        contentView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(contentLabel)
        contentView.addSubview(rightImageView)
        contentView.addSubview(rightContentView)
        contentView.addSubview(bottomLabel)
        contentView.addSubview(footerContentView)
        
        setupUI()
        setupConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override UITableViewCell Functions
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if contextLabelTouched == false {
            super.touchesBegan(touches, withEvent: event)
        }
    }
    
    // MARK: - Methods
    
    // MARK: Setup
    
    public func setupUI() {
        
    }
    
    func setupConstraints() {
        
        // headerContentView
        headerContentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        headerContentView.setContentHuggingPriority(999, forAxis: .Vertical)
        
        // topLabel
        topLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerContentView, withOffset: topLabelInsets.top)
        topLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: topLabelInsets.left)
        topLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -topLabelInsets.right)
        
        // leftContentView
        leftContentView.autoPinEdge(.Top, toEdge: .Top, ofView: contentBackgroundView)
        leftContentView.autoPinEdge(.Left, toEdge: .Left, ofView: contentView)
        leftContentView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentBackgroundView)
        leftContentView.autoPinEdge(.Right, toEdge: .Left, ofView: contentBackgroundView)
        
        // leftImageView
        leftImageView.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: leftImageViewInsets.top)
        leftImageView.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: leftImageViewInsets.left)
        leftImageView.autoSetDimensionsToSize(leftImageViewSize)
        
        // contentBackgroundView
        contentBackgroundView.autoPinEdge(.Top, toEdge: .Bottom, ofView: topLabel, withOffset: contentBackgroundViewInsets.top + topLabelInsets.bottom)
        contentBackgroundView.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: contentBackgroundViewInsets.left, relation: contentBackgroundViewLeftRelation)
        contentBackgroundView.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -contentBackgroundViewInsets.right, relation: contentBackgroundViewRightRelation)

        // contentLabel
        contentLabel.autoPinEdgesToSuperviewEdgesWithInsets(contentLabelInsets)
        contentLabel.setContentCompressionResistancePriority(999, forAxis: .Vertical)
        contentLabel.setContentCompressionResistancePriority(200, forAxis: .Horizontal)
        contentLabel.setContentHuggingPriority(999, forAxis: .Horizontal)
        
        // rightImageView
        rightImageView.autoPinEdge(.Top, toEdge: .Top, ofView: contentView, withOffset: rightImageViewInsets.top)
        rightImageView.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: -rightImageViewInsets.right)
        rightImageView.autoSetDimensionsToSize(rightImageViewSize)
        
        // rightContentView
        rightContentView.autoPinEdge(.Top, toEdge: .Top, ofView: contentBackgroundView)
        rightContentView.autoPinEdge(.Left, toEdge: .Right, ofView: contentBackgroundView)
        rightContentView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentBackgroundView)
        rightContentView.autoPinEdge(.Right, toEdge: .Right, ofView: contentView)
        
        // bottomLabel
        bottomLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: contentBackgroundView, withOffset: contentBackgroundViewInsets.bottom + bottomLabelInsets.top)
        bottomLabel.autoPinEdge(.Left, toEdge: .Left, ofView: contentView, withOffset: bottomLabelInsets.left)
        bottomLabel.autoPinEdge(.Right, toEdge: .Right, ofView: contentView, withOffset: -bottomLabelInsets.right)
        
        // footerContentView
        footerContentView.autoPinEdge(.Top, toEdge: .Bottom, ofView: bottomLabel, withOffset: bottomLabelInsets.bottom)
        footerContentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Top)
        footerContentView.setContentHuggingPriority(999, forAxis: .Vertical)
    }
    
    // MARK: - Protocols
    
    // MARK: ContextLabelDelegate
    
    public func contextLabel(contextLabel: ContextLabel, beganTouchOf text: String, with linkRangeResult: LinkRangeResult) {
        contextLabelTouched = true
    }
    
    public func contextLabel(contextLabel: ContextLabel, movedTouchTo text: String, with linkRangeResult: LinkRangeResult) {
    }
    
    public func contextLabel(contextLabel: ContextLabel, endedTouchOf text: String, with linkRangeResult: LinkRangeResult) {
        contextLabelTouched = false
        
        delegate?.messageTableViewCell(self, didSelectContextLabelText: text)
    }
}
