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

    
    func getStudentsLocation(_ completionHandlerForGetStudents: @escaping (_ result: [StudentLocation]?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        
        let parameters = [ParseClient.ParameterKeys.Limit: "100",
                          ParseClient.ParameterKeys.Order: "-updatedAt"
                          ]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String : AnyObject]) { (results, error, errorMessage) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGetStudents(nil, error, errorMessage)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                    let students = StudentLocation.moviesFromResults(results)
                    completionHandlerForGetStudents(students, nil, nil)
                } else {
                    completionHandlerForGetStudents(nil, NSError(domain: "get students parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]),  "Could not parse getStudentLocation")
                }
            }
        }
    }
    
    func getStudentLocation(_ uniqueKey: String, _ completionHandlerForGetStudent: @escaping (_ result: StudentLocation?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        
        let parameterValue = "{ \"uniqueKey\": \"\(uniqueKey)\"}"
        let parameters = [ParseClient.ParameterKeys.Where: parameterValue]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String : AnyObject]) { (results, error, errorMessage) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForGetStudent(nil, error, errorMessage)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                    if results.count > 0 {
                        let user = StudentLocation(dictionary: results[0])
                        completionHandlerForGetStudent(user, nil, nil)
                        return
                    }
                }
                completionHandlerForGetStudent(nil, NSError(domain: "get students parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]),"Could not parse getStudentLocation")
            }
        }
    }
    
    func createStudentLocation(user: StudentLocation,isOverWritten: Bool ,completionHandlerForCreateStudentLocation:  @escaping (_ result: AnyObject?, _ error: NSError?, _ errorMessage: String?) -> Void){
        
        var jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"" + user.uniqueKey! + "\", "
        jsonBody += "\"\(ParseClient.JSONBodyKeys.FirstName)\": \"" + user.firstName! + "\", "
        jsonBody += "\"\(ParseClient.JSONBodyKeys.LastName)\": \"" + user.lastName! + "\", "
        jsonBody += "\"\(ParseClient.JSONBodyKeys.MapString)\": \"" + user.mapString! + "\", "
        jsonBody += "\"\(ParseClient.JSONBodyKeys.MediaURL)\": \"" + user.mediaURL! + "\", "
        jsonBody += "\"\(ParseClient.JSONBodyKeys.Latitude)\": \(user.latitude!), "
        jsonBody += "\"\(ParseClient.JSONBodyKeys.Longitude)\": \(user.longitude!) }"
        
        let method: String
        var urlString: String
        if !isOverWritten {
            method = "POST"
            urlString = ParseClient.Constants.StudentLocationURL
        }else{
            method = "PUT"
            urlString = ParseClient.Constants.StudentLocationUpdateURL
            urlString = substituteKeyInMethod(urlString, key: URLKeys.UserID, value: user.objectId!)!
        }
        
        let url = URL(string: urlString)!
        let _ = taskForPOSTPUTMethod(url, method, jsonBody: jsonBody) { (result, error, erroMessage) in
            if let erroMessage = erroMessage {
                completionHandlerForCreateStudentLocation(nil, error, erroMessage)
            }else{
                completionHandlerForCreateStudentLocation(result,nil,nil)
            }
        }
    }
    
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
}
