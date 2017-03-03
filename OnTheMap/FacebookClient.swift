//
//  FacebookClient.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/28/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FBSDKCoreKit


class FacebookClient: NSObject {
    
    func loginStart(completionHandlerForLogin: @escaping (_ authenticationToken:String?, _ error: Error?) -> Void){
        if let accessToken = FBSDKAccessToken.current(){
      
            print("AutentificationToke: \(accessToken.tokenString)")
            
       
            
            completionHandlerForLogin(accessToken.tokenString, nil)
        }else{
            let userInfo = [NSLocalizedDescriptionKey : "User not login: "]
            completionHandlerForLogin(nil,NSError(domain: "loginStart", code: 1, userInfo: userInfo))
        }
    }

    
    func loginButtonPressed(_ hostViewController: UIViewController, completionHandlerForLogin: @escaping (_ result:[String:Any]?, _ error: Error?) -> Void){
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email, .userFriends], viewController: hostViewController) { (loginResult) in
            switch loginResult{
            case .failed(let error):
                completionHandlerForLogin(nil, error)
            case .cancelled:
                let userInfo = [NSLocalizedDescriptionKey : "User cancelled Login"]
                completionHandlerForLogin(nil,NSError(domain: "login Button Press", code: 1, userInfo: userInfo))
            case .success(_, _, _):
                self.fecthProfile(completionHandlerForConvertData: completionHandlerForLogin)
            }
        }
        
        
    }
    
    func fecthProfile(completionHandlerForConvertData: @escaping (_ result:[String:Any]?, _ error: Error?) -> Void){
        let params = ["fields":"email,name, first_name,last_name,picture.width(1000).height(1000),birthday,gender"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            switch requestResult {
            case .failed(let error):
                completionHandlerForConvertData(nil, error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    completionHandlerForConvertData(responseDictionary, nil)
                }
            }
        }
    }

    // MARK: Shared Instance
    class func sharedInstance() -> FacebookClient {
        struct Singleton {
            static var sharedInstance = FacebookClient()
        }
        return Singleton.sharedInstance
    }
}
