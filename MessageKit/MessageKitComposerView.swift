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
    func viewControllerForMessageKitComposerView(_ sender: MessageKitComposerView) -> UIViewController?
}

public protocol MessageKitComposerViewDelegate {
    func messageKitComposerView(_ sender: MessageKitComposerView, touchedUpInsideLeftButton button: UIButton)
    func messageKitComposerView(_ sender: MessageKitComposerView, touchedUpInsideRightButton button: UIButton)
    
    func messageKitComposerView(_ sender: MessageKitComposerView, didChangeComposerHeightFrom from: CGFloat, to: CGFloat)
    func messageKitComposerView(_ sender: MessageKitComposerView, didChangeKeyboardRect rect: CGRect)
    
    func messageKitComposerView(_ sender: MessageKitComposerView, textViewDidBeginEditing textView: UITextView)
    func messageKitComposerView(_ sender: MessageKitComposerView, textViewDidEndEditing textView: UITextView)
    
    func messageKitComposerView(_ sender: MessageKitComposerView, textViewDidChange textView: UITextView)
}

open class MessageKitComposerView: UIView, UITextViewDelegate {

    public enum ComposerMode {
        case new
        case edit
    }
    
    open var dataSource: MessageKitComposerViewDataSource!
    open var delegate: MessageKitComposerViewDelegate!

    open var numberOfLines: Int = 5
    open var lineSpacing: CGFloat = 0
    
    open var inputBackgroundViewInsets = UIEdgeInsetsMake(8, 55, 8, 55)
    open var textViewInsets = UIEdgeInsetsMake(8, 8, 8, 8)
    
    open var placeholderLabelOffset = UIOffsetMake(0, 0)
    open var leftButtonCenterOffset = UIOffsetMake(0, 0)
    open var rightButtonCenterOffset = UIOffsetMake(0, 0)
    
    open var mode: ComposerMode = .new {
        didSet {
            switch mode {
            case .new:
                rightButton.setTitle("Send", for: UIControlState())
            case .edit:
                rightButton.setTitle("Update", for: UIControlState())
            }
        }
    }
    
    open var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    
    open var minComposerHeight: CGFloat = 44 {
        didSet {
            _composerHeight = max(_composerHeight, minComposerHeight)
        }
    }
    
    fileprivate var _keyBoardRect: CGRect = CGRect.zero {
        didSet {
            updateFrame()
            
            delegate?.messageKitComposerView(self, didChangeKeyboardRect: _keyBoardRect)
        }
    }
    
    fileprivate var _composerHeight: CGFloat = 0 {
        didSet {
            updateFrame()
        
            if _composerHeight != oldValue {
                delegate?.messageKitComposerView(self, didChangeComposerHeightFrom: oldValue, to: _composerHeight)
            }
        }
    }
    
    open var scrollViewBottomInset: CGFloat {
        if let viewController = dataSource?.viewControllerForMessageKitComposerView(self) {
            let bottomLayoutGuideLength = viewController.bottomLayoutGuide.length
            var bottomHeight = bottomLayoutGuideLength
            if keyBoardRect.minY > 0 {
                bottomHeight = max((viewController.view.bounds.maxY - keyBoardRect.minY), bottomLayoutGuideLength)
            }
            
            return composerHeight + bottomHeight
        }
        return 0
    }
    
    open var composerHeight: CGFloat {
        return _composerHeight
    }
    
    open var keyBoardRect: CGRect {
        return _keyBoardRect
    }
    
