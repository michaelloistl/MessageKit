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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public protocol MessageKitTableViewCellDelegate {
    func messageTableViewCell(_ sender: MessageKitTableViewCell, didSelectContextLabelText text: String)
}

open class MessageKitTableViewCell: UITableViewCell {
    
    fileprivate var contextLabelTouched = false
    
    open var delegate: MessageKitTableViewCellDelegate?
    
    open var leftImageViewSize = CGSize(width: 33, height: 33)
    open var leftImageViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    open var headerContentInsets = UIEdgeInsets.zero
    
    open var contentBackgroundViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    open var topLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11) {
        didSet {
            topLabel.contentInsets = topLabelInsets
        }
    }
    
    open var contentLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    open var bottomLabelInsets = UIEdgeInsetsMake(11, 11, 11, 11) {
        didSet {
            bottomLabel.contentInsets = bottomLabelInsets
        }
    }
    
    open var footerContentInsets = UIEdgeInsets.zero

    open var rightImageViewSize = CGSize(width: 33, height: 33)
    open var rightImageViewInsets = UIEdgeInsetsMake(11, 11, 11, 11)
    
    open var contentBackgroundViewLeftRelation: NSLayoutRelation = .equal
    open var contentBackgroundViewRightRelation: NSLayoutRelation = .equal
    
    open lazy var headerContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        
        return _view
    }()

    open lazy var leftContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        
        return _view
    }()

    open lazy var leftImageView: UIImageView = {
        let _imageView = UIImageView(forAutoLayout: ())
        _imageView.backgroundColor = UIColor.clear
        _imageView.clipsToBounds = true
        
        return _imageView
    }()

    open lazy var contentBackgroundView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor.clear
        _view.layer.cornerRadius = 16.0
        
        return _view
        }()
    
    open lazy var topLabel: MessageLabel = {
        let _label = MessageLabel(forAutoLayout: ())
        _label.numberOfLines = 0
        
        return _label
        }()
    
    open lazy var contentLabel: ContextLabel = {
        let _label = ContextLabel(frame: CGRect.zero, didTouch: { (touchResult) in
            if touchResult.state == .began {
                self.contextLabelTouched = true
            } else if touchResult.state == .ended {
                self.contextLabelTouched = false
            }
        })
        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.numberOfLines = 0
        _label.backgroundColor = .clear
        _label.clipsToBounds = false
        
        return _label
        }()
    
    open lazy var bottomLabel: MessageLabel = {
        let _label = MessageLabel(forAutoLayout: ())
        _label.numberOfLines = 0
        
        return _label
    }()
    
    open lazy var rightImageView: UIImageView = {
        let _imageView = UIImageView(forAutoLayout: ())
        _imageView.backgroundColor = UIColor.clear
        _imageView.clipsToBounds = true
        
        return _imageView
    }()
    
    open lazy var rightContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        
        return _view
    }()
    
    open lazy var footerContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        
        return _view
    }()
    
    // MARK: Initializers
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
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
        
        topLabel.contentInsets = topLabelInsets
        bottomLabel.contentInsets = bottomLabelInsets
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override UITableViewCell Functions
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if contextLabelTouched == false {
            super.touchesBegan(touches, with: event)
        }
    }
    
    // MARK: - Methods
    
    // MARK: Setup
    
    open func setupUI() {
        
    }
    
    func setupConstraints() {
        
        // headerContentView
        headerContentView.autoPinEdgesToSuperviewEdges(with: headerContentInsets, excludingEdge: .bottom)
        headerContentView.setContentHuggingPriority(999, for: .vertical)
        
        // topLabel
        topLabel.autoPinEdge(.top, to: .bottom, of: headerContentView)
        topLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: topLabelInsets.left)
        topLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: -topLabelInsets.right)
        
        // leftContentView
        leftContentView.autoPinEdge(.top, to: .top, of: contentBackgroundView)
        leftContentView.autoPinEdge(.left, to: .left, of: contentView)
        leftContentView.autoPinEdge(.bottom, to: .bottom, of: contentBackgroundView)
        leftContentView.autoPinEdge(.right, to: .left, of: contentBackgroundView)
        
        // leftImageView
        leftImageView.autoPinEdge(.top, to: .top, of: contentView, withOffset: leftImageViewInsets.top)
        leftImageView.autoPinEdge(.left, to: .left, of: contentView, withOffset: leftImageViewInsets.left)
        leftImageView.autoSetDimensions(to: leftImageViewSize)
        
        // contentBackgroundView
        contentBackgroundView.autoPinEdge(.top, to: .bottom, of: topLabel, withOffset: contentBackgroundViewInsets.top)
        contentBackgroundView.autoPinEdge(.left, to: .left, of: contentView, withOffset: contentBackgroundViewInsets.left, relation: contentBackgroundViewLeftRelation)
        contentBackgroundView.autoPinEdge(.right, to: .right, of: contentView, withOffset: -contentBackgroundViewInsets.right, relation: contentBackgroundViewRightRelation)

        // contentLabel
        contentLabel.autoPinEdgesToSuperviewEdges(with: contentLabelInsets)
        contentLabel.setContentCompressionResistancePriority(999, for: .vertical)
        contentLabel.setContentCompressionResistancePriority(200, for: .horizontal)
        contentLabel.setContentHuggingPriority(999, for: .horizontal)
        
        // rightImageView
        rightImageView.autoPinEdge(.top, to: .top, of: contentView, withOffset: rightImageViewInsets.top)
        rightImageView.autoPinEdge(.left, to: .left, of: contentView, withOffset: -rightImageViewInsets.right)
        rightImageView.autoSetDimensions(to: rightImageViewSize)
        
        // rightContentView
        rightContentView.autoPinEdge(.top, to: .top, of: contentBackgroundView)
        rightContentView.autoPinEdge(.left, to: .right, of: contentBackgroundView)
        rightContentView.autoPinEdge(.bottom, to: .bottom, of: contentBackgroundView)
        rightContentView.autoPinEdge(.right, to: .right, of: contentView)
        
        // bottomLabel
        bottomLabel.autoPinEdge(.top, to: .bottom, of: contentBackgroundView, withOffset: contentBackgroundViewInsets.bottom)
        bottomLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: bottomLabelInsets.left)
        bottomLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: -bottomLabelInsets.right)
        
        // footerContentView
        footerContentView.autoPinEdge(.top, to: .bottom, of: bottomLabel)
        footerContentView.autoPinEdgesToSuperviewEdges(with: footerContentInsets, excludingEdge: .top)
        footerContentView.setContentHuggingPriority(999, for: .vertical)
    }
    
    // MARK: - Protocols
    
//    // MARK: ContextLabelDelegate
//    
//    open func contextLabel(_ contextLabel: ContextLabel, beganTouchOf text: String, with linkRangeResult: LinkRangeResult) {
//        contextLabelTouched = true
//    }
//    
//    open func contextLabel(_ contextLabel: ContextLabel, movedTouchTo text: String, with linkRangeResult: LinkRangeResult) {
//    }
//    
//    open func contextLabel(_ contextLabel: ContextLabel, endedTouchOf text: String, with linkRangeResult: LinkRangeResult) {
//        contextLabelTouched = false
//        
//        delegate?.messageTableViewCell(self, didSelectContextLabelText: text)
//    }
}

open class MessageLabel: UILabel {
    
    open var contentInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    open override var intrinsicContentSize : CGSize {
        let width = super.intrinsicContentSize.width
        let height = (text?.characters.count > 0) ? contentInsets.top + super.intrinsicContentSize.height + contentInsets.bottom : 0
        
        return CGSize(width: width, height: height)
    }
}
