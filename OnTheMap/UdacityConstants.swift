//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/23/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

extension UdacityClient{
    
    // MARK: Constants
    struct Constants {
        // MARK: URL
        static let AuthorizationURL = "https://www.udacity.com/api/session"
    }

    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }

}
