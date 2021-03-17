//
//  ACMateriaTextlField.swift
//
//  Created by Agus Cahyono on 10/03/21.
//

import Foundation
import UIKit

public class ACMateriaTextlField: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var textfield: BaseTextField!
    
    @IBInspectable public var setCornerRadius: CGFloat = 10.0 {
        didSet {
            self.textfield.setCornerRadius = setCornerRadius
        }
    }
    
    @IBInspectable public var setActiveBorderColor: UIColor = .orange {
        didSet {
            self.textfield.setActiveBorderColor = setActiveBorderColor
        }
    }
    
    @IBInspectable public var setInactiveBorderColor: UIColor = .darkGray {
        didSet {
            self.textfield.setInactiveBorderColor = setInactiveBorderColor
        }
    }
    
    @IBInspectable public var placeholderText: String = "" {
        didSet {
            self.textfield.placeholderText = placeholderText
        }
    }
    
    @IBInspectable public var leftSideIcon: UIImage? {
        didSet {
            self.textfield.leftSideIcon = leftSideIcon
        }
    }
    
    @IBInspectable public var leftSideText: String? {
        didSet {
            self.textfield.leftSideText = leftSideText
        }
    }
    
    @IBInspectable public var leftSideTextColor: UIColor = .darkGray {
        didSet {
            self.textfield.leftSideLabel?.textColor = leftSideTextColor
        }
    }
    
    @IBInspectable public var isSecureText: Bool = false {
        didSet {
            self.textfield.isSecureTextEntry = isSecureText
        }
    }
    
    public var keyboardType: UIKeyboardType = .asciiCapable {
        didSet {
            self.textfield.keyboardType = keyboardType
        }
    }
    
    public var fonts: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.textfield.fonts = fonts
        }
    }
    
    public var floatLabelfonts: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.textfield.floatLabelFont = floatLabelfonts
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        baseComponent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        baseComponent()
    }
    
    private func baseComponent() {
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
        let viewFromXib = Bundle.main.loadNibNamed("ACMateriaTextlField", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
}
