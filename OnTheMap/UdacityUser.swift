//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 3/2/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation

struct UdacityAccount {
    var key: Int
    var registetered: Int
    
    init() {
        key = 0
        registetered = 0
    }
}

struct UdacitySession {
    var id: String?
    var expiration: String?
}
