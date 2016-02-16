//
//  MessageComposerView.swift
//  MessageKit
//
//  Created by Michael Loistl on 12/11/2015.
//  Copyright © 2015 Aplo. All rights reserved.
//

import Foundation
import UIKit

public protocol MessageKitComposerViewDataSource {
    func viewControllerForMessageKitComposerView(sender: MessageKitComposerView) -> UIViewController?
}

public protocol MessageKitComposerViewDelegate {
    func messageKitComposerView(sender: MessageKitComposerView, touchedUpInsideLeftButton button: UIButton)
    func messageKitComposerView(sender: MessageKitComposerView, touchedUpInsideRightButton button: UIButton)
    
    func messageKitComposerView(sender: MessageKitComposerView, didChangeComposerHeight height: CGFloat)
    func messageKitComposerView(sender: MessageKitComposerView, didChangeKeyboardRect rect: CGRect)
    
    func messageKitComposerView(sender: MessageKitComposerView, textViewDidBeginEditing textView: UITextView)
    func messageKitComposerView(sender: MessageKitComposerView, textViewDidEndEditing textView: UITextView)
    
    func messageKitComposerView(sender: MessageKitComposerView, textViewDidChange textView: UITextView)
}

public class MessageKitComposerView: UIView, UITextViewDelegate {

    public var dataSource: MessageKitComposerViewDataSource!
    public var delegate: MessageKitComposerViewDelegate!

    public var numberOfLines: Int = 5
    
    public var inputBackgroundViewInsets = UIEdgeInsetsMake(8, 55, 8, 55)
    public var textViewInsets = UIEdgeInsetsMake(0, 8, 0, 8)
    
    public var placeholderLabelOffset = UIOffsetMake(0, 0)
    public var leftButtonCenterOffset = UIOffsetMake(0, 0)
    public var rightButtonCenterOffset = UIOffsetMake(0, 0)
    
    public var textViewContentInset = UIEdgeInsetsMake(8, 0, 0, 0) {
        didSet {
        textView.contentInset = textViewContentInset
        }
    }
    
    public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    
    public var minComposerHeight: CGFloat = 44 {
        didSet {
            _composerHeight = max(_composerHeight, minComposerHeight)
        }
    }
    
    private var _keyBoardRect: CGRect = CGRectZero {
        didSet {
            updateFrame()
            
            delegate?.messageKitComposerView(self, didChangeKeyboardRect: _keyBoardRect)
        }
    }
    
    private var _composerHeight: CGFloat = 44 {
        didSet {
            updateFrame()
        
            if _composerHeight != oldValue {
                delegate?.messageKitComposerView(self, didChangeComposerHeight: _composerHeight)
            }
        }
    }
    
    public var scrollViewBottomInset: CGFloat {
        if let viewController = dataSource?.viewControllerForMessageKitComposerView(self) {
            let bottomLayoutGuideLength = viewController.bottomLayoutGuide.length
            var bottomHeight = bottomLayoutGuideLength
            if CGRectGetMinY(keyBoardRect) > 0 {
                bottomHeight = max((CGRectGetMaxY(viewController.view.bounds) - CGRectGetMinY(keyBoardRect)), bottomLayoutGuideLength)
            }
            
            return composerHeight + bottomHeight
        }
        return 0
    }
    
    public var composerHeight: CGFloat {
        return _composerHeight
    }
    
    public var keyBoardRect: CGRect {
        return _keyBoardRect
    }
    
