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
    var indicadorView: IndicatorUIView = IndicatorUIView()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextField(emailTextField, nameImage: "envelope")
        configureTextField(passwordTextField, nameImage: "key")
        
        indicadorView = IndicatorUIView(frame: self.view.frame)
        indicadorView.center = self.view.center
        self.view.addSubview(indicadorView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.indicadorView.loadingView(false)
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
    
    
    // MARK: Login
    private func completeLogin() {
        ParseClient.sharedInstance().getStudentsLocation { (result, error, errorMessage) in
            if let _ = error{
                DispatchQueue.main.async {
                    //self.indicator.loadingView(false)
                    self.indicadorView.loadingView(false)
                    UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.LogigFaild, errorMessage!)
                }
            }else{
                self.appDelegate.students = result!
                DispatchQueue.main.async {
                    //self.indicator.loadingView(false)
                    self.indicadorView.loadingView(false)
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }

    
    @IBAction func loginPressed(_ sender: Any) {
       
        indicadorView.loadingView(true)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            //indicator.loadingView(false)
            indicadorView.loadingView(false)
            UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.LogigFaild, UdacityClient.ErrorMessage.InvalidEmail)

        } else {
    
            UdacityClient.sharedInstance().loginWithUdacity(emailTextField.text!, password: passwordTextField.text!, completionHandlerForLogin: { (account, session, error, errorMessage) in
                if let errorMessage = errorMessage {
                    DispatchQueue.main.async {
                        //self.indicator.loadingView(false)
                        self.indicadorView.loadingView(false)
                        UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.LogigFaild, errorMessage)
                    }
                }else{
                   self.appDelegate.account = account!
                   self.appDelegate.session = session!
                   self.completeLogin()
                   
                }
            })
        }
    }
    
    @IBAction func singUpPressed(_ sender: Any) {
        UdacityClient.sharedInstance().udacitySingUpURL(self){ (success, error) in
            if success{
                print("good")
            }else{
                print("error")
            }
        }
    }

    @IBAction func loginFacebookPressed(_ sender: Any) {
        indicadorView.loadingView(true)
        
        FacebookClient.sharedInstance().loginButtonPressed(self) { (result, error) in
            if let error = error{
                self.indicadorView.loadingView(false)
                print(error)
            }else{
                self.loginFacebookWithUdacity()
            }
        }
    }
    
    func loginFacebookWithUdacity(){
        FacebookClient.sharedInstance().loginStart { (result, error) in
            if let error = error{
                self.indicadorView.loadingView(false)
                UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.LogigFaild, error.localizedDescription)
            }else{
                UdacityClient.sharedInstance().loginWithFacebook(result!, completionHandlerForLogin: { (account, session, error, errorMessage) in
                    
                    if let errorMessage = errorMessage {
                        DispatchQueue.main.async {
                            //self.indicator.loadingView(false)
                            self.indicadorView.loadingView(false)
                            UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.LogigFaild, errorMessage)
                        }
                    }else{
                        self.appDelegate.account = account!
                        self.appDelegate.session = session!
                        self.completeLogin()
                    }
                })
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