    open lazy var leftButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("Upload", for: .normal)
        _button.setTitleColor(.black, for: .normal)
        _button.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .disabled)
        _button.titleLabel?.font = .systemFont(ofSize: 17)
        
        _button.addTarget(self, action: #selector(MessageKitComposerView.leftButtonTouchedUpInside(_:)), for: .touchUpInside)
        
        return _button
    }()

    open lazy var rightButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("Send", for: .normal)
        _button.setTitleColor(.black, for: .normal)
        _button.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .disabled)
        _button.titleLabel?.font = .systemFont(ofSize: 17)
        _button.isEnabled = false
        
        _button.addTarget(self, action: #selector(MessageKitComposerView.rightButtonTouchedUpInside(_:)), for: .touchUpInside)
        
        return _button
    }()
    
    open lazy var inputBackgroundView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor(white: 0, alpha: 0.05)
        _view.layer.cornerRadius = 5
        
        return _view
    }()
    
    lazy var messageKitComposerInputAccessoryView: MessageKitComposerInputAccessoryView = {
        let _view = MessageKitComposerInputAccessoryView()
        _view.isUserInteractionEnabled = false
        
        return _view
    }()
    
    open lazy var textView: UITextView = {
        let _textView = UITextView()
        _textView.backgroundColor = UIColor.clear
        _textView.inputAccessoryView = self.messageKitComposerInputAccessoryView
        _textView.delegate = self
        _textView.scrollsToTop = false
        
        _textView.contentInset = UIEdgeInsets.zero
        _textView.textContainerInset = UIEdgeInsets.zero
        _textView.textContainer.lineFragmentPadding = 0
        
        return _textView
        }()
    
    open lazy var placeholderLabel: UILabel = {
        let _label = UILabel()
        _label.textColor = UIColor.lightGray
        _label.backgroundColor = UIColor.clear
        
        return _label
    }()
    
    open lazy var topBorderView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        return _view
    }()
    
    open lazy var topOuterContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor.white
        
        return _view
    }()
    
    
    open lazy var topInnerContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor.white
        
        return _view
    }()

    open lazy var bottomInnerContentView: UIView = {
        let _view = UIView(forAutoLayout: ())
        _view.backgroundColor = UIColor.white
        
        return _view
    }()
    
    // MARK: - Initializers
    
    required public convenience init(dataSource: MessageKitComposerViewDataSource, delegate: MessageKitComposerViewDelegate) {
        self.init(frame: CGRect.zero)
        
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(topOuterContentView)
        addSubview(topInnerContentView)
        addSubview(topBorderView)
        
        addSubview(leftButton)
        addSubview(inputBackgroundView)
        addSubview(rightButton)
        
        addSubview(bottomInnerContentView)
        
        inputBackgroundView.addSubview(placeholderLabel)
        inputBackgroundView.addSubview(textView)
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(MessageKitComposerView.handleKeyboardFrameDidChangeNotification(_:)), name: NSNotification.Name(rawValue: KeyboardFrameDidChangeNotification), object: nil)
        
        setupConstraints()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Super
    
    open override var intrinsicContentSize : CGSize {
        let width = super.intrinsicContentSize.width
        return CGSize(width: width, height: composerHeight)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        // self
        updateFrame()
        
        // inputBackgroundView
        let inputBackgroundViewSizeHeight = _composerHeight - inputBackgroundViewInsets.top - inputBackgroundViewInsets.bottom
        let inputBackgroundViewSizeWidth = bounds.width - inputBackgroundViewInsets.left - inputBackgroundViewInsets.right
        let inputBackgroundViewOriginX = inputBackgroundViewInsets.left
        let inputBackgroundViewOriginY = bounds.height - inputBackgroundViewInsets.bottom - inputBackgroundViewSizeHeight - bottomInnerContentView.bounds.height
        
        inputBackgroundView.frame = CGRect(x: inputBackgroundViewOriginX, y: inputBackgroundViewOriginY, width: inputBackgroundViewSizeWidth, height: inputBackgroundViewSizeHeight)
        
        // textView
        let textViewSizeHeight = inputBackgroundViewSizeHeight - textViewInsets.top - textViewInsets.bottom
        let textViewSizeWidth = inputBackgroundViewSizeWidth - textViewInsets.left - textViewInsets.right
        let textViewOriginX = textViewInsets.left
        let textViewOriginY = textViewInsets.top
        
        textView.frame = CGRect(x: textViewOriginX, y: textViewOriginY, width: textViewSizeWidth, height: textViewSizeHeight)
        
        // placeholderLabel
        placeholderLabel.font = textView.font
        placeholderLabel.sizeToFit()
        
        let placeholderLabelSizeHeight = placeholderLabel.bounds.height
        let placeholderLabelSizeWidth = textViewSizeWidth
        let placeholderLabelOriginX = textViewOriginX + placeholderLabelOffset.horizontal
        let placeholderLabelOriginY = textViewOriginY + 4 + placeholderLabelOffset.vertical
        
        placeholderLabel.frame = CGRect(x: placeholderLabelOriginX, y: placeholderLabelOriginY, width: placeholderLabelSizeWidth, height: placeholderLabelSizeHeight)
        
        // leftButton
        leftButton.sizeToFit()
        let leftButtonCenterX = (inputBackgroundViewInsets.left / 2) + leftButtonCenterOffset.horizontal
        let leftButtonCenterY = (bounds.height - (minComposerHeight / 2)) + leftButtonCenterOffset.vertical - bottomInnerContentView.bounds.height
        
        leftButton.center = CGPoint(x: leftButtonCenterX, y: leftButtonCenterY)
        
        // rightButton
        rightButton.sizeToFit()
        let rightButtonCenterX = (bounds.width - inputBackgroundViewInsets.right / 2) + rightButtonCenterOffset.horizontal
        let rightButtonCenterY = (bounds.height - (minComposerHeight / 2)) + rightButtonCenterOffset.vertical - bottomInnerContentView.bounds.height
        let width = rightButton.bounds.width
        
        rightButton.frame.size.width = width * 1.475
        rightButton.center = CGPoint(x: rightButtonCenterX, y: rightButtonCenterY)
        
        // contentView
    }
    
    open override var isFirstResponder : Bool {
        return textView.isFirstResponder
    }
    
    open override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setComposerHeightWithText(nil)
        
        layoutSubviews()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        NSLog("touchesBegan")
        
        let _ = becomeFirstResponder()
    }
    
    // MARK: - Methods
    
    func setupConstraints() {
        
        // topOuterContentView
        topOuterContentView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
        
        // topBorderView
        topBorderView.autoPinEdge(.top, to: .bottom, of: topOuterContentView)
        topBorderView.autoPinEdge(.left, to: .left, of: self)
        topBorderView.autoPinEdge(.right, to: .right, of: self)
        topBorderView.autoSetDimension(.height, toSize: 1.0 / UIScreen.main.scale)
        
        // topInnerContentView
        topInnerContentView.autoPinEdge(.top, to: .bottom, of: topBorderView)
        topInnerContentView.autoPinEdge(.left, to: .left, of: self)
        topInnerContentView.autoPinEdge(.right, to: .right, of: self)
        
        // bottomInnerContentView
//        bottomInnerContentView.autoPinEdge(.Top, toEdge: .Bottom, ofView: inputBackgroundView)
        bottomInnerContentView.autoPinEdge(.bottom, to: .bottom, of: self)
        bottomInnerContentView.autoPinEdge(.left, to: .left, of: self)
        bottomInnerContentView.autoPinEdge(.right, to: .right, of: self)
    }
    
    func updateFrame() {
        if let superview = superview {
            let viewController = dataSource.viewControllerForMessageKitComposerView(self)
            let bottomLayoutGuideLength = viewController?.bottomLayoutGuide.length ?? 0
            let keyBoardMinY = (_keyBoardRect.minY > 0) ? _keyBoardRect.minY : superview.bounds.height
            
            let sizeHeight: CGFloat = _composerHeight + topInnerContentView.bounds.height + topBorderView.bounds.height + topOuterContentView.bounds.height + bottomInnerContentView.bounds.height
            let sizeWidth: CGFloat = superview.bounds.width
            let originX: CGFloat = 0
            let originMaxY = superview.bounds.height - sizeHeight - bottomLayoutGuideLength
            let originY: CGFloat = min(keyBoardMinY - sizeHeight, originMaxY)
            
            frame = CGRect(x: originX, y: originY, width: sizeWidth, height: sizeHeight)
        }
    }
    
    open func dismiss() {
        _keyBoardRect = CGRect.zero
        let _ = resignFirstResponder()
    }
    
    open func reset() {
        textView.text = nil
        setComposerHeightWithText(nil)
        
        delegate?.messageKitComposerView(self, textViewDidChange: textView)
    }
    
    func setComposerHeightWithText(_ text: String?) {
        let width = textView.bounds.width
        var textHeight = textView.font?.lineHeight ?? 0
        var maxTextHeight = textHeight
        
        if let text = text, let font = textView.font {
            let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            
            let mutableParagraphStyle = NSMutableParagraphStyle()
            mutableParagraphStyle.alignment = textView.textAlignment
            mutableParagraphStyle.lineSpacing = lineSpacing
            
            let attributes: [String : AnyObject] = [NSFontAttributeName: font, NSParagraphStyleAttributeName: mutableParagraphStyle]
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            
            textHeight = ceil(attributedString.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil).height)
            textHeight = max(textHeight, font.lineHeight)
            
            maxTextHeight = font.lineHeight * CGFloat(numberOfLines)
            
            textView.isScrollEnabled = (textHeight > maxTextHeight)
        }

        let height = inputBackgroundViewInsets.top + textViewInsets.top + min(textHeight, maxTextHeight) + textViewInsets.bottom + inputBackgroundViewInsets.bottom + lineSpacing
        let newComposerheight = max(height, minComposerHeight)
        
        if _composerHeight != newComposerheight {
            _composerHeight = newComposerheight
        }
    }
    
    // MARK: Actions
    
    func rightButtonTouchedUpInside(_ sender: UIButton) {
        delegate?.messageKitComposerView(self, touchedUpInsideRightButton: sender)
    }

    func leftButtonTouchedUpInside(_ sender: UIButton) {
        delegate?.messageKitComposerView(self, touchedUpInsideLeftButton: sender)
    }
    
    // MARK: Notifications
    
    func handleKeyboardFrameDidChangeNotification(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            let keyboardFrameEndRectValue: NSValue? = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
            if let keyboardEndRect = keyboardFrameEndRectValue?.cgRectValue {
                if let rect = superview?.convert(keyboardEndRect, from: nil) {
                    _keyBoardRect = rect
                }
            }
        }
    }
    
    // MARK: - Protocols
    
    // MARK: UITextViewDelegate
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let string = textView.text as NSString
        let newText = string.replacingCharacters(in: range, with: text)
        
        setComposerHeightWithText(newText)
        
        return true
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        setComposerHeightWithText(textView.text)
        
        rightButton.isEnabled = textView.text.characters.count > 0
        placeholderLabel.isHidden = textView.text.characters.count > 0
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        delegate?.messageKitComposerView(self, textViewDidChange: textView)
    }
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.messageKitComposerView(self, textViewDidBeginEditing: textView)
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.messageKitComposerView(self, textViewDidEndEditing: textView)
    }
}
