//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/28/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {

    
    func getStudentsLocation(_ completionHandlerForGetStudents: @escaping (_ result: Bool, _ error: NSError?, _ errorMessage: String?) -> Void) {
        
        let parameters = [ParseClient.ParameterKeys.Limit: "100",
                          ParseClient.ParameterKeys.Order: "updatedAt"
                          ]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String : AnyObject]) { (results, error, errorMessage) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGetStudents(false, error, errorMessage)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                    let students = StudentLocation.moviesFromResults(results)
                    self.appDelegate.students = students
                    completionHandlerForGetStudents(true, nil, nil)
                } else {
                    completionHandlerForGetStudents(false, NSError(domain: "get students parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]),  "Could not parse getStudentLocation")
                }
            }
        }
    }
    
    func getStudentLocation(_ completionHandlerForGetStudent: @escaping (_ result: Bool, _ error: NSError?, _ errorMessage: String?) -> Void) {
        
        
        if let uniqueKey = appDelegate.account.key {
            let parameterValue = "{ \"uniqueKey\": \"\(uniqueKey)\"}"
            let parameters = [ParseClient.ParameterKeys.Where: parameterValue]
        
            /* 2. Make the request */
            let _ = taskForGETMethod(parameters: parameters as [String : AnyObject]) { (results, error, errorMessage) in
            
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    print(error)
                    completionHandlerForGetStudent(false, error, errorMessage)
                } else {
                    if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                        if results.count > 0 {
                            let user = StudentLocation(dictionary: results[0])
                            self.appDelegate.user = user
                            completionHandlerForGetStudent(true, nil, nil)
                        }
                    }
                    
                    completionHandlerForGetStudent(false, NSError(domain: "get students parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]),"Could not parse getStudentLocation")
                    
                }
            }
        }
    }
    
    func createStudentLocation(_ completionHandlerForCreateStudent: @escaping (_ result: Bool, _ error: NSError?, _ errorMessage: String?) -> Void) {
        
        
        
        /*
         
        "{\"uniqueKey\": \"1234\",
           \"firstName\": \"John\",
           \"lastName\": \"Doe\",
            \"mapString\": \"Mountain View, CA\",
          \"mediaURL\": \"https://udacity.com\",
          \"latitude\": 37.386052,
           \"longitude\": -122.083851}"
         */

    
    }
    
    
}
