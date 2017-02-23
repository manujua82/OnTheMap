//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/23/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation


class UdacityClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    var sessionID : String? = nil
}