    public lazy var leftButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("Upload", forState: .Normal)
        _button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        _button.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0.5), forState: .Disabled)
        _button.titleLabel?.font = UIFont.systemFontOfSize(17)
        
        _button.addTarget(self, action: Selector("leftButtonTouchedUpInside:"), forControlEvents: .TouchUpInside)
        
        return _button
    }()

    public lazy var rightButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("Send", forState: .Normal)
        _button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        _button.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0.5), forState: .Disabled)
        _button.titleLabel?.font = UIFont.systemFontOfSize(17)
        _button.enabled = false
        
        _button.addTarget(self, action: Selector("rightButtonTouchedUpInside:"), forControlEvents: .TouchUpInside)
        
        return _button
    }()
    
    public lazy var inputBackgroundView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor(white: 0, alpha: 0.05)
        _view.layer.cornerRadius = 5
        
        return _view
    }()
    
    lazy var messageKitComposerInputAccessoryView: MessageKitComposerInputAccessoryView = {
        let _view = MessageKitComposerInputAccessoryView()
        _view.userInteractionEnabled = false
        
        return _view
    }()
    
    public lazy var textView: UITextView = {
        let _textView = UITextView()
        _textView.backgroundColor = UIColor.clearColor()
        _textView.inputAccessoryView = self.messageKitComposerInputAccessoryView
        _textView.delegate = self
        _textView.scrollsToTop = false
        
        _textView.contentInset = self.textViewContentInset
        _textView.textContainerInset = UIEdgeInsetsZero
        _textView.textContainer.lineFragmentPadding = 0
        
        return _textView
        }()
    
    public lazy var placeholderLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColor.lightGrayColor()
        _label.backgroundColor = UIColor.clearColor()
        
        return _label
    }()
    
    lazy var topBorderView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        return _view
    }()
    
    public lazy var topOuterContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor.redColor()
        
        return _view
    }()
    
    public lazy var topInnerContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor.blueColor()
        
        return _view
    }()
    
    // MARK: - Initializers
    
    required public convenience init(dataSource: MessageKitComposerViewDataSource, delegate: MessageKitComposerViewDelegate) {
        self.init(frame: CGRectZero)
        
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(topOuterContentView)
        addSubview(topInnerContentView)
        addSubview(topBorderView)
        
        addSubview(leftButton)
        addSubview(inputBackgroundView)
        addSubview(rightButton)
        
        inputBackgroundView.addSubview(placeholderLabel)
        inputBackgroundView.addSubview(textView)
        
        // Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardFrameDidChangeNotification:"), name: KeyboardFrameDidChangeNotification, object: nil)
        
        setupConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Super
    
    public override func intrinsicContentSize() -> CGSize {
        let width = super.intrinsicContentSize().width
        return CGSize(width: width, height: composerHeight)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        // self
        updateFrame()
        
        // inputBackgroundView
        let inputBackgroundViewSizeHeight = _composerHeight - inputBackgroundViewInsets.top - inputBackgroundViewInsets.bottom
        let inputBackgroundViewSizeWidth = bounds.width - inputBackgroundViewInsets.left - inputBackgroundViewInsets.right
        let inputBackgroundViewOriginX = inputBackgroundViewInsets.left
        let inputBackgroundViewOriginY = bounds.height - inputBackgroundViewInsets.bottom - inputBackgroundViewSizeHeight
        
        inputBackgroundView.frame = CGRectMake(inputBackgroundViewOriginX, inputBackgroundViewOriginY, inputBackgroundViewSizeWidth, inputBackgroundViewSizeHeight)
        
        // textView
        let textViewSizeHeight = inputBackgroundViewSizeHeight - textViewInsets.top - textViewInsets.bottom
        let textViewSizeWidth = inputBackgroundViewSizeWidth - textViewInsets.left - textViewInsets.right
        let textViewOriginX = textViewInsets.left
        let textViewOriginY = textViewInsets.top
        
        textView.frame = CGRectMake(textViewOriginX, textViewOriginY, textViewSizeWidth, textViewSizeHeight)
        
        // placeholderLabel
        placeholderLabel.font = textView.font
        placeholderLabel.sizeToFit()
        
        let placeholderLabelSizeHeight = placeholderLabel.bounds.height
        let placeholderLabelSizeWidth = textViewSizeWidth
        let placeholderLabelOriginX = textViewOriginX + placeholderLabelOffset.horizontal
        let placeholderLabelOriginY = textViewOriginY + 4 + placeholderLabelOffset.vertical
        
        placeholderLabel.frame = CGRectMake(placeholderLabelOriginX, placeholderLabelOriginY, placeholderLabelSizeWidth, placeholderLabelSizeHeight)
        
        // leftButton
        if !leftButton.hidden {
            leftButton.sizeToFit()
            let leftButtonCenterX = (inputBackgroundViewInsets.left / 2) + leftButtonCenterOffset.horizontal
            let leftButtonCenterY = (bounds.height - (minComposerHeight / 2)) + leftButtonCenterOffset.vertical
            
            leftButton.center = CGPointMake(leftButtonCenterX, leftButtonCenterY)
        }
        
        // rightButton
        if !rightButton.hidden {
            rightButton.sizeToFit()
            let rightButtonCenterX = (bounds.width - inputBackgroundViewInsets.right / 2) + rightButtonCenterOffset.horizontal
            let rightButtonCenterY = (bounds.height - (minComposerHeight / 2)) + rightButtonCenterOffset.vertical
            
            rightButton.center = CGPointMake(rightButtonCenterX, rightButtonCenterY)
        }
        
        // contentView
        
    }
    
    public override func isFirstResponder() -> Bool {
        return textView.isFirstResponder()
    }
    
    public override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layoutSubviews()
    }
    
    // MARK: - Methods
    
    func setupConstraints() {
        
        // topOuterContentView
        topOuterContentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: .Bottom)
        
        // topBorderView
        topBorderView.autoPinEdge(.Top, toEdge: .Bottom, ofView: topOuterContentView)
        topBorderView.autoPinEdge(.Left, toEdge: .Left, ofView: self)
        topBorderView.autoPinEdge(.Right, toEdge: .Right, ofView: self)
        topBorderView.autoSetDimension(.Height, toSize: 1)
        
        // topInnerContentView
        topInnerContentView.autoPinEdge(.Top, toEdge: .Bottom, ofView: topBorderView)
        topInnerContentView.autoPinEdge(.Left, toEdge: .Left, ofView: self)
        topInnerContentView.autoPinEdge(.Right, toEdge: .Right, ofView: self)
    }
    
    func updateFrame() {
        if let superview = superview {
            let viewController = dataSource.viewControllerForMessageKitComposerView(self)
            let bottomLayoutGuideLength = viewController?.bottomLayoutGuide.length ?? 0
            let keyBoardMinY = (CGRectGetMinY(_keyBoardRect) > 0) ? CGRectGetMinY(_keyBoardRect) : CGRectGetHeight(superview.bounds)
            
            let sizeHeight: CGFloat = _composerHeight + topInnerContentView.bounds.height + topBorderView.bounds.height + topOuterContentView.bounds.height
            let sizeWidth: CGFloat = CGRectGetWidth(superview.bounds)
            let originX: CGFloat = 0
            let originMaxY = CGRectGetHeight(superview.bounds) - sizeHeight - bottomLayoutGuideLength
            let originY: CGFloat = min(keyBoardMinY - sizeHeight, originMaxY)
            
            frame = CGRectMake(originX, originY, sizeWidth, sizeHeight)
        }
    }
    
    public func resetComposer() {
        textView.text = nil
        setComposerHeightWithText(nil)
        
        delegate?.messageKitComposerView(self, textViewDidChange: textView)
    }
    
    func setComposerHeightWithText(text: String?) {
        let width = CGRectGetWidth(textView.bounds)
        var height = minComposerHeight
        if let text = text, font = textView.font {
            let maxSize = CGSizeMake(width, CGFloat.max)
            let attributes: [String : AnyObject] = [NSFontAttributeName: font]
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            
            let textHeight = ceil(attributedString.boundingRectWithSize(maxSize, options: [.UsesLineFragmentOrigin], context: nil).height)
            let maxTextHeight = font.lineHeight * CGFloat(numberOfLines)
            
            height = inputBackgroundViewInsets.top + textViewInsets.top + textViewContentInset.top + min(textHeight, maxTextHeight) + textViewContentInset.bottom + textViewInsets.bottom + inputBackgroundViewInsets.bottom
        }

        _composerHeight = max(height, minComposerHeight)
    }
    
    // MARK: Actions
    
    func rightButtonTouchedUpInside(sender: UIButton) {
        delegate?.messageKitComposerView(self, touchedUpInsideRightButton: sender)
    }

    func leftButtonTouchedUpInside(sender: UIButton) {
        delegate?.messageKitComposerView(self, touchedUpInsideLeftButton: sender)
    }
    
    // MARK: Notifications
    
    func handleKeyboardFrameDidChangeNotification(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            let keyboardFrameEndRectValue: NSValue? = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
            if let keyboardEndRect = keyboardFrameEndRectValue?.CGRectValue() {
                if let rect = superview?.convertRect(keyboardEndRect, fromView: nil) {
                    _keyBoardRect = rect
                }
            }
        }
    }
    
    // MARK: - Protocols
    
    // MARK: UITextViewDelegate
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let string = textView.text as NSString
        let newText = string.stringByReplacingCharactersInRange(range, withString: text)

        setComposerHeightWithText(newText)

        return true
    }
    
    public func textViewDidChangeSelection(textView: UITextView) {
        rightButton.enabled = textView.text.characters.count > 0
        placeholderLabel.hidden = textView.text.characters.count > 0
    }
    
    public func textViewDidChange(textView: UITextView) {
        delegate?.messageKitComposerView(self, textViewDidChange: textView)
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        delegate?.messageKitComposerView(self, textViewDidBeginEditing: textView)
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        delegate?.messageKitComposerView(self, textViewDidEndEditing: textView)
    }
}
