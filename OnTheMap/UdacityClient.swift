//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/23/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation
import UIKit


class UdacityClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    var sessionID : String? = nil
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: POST
    func taskForPOSTMethod(_ method: String,jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?, _ errorMessage: String?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: method)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String, _ errormsg: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), errormsg)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", ErrorMessage.CantLogin)
                return
            }
            
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", ErrorMessage.InvalidEmail)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", ErrorMessage.DataError)
                return
            }

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }
    
    func udacitySingUpURL(_ hostViewController: UIViewController, completionHandlerForSingUp: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let singUpURL = URL(string: UdacityClient.Constants.SingUpURL)
        let request = URLRequest(url: singUpURL!)
        let webAuthViewController = hostViewController.storyboard?.instantiateViewController(withIdentifier: "UdacityAuthViewController") as! UdacityAuthViewController
        
        webAuthViewController.urlRequest = request
        webAuthViewController.completionHandlerForView = completionHandlerForSingUp
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        DispatchQueue.main.async {
            hostViewController.present(webAuthViewController, animated: true, completion: nil)
        }

        
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        
        var parsedResult: [String:AnyObject]! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo), ErrorMessage.DataError)
        }
        
        completionHandlerForConvertData(parsedResult as AnyObject, nil, nil)
    }
    
    
    //Login
    func loginWithUdacity(_ username: String, password: String, completionHandlerForLogin: @escaping ( _ error: NSError?, _ errorMessage: String?) -> Void) {
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": { \"\(JSONBodyKeys.Username)\": \"\(username)\", \"\(JSONBodyKeys.Password)\":\"\(password)\"}}"
        
        let _ = taskForPOSTMethod(UdacityClient.Constants.AuthorizationURL, jsonBody: jsonBody){
            (result, error, errorMessage) in
            
            if let errorMessage = errorMessage {
                completionHandlerForLogin(error, errorMessage)
            }else{
                
                
                
                func sendError(error: String, errormsg: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForLogin(NSError(domain: "loginWithUdacity", code: 1, userInfo: userInfo), errormsg)
                }
            
                guard let dictionary = result as? [String: Any] else {
                    sendError(error: "Cannot Parse Dictionary", errormsg: ErrorMessage.CantLogin)
                    return
                }
                    
                guard let account = dictionary["account"] as? [String: Any] else{
                    sendError(error: "Cannot Find Key 'Account' In \(dictionary)", errormsg: ErrorMessage.CantLogin)
                    return
                }
                
                guard let session = dictionary["session"] as? [String: Any] else{
                    sendError(error: "Cannot Find Key 'session' In \(dictionary)", errormsg: ErrorMessage.CantLogin)
                    return
                }
                
                //Utilize Data
                guard let key = account["key"] as? String else{
                    sendError(error: "Cannot Find Key 'key' In \(account)", errormsg: ErrorMessage.CantLogin)
                    return
                }
                
                guard let registered = account["registered"] as? Bool else{
                    sendError(error: "Cannot Find Key 'registered' In \(account)", errormsg: ErrorMessage.CantLogin)
                    return
                }
                
                guard let id = session["id"] as? String else{
                    sendError(error: "Cannot Find Key 'id' In \(session)", errormsg: ErrorMessage.CantLogin)
                    return
                }
                
                guard let expiration = session["expiration"] as? String else{
                    sendError(error: "Cannot Find Key 'expiration' In \(session)", errormsg: ErrorMessage.CantLogin)
                    return
                }
                
                self.appDelegate.account.key = key
                self.appDelegate.account.registetered = registered
                
                self.appDelegate.session.id = id
                self.appDelegate.session.expiration = expiration
                
                completionHandlerForLogin(nil,nil)
            }
        }

    }

    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }


}
