//
//  BaseTextView.swift
//
//  Created by Agus Cahyono on 10/03/21.
//

import Foundation
import UIKit

open class BaseTextView: UITextView {
    
    public enum PlaceholderVerticalAlignment : Int {
        case none
        case center
        case bottom
    }
    
    @IBInspectable public var placeholder : String = "Enter your placeholder" {
        didSet { self.placeholderTextView.text = self.placeholder }
    }
    
    @IBInspectable public var placeholderColor : UIColor = .gray {
        didSet { self.placeholderTextView.textColor = self.placeholderColor }
    }
    
    @IBInspectable public var shouldHidePlaceholderOnEditing : Bool = false
    
    public var attributedPlaceholder : NSAttributedString? {
        didSet {
            if self.attributedPlaceholder != nil {
                self.placeholderTextView.text = nil
                self.placeholderTextView.attributedText = self.attributedPlaceholder
            }
        }
    }
    
    public var placeholderVerticalAlignment : PlaceholderVerticalAlignment = .none {
        didSet { self.recalculatePlaceholderInset() }
    }
    
    public override var text: String! {
        didSet { self.placeholderTextView.isHidden = !self.text.isEmpty }
    }
    
    public override var textContainerInset: UIEdgeInsets {
        didSet { self.placeholderTextView.textContainerInset = self.textContainerInset }
    }
    
    public override var font: UIFont? {
        didSet { self.placeholderTextView.font = self.font }
    }
    
    lazy private var placeholderTextView : UITextView = {
        let textView = UITextView()
        
        textView.text = self.placeholder
        textView.textColor = self.placeholderColor
        
        textView.font = self.font
        
        textView.textAlignment = self.textAlignment
        textView.textContainerInset = self.textContainerInset
        
        textView.frame = self.bounds
        
        textView.backgroundColor = .clear
        
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.isHidden = !self.text.isEmpty
        
        return textView
    }()
    
    private var heightConstraint : NSLayoutConstraint?
    private var originHeightConstant : CGFloat?
    
    @objc private func textDidBeginEditing(_ notification : Notification) -> () {
        if self.text.isEmpty {
            if self.shouldHidePlaceholderOnEditing {
                self.placeholderTextView.isHidden = true
            }
        }
        
        self.updateContentSize()
    }
    
    @objc private func textDidChange(_ notification : Notification) -> () {
        if self.shouldHidePlaceholderOnEditing {
            if self.text.isEmpty {
                self.placeholderTextView.isHidden = true
            }
        } else {
            self.placeholderTextView.isHidden = !self.text.isEmpty
        }
    }
    
    @objc private func textDidEndEditing(_ notification : Notification) -> () {
        if self.text.isEmpty {
            if self.shouldHidePlaceholderOnEditing {
                self.placeholderTextView.isHidden = false
            }
        }
        
        self.updateContentSize()
    }
    
    private func updatePlaceholder() -> () {
        self.placeholderTextView.text = self.placeholder
        self.placeholderTextView.textColor = self.placeholderColor
        
        self.placeholderTextView.font = self.font
        self.placeholderTextView.textAlignment = self.textAlignment
        
        self.placeholderTextView.frame = self.bounds
    }
    
    private func updateContentSize() -> () {
        if self.text.isEmpty {
            if let constraint = self.heightConstraint, let originHeight = self.originHeightConstant {
                let placeholderContentHeight = self.placeholderTextView.contentSize.height
                
                if self.shouldHidePlaceholderOnEditing && self.isFirstResponder {
                    if originHeight < placeholderContentHeight {
                        constraint.constant = originHeight
                    }
                } else {
                    if constraint.constant < placeholderContentHeight {
                        constraint.constant = placeholderContentHeight
                    }
                }
            }
        }
        
        self.placeholderTextView.frame = self.bounds
    }
    
    private func applyCenterAlignment() -> () {
        let rootTextViewHeight = self.bounds.size.height
        let placeholderTextViewHeight = self.placeholderTextView.contentSize.height
        let placeholderTextViewZoom = self.placeholderTextView.zoomScale
        
        var inset = (rootTextViewHeight - (placeholderTextViewHeight * placeholderTextViewZoom)) / 2
        inset = inset < 0.0 ? 0.0 : inset
        
        self.placeholderTextView.contentInset.top = inset
        self.shouldHidePlaceholderOnEditing = true
    }
    
    private func applyBottomAlignment() -> () {
        let rootTextViewHeight = self.bounds.size.height
        let placeholderTextViewHeight = self.placeholderTextView.contentSize.height
        let placeholderTextViewZoom = self.placeholderTextView.zoomScale
        
        var inset = (rootTextViewHeight - (placeholderTextViewHeight * placeholderTextViewZoom))
        inset = inset < 0.0 ? 0.0 : inset
        
        self.placeholderTextView.contentInset.top = inset
        self.shouldHidePlaceholderOnEditing = true
    }
    
    private func recalculatePlaceholderInset() -> () {
        switch placeholderVerticalAlignment {
        case .none: self.placeholderTextView.textContainerInset = self.textContainerInset
        case .center: self.applyCenterAlignment()
        case .bottom: self.applyBottomAlignment()
        }
    }
    
    private func signForNotifications() -> () {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing(_:)), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    private func initialConfiguration() -> () {
        self.insertSubview(self.placeholderTextView, at: 0)
        self.signForNotifications()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.updatePlaceholder()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Getting an initial value of the height constraint's constant
        if self.heightConstraint == nil {
            for constraint in self.constraints {
                if constraint.firstAttribute == .height {
                    self.heightConstraint = constraint
                    self.originHeightConstant = constraint.constant
                    break
                }
            }
        }
        
        self.updateContentSize()
        self.recalculatePlaceholderInset()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        // To avoid Interface Builder render and auto-layout issues
        super.init(frame: frame, textContainer: textContainer)
        self.initialConfiguration()
    }
    
    required public init?(coder : NSCoder) {
        super.init(coder: coder)
        self.initialConfiguration()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
}
