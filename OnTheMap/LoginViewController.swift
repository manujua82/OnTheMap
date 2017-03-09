//
//  ViewController.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/21/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var client = UdacityClient()
    let indicator = IndicatorView()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextField(emailTextField, nameImage: "envelope")
        configureTextField(passwordTextField, nameImage: "key")
        
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        /*FacebookClient.sharedInstance().loginStart { (result, error) in
            if let error = error{
                print(error)
            }else{
                let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.FacebookMobile)\": { \"\(UdacityClient.JSONBodyKeys.AccessToken)\": \"" + result! + "\"}}"
    
                let _ = UdacityClient.sharedInstance().taskForPOSTMethod(UdacityClient.Constants.AuthorizationURL, jsonBody: jsonBody){
                    (result, error) in
                    if let error = error {
                        let message = error.userInfo.description
                        DispatchQueue.main.async {
                            self.showAlertFaildLogin(message)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.completeLogin()
                        }
                    }
                }
            }
        }*/

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

    // MARK: Show/Hide Keyboa
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
    
    func showAlertFaildLogin(_ message: String){
        let alert = UIAlertController(title: "Loging Faild", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Login
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }

    
    @IBAction func loginPressed(_ sender: Any) {
        indicator.loadingView(true)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            indicator.loadingView(false)
            showAlertFaildLogin("Username or Password Empty.")

        } else {
    
            UdacityClient.sharedInstance().loginWithUdacity(emailTextField.text!, password: passwordTextField.text!, completionHandlerForLogin: { (error, errorMessage) in
                if let errorMessage = errorMessage {
                    DispatchQueue.main.async {
                        self.indicator.loadingView(false)
                        self.showAlertFaildLogin(errorMessage)
                    }
                }else{
                    
                    ParseClient.sharedInstance().getStudentsLocation { (result, error, errorMessage) in
                        if let _ = error{
                            DispatchQueue.main.async {
                                self.indicator.loadingView(false)
                                self.showAlertFaildLogin(errorMessage!)
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.indicator.loadingView(false)
                                self.completeLogin()
                            }
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func singUpPressed(_ sender: Any) {
        let _ = UdacityClient.sharedInstance().udacitySingUpURL(self){ (success, error) in
            if success{
                print("good")
            }else{
                print("error")
            }
        }
    }

    @IBAction func loginFacebookPressed(_ sender: Any) {
        FacebookClient.sharedInstance().loginButtonPressed(self) { (result, error) in
            if let error = error{
                print(error)
            }else{
                print("good")
                print("\(result)")
            }

        }
    }
}


extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

