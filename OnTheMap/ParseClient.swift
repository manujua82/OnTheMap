//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/28/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation
import UIKit


class ParseClient: NSObject {
    
    // shared session
    var session = URLSession.shared

    // MARK: GET
    func taskForGETMethod(parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?, _ errorMessage: String?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
      
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURLFromParameters(parametersWithApiKey))
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: ParseClient.ParameterKeys.ApplicationID)
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: ParseClient.ParameterKeys.APIKey)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, _ errormsg: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), errormsg)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", UdacityClient.ErrorMessage.CantLogin)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", UdacityClient.ErrorMessage.CantLogin)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", UdacityClient.ErrorMessage.DataError)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: POST, PUT
    func taskForPOSTPUTMethod(_ url: URL, _ method: String,jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?, _ errorMessage: String?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: ParseClient.ParameterKeys.ApplicationID)
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: ParseClient.ParameterKeys.APIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String, _ errormsg: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), errormsg)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", UdacityClient.ErrorMessage.CantLogin)
                return
            }
            
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", UdacityClient.ErrorMessage.SchemaMismatch)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", UdacityClient.ErrorMessage.DataError)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            //let range = Range(uncheckedBounds: (5, data.count))
            //let newData = data.subdata(in: range) /* subset response data! */
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        
        var parsedResult: [String:AnyObject]! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo), UdacityClient.ErrorMessage.DataError)
        }
        
        completionHandlerForConvertData(parsedResult as AnyObject, nil, nil)
    }


    
    // create a URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents(string: ParseClient.Constants.StudentLocationURL)
        components?.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components?.queryItems!.append(queryItem)
        }
        print("\(components!.url!.absoluteString)")
        return components!.url!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }


    

    
}
