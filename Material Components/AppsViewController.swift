//
//  AppsViewController.swift
//
//  Created by Agus Cahyono on 04/03/21.
//

import UIKit

class AppsViewController: UIViewController {
    
    @IBOutlet weak var textview: ACMaterialTextView!
    @IBOutlet weak var email: ACMateriaTextlField!
    @IBOutlet weak var password: ACMateriaTextlField!
    @IBOutlet weak var phone: ACMateriaTextlField!
    @IBOutlet weak var fullname: ACMateriaTextlField!
    @IBOutlet weak var button: ACMaterialButton!
    
    private var showError: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Material Components"
        
        textview.placeholderFonts = UIFont.boldSystemFont(ofSize: 14)
        email.keyboardType = .emailAddress
        phone.keyboardType = .phonePad
        
        email.fonts = UIFont.boldSystemFont(ofSize: 14)
        email.floatLabelfonts = UIFont.boldSystemFont(ofSize: 14)
        
        phone.fonts = UIFont.boldSystemFont(ofSize: 14)
//        email.floatLabelfonts = UIFont.boldSystemFont(ofSize: 14)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func didTapButtonm(_ sender: ACMaterialButton) {
        sender.showLoader()
        self.showError.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            sender.hideLoader()
        }
        
        textview.showErrorMessage("Please add your current address to complete form", show: self.showError)
        email.showErrorMessage("Please input your Email", show: self.showError)
        password.showErrorMessage("Please input your password", show: self.showError)
        phone.showErrorMessage("Please input your phone", show: self.showError)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
