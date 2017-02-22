//
//  LoginTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/22/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation
import UIKit

class LoginTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
