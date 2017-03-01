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
    
    func getStudentLocation(_ completionHandlerForGetStudents: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        let parameters = [ParseClient.ParameterKeys.Limit: "100"]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String : AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGetStudents(nil, error)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                    let students = StudentLocation.moviesFromResults(results)
                    completionHandlerForGetStudents(students, nil)
                } else {
                    completionHandlerForGetStudents(nil, NSError(domain: "get students parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
                }
            }
        }
    }

}
