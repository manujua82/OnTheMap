//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kevin Bilberry on 2/21/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 40, height: 20))
        let image = UIImage(named: "envelope");
        imageView.image = image;
        imageView.contentMode = .scaleAspectFit
       
        emailTextField.leftView =  imageView
        emailTextField.leftViewMode = .always
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

