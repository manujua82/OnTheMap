//
//  ViewController.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/21/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureTextField(emailTextField, nameImage: "envelope")
        configureTextField(passwordTextField, nameImage: "key")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    // MARK: - LoginViewController (Configure UI)

    func configureTextField(_ textField: UITextField, nameImage: String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 40, height: 20))
        let image = UIImage(named: nameImage);
        imageView.image = image;
        imageView.contentMode = .scaleAspectFit
        
        textField.leftView =  imageView
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!,
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.delegate = self
    }

    // MARK: Show/Hide Keyboard
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        if (UIDevice.current.orientation != UIDeviceOrientation.landscapeLeft) &&
            (UIDevice.current.orientation != UIDeviceOrientation.landscapeRight) {
           
            if(self.view.frame.origin.y == 0.0) {
                self.view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
        logoImageView.isHidden = true
    }
    
    func keyboardWillHide(_ notification: NSNotification){
        self.view.frame.origin.y = 0
        logoImageView.isHidden = false
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

}

