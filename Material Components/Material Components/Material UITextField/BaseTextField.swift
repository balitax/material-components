//
//  BaseTextField.swift
//
//  Created by Agus Cahyono on 10/03/21.
//

import Foundation
import UIKit

public class BaseTextField: UITextField {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public var setCornerRadius: CGFloat = 10.0
    public var setActiveBorderColor: UIColor = .orange
    public var setInactiveBorderColor: UIColor = .darkGray
    public var leftSideIcon: UIImage?
    public var leftSideText: String?
    public var leftSideTextColor: UIColor = .darkGray
    
    public var fonts: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.font = fonts
        }
    }
    
    public var floatLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.floatingLabel.font = fonts
        }
    }
    
    private let setLeftIconWidth: CGFloat = 20.0
    
    var imgLeftSideIconView: UIImageView?
    var leftSideLabel: UILabel?
    
    @IBInspectable let setPadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    var floatingLabel: UILabel!
    var placeholderText: String = "" {
        didSet {
            self.floatingLabel.text = placeholderText
            self.placeholder = placeholderText
        }
    }
    
    var isTextFieldActive = false
    
    var floatingLabelColor: UIColor = UIColor.blue {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
        }
    }
    
    var floatingLabelHeight: CGFloat = 30.0
    var leftSideFloatingLabelPadding: CGFloat = 20.0
    var mainBorderOutline: CAShapeLayer!
    var hiddenBorderOtline: CAShapeLayer!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        addLeftSideIcon()
        addBorderLayerOnView()
        initStyle()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        addLeftSideIcon()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        addBorderLayerOnView()
    }
    
    fileprivate func initStyle() {
        self.borderStyle = .none
        floatingLabel = UILabel(frame: .zero)
        floatingLabel.textColor = floatingLabelColor
        floatingLabel.font = self.fonts
        floatingLabel.text = self.placeholder
        floatingLabel.textColor = setActiveBorderColor
        
        self.addSubview(floatingLabel)
        
        placeholderText = placeholder ?? ""
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
        
    }
    
    fileprivate func addBorderLayerOnView() {
        self.layer.sublayers?.forEach { if $0.name == "ac_main_border" || $0.name == "ac_hidden_border"
        {$0.removeFromSuperlayer()} }
        
        let initialPoint = (leftSideFloatingLabelPadding + placeholderText.textWidth(font: self.fonts, text: placeholderText))
        
        let path = UIBezierPath()
        path.move(to:CGPoint(x:initialPoint,y:0))
        path.addLine(to:CGPoint(x: self.frame.size.width - setCornerRadius, y: 0))
        
        
        // Corner Radius Right Top
        path.addQuadCurve(to: CGPoint(x: self.frame.size.width, y: setCornerRadius), controlPoint: CGPoint(x: self.frame.size.width, y: 0))
        path.addLine(to:CGPoint(x: self.frame.size.width, y: self.frame.size.height - setCornerRadius))
        
        
        // Corner Radius Right Bottom
        path.addQuadCurve(to: CGPoint(x: self.frame.size.width-setCornerRadius, y: self.frame.size.height), controlPoint: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        
        path.addLine(to:CGPoint(x: setCornerRadius, y: self.frame.size.height))
        // Corner Radius Left  Bottom
        path.addQuadCurve(to: CGPoint(x: 0, y: self.frame.size.height - setCornerRadius), controlPoint: CGPoint(x: 0, y: self.frame.size.height))
        
        path.addLine(to:CGPoint(x: 0, y: setCornerRadius))
        
        // Corner Radius Left  Top
        path.addQuadCurve(to: CGPoint(x: setCornerRadius, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        
        mainBorderOutline = CAShapeLayer()
        mainBorderOutline.name = "ac_main_border"
        mainBorderOutline.path = path.cgPath
        mainBorderOutline.fillColor = UIColor.clear.cgColor
        mainBorderOutline.lineCap = .round
        self.layer.addSublayer(mainBorderOutline)
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: setCornerRadius, y:0))
        path2.addLine(to: CGPoint(x: initialPoint, y: 0))
        
        hiddenBorderOtline = CAShapeLayer()
        hiddenBorderOtline.name = "ac_hidden_border"
        hiddenBorderOtline.path = path2.cgPath
        hiddenBorderOtline.fillColor = UIColor.clear.cgColor
        hiddenBorderOtline.lineCap = .round
        self.layer.addSublayer(hiddenBorderOtline)
        
        borderStrokeColor()
    }
    
    fileprivate func addLeftSideIcon() {
        
        if let oldView = self.viewWithTag(1992) {
            oldView.removeFromSuperview()
        }
        
        if let leftSideText = self.leftSideText {
            
            leftSideLabel = UILabel(frame: CGRect(x: 8.0, y: 8.0, width: leftSideText.textWidth(font: self.fonts, text: leftSideText), height: self.frame.height / 2))
            leftSideLabel?.text = leftSideText
            leftSideLabel?.font = font
            leftSideLabel?.textColor = self.leftSideTextColor
            let view = UIView(frame: CGRect(x: 0, y: 0, width: leftSideText.textWidth(font: self.fonts, text: leftSideText) + 10, height: 40))
            view.addSubview(leftSideLabel!)
            view.backgroundColor = .clear
            view.tag = 1992
            self.leftViewMode = .always
            self.leftView = view
            
        } else if let tintedImage = leftSideIcon?.withRenderingMode(.alwaysTemplate)  {
            
            imgLeftSideIconView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: setLeftIconWidth, height: self.frame.height / 2))
            imgLeftSideIconView?.image = tintedImage
            imgLeftSideIconView?.contentMode = .scaleAspectFit
            imgLeftSideIconView?.backgroundColor = UIColor.clear
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            view.addSubview(imgLeftSideIconView!)
            view.backgroundColor = .clear
            view.tag = 1992
            self.leftViewMode = .always
            self.leftView = view
            
        } else {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: leftSideFloatingLabelPadding, height: 40))
            view.backgroundColor = .clear
            view.tag = 1992
            self.leftViewMode = .always
            self.leftView = view
            
        }
        
    }
    
    fileprivate func borderStrokeColor() {
        if isTextFieldActive {
            mainBorderOutline.strokeColor = setActiveBorderColor.cgColor
            mainBorderOutline.lineWidth = 2
            hiddenBorderOtline.strokeColor = UIColor.clear.cgColor
            imgLeftSideIconView?.tintColor = setActiveBorderColor
        } else {
            imgLeftSideIconView?.tintColor = setInactiveBorderColor
            if (self.text?.isEmpty)! {
                mainBorderOutline.strokeColor = setInactiveBorderColor.cgColor
                hiddenBorderOtline.strokeColor = setInactiveBorderColor.cgColor
            } else {
                mainBorderOutline.strokeColor = setInactiveBorderColor.cgColor
                hiddenBorderOtline.strokeColor = UIColor.clear.cgColor
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        self.floatingLabel.textColor = setActiveBorderColor
        isTextFieldActive = true
        layoutSubviews()
        if self.text == "" {
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.3, initialSpringVelocity: 0.3, options: [.curveEaseIn, .beginFromCurrentState]) {
                
                self.floatingLabel.frame = CGRect(x: self.setCornerRadius + 5.0, y: -self.floatingLabelHeight/2, width: self.placeholderText.textWidth(font: self.fonts, text: self.placeholderText), height: self.floatingLabelHeight)
                self.placeholder = ""
                
            }
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        self.floatingLabel.textColor = setInactiveBorderColor
        isTextFieldActive = false
        layoutSubviews()
        if self.text == "" {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.3, initialSpringVelocity: 0.3, options: [.curveEaseIn]) {
                self.floatingLabel.frame = CGRect.zero
                self.placeholder = self.placeholderText
            }
        }
    }
    
}

fileprivate extension String {
    
    func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
    
}
