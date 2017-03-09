//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/23/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//
import UIKit

extension UdacityClient{
    
    // MARK: Constants
    struct Constants {
        // MARK: URL
        static let AuthorizationURL = "https://www.udacity.com/api/session"
        static let GetUserURL = "https://www.udacity.com/api/users/{id}"
        static let SingUpURL = "https://www.udacity.com/account/auth#!/signup"
    }

    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        static let FacebookMobile = "facebook_mobile"
        static let AccessToken = "access_token"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }

    
    //MARK: Error Messages
    struct ErrorMessage {
        static let DataError = "Error Getting Data!"
        static let statMapError = "Failed To Geocode!"
        static let UpdateError = "Failed To Update Location!"
        static let InvalidLink = "Invalid Link!"
        static let MissingLink = "Need To Enter Link!"
        static let CantLogin = "Network Connection Is Offline!"
        static let InvalidEmail = "Invalid Email Or Password!"
        
    }
    
    func showAlert(_ hostViewController: UIViewController, _ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        hostViewController.present(alert, animated: true, completion: nil)
    }



}
