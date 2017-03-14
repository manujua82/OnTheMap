//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 3/13/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation

class StudentInformation{
    
    var account: UdacityAccount = UdacityAccount()
    var session: UdacitySession = UdacitySession()
    var students: [StudentLocation] = []
    var user: StudentLocation?
    
    
    //MARK: Singleton Instance
    private static let sharedInstance = StudentInformation()
    
    class func shared() -> StudentInformation  {
        return sharedInstance
    }
    
}
