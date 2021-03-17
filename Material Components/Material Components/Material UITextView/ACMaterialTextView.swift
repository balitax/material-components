//
//  ACMaterialTextView.swift
//
//  Created by Agus Cahyono on 10/03/21.
//

import UIKit

public class ACMaterialTextView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var mainContainer: UIView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var textview: BaseTextView!
    
    @IBInspectable public var setActiveBorderColor: UIColor = .lightGray
    @IBInspectable public var setInactiveBorderColor: UIColor = .lightGray
    public var fonts: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.textview.font = fonts
        }
    }
    
    public var placeholderFonts: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.placeholderLabel.font = placeholderFonts
        }
    }
    
    @IBInspectable public var setTopPlaceholder: String?{
        didSet {
            self.placeholderLabel.text = setTopPlaceholder
        }
    }
    
    @IBInspectable public var textPlaceholder: String? {
        didSet {
            self.textview.placeholder = textPlaceholder ?? ""
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        baseStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        baseStyle()
    }
    
    private func baseStyle() {
        self.mainContainer.layer.cornerRadius = 8
        self.textview.delegate = self
        self.textview.sizeToFit()
        
        inactiveStyle()
    }
    
    private func activeStyle() {
        self.mainContainer.layer.borderColor = setActiveBorderColor.cgColor
        self.mainContainer.layer.borderWidth = 2
    }
    
    private func inactiveStyle() {
        self.mainContainer.layer.borderColor = setInactiveBorderColor.cgColor
        self.mainContainer.layer.borderWidth = 1
    }
    
    open func showErrorMessage(_ msg: String, show: Bool) {
        self.viewSlideInFromTopToBottom(view: errorLabel)
        self.errorLabel.isHidden = !show
        if show {
            self.errorLabel.text = msg
        }
    }
    
    private func viewSlideInFromTopToBottom(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        view.layer.add(transition, forKey: kCATransition)
    }
    
    private func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("ACMaterialTextView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
}

extension ACMaterialTextView: UITextViewDelegate {
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.inactiveStyle()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeStyle()
    }
    
}
