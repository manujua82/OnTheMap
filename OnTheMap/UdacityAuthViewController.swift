//
//  UdacityAuthViewController.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/27/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class UdacityAuthViewController: UIViewController {
    
    // MARK: Properties
    var urlRequest: URLRequest? = nil
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil

    // MARK: Outlets
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        navigationItem.title = "Udacity Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    // MARK: Cancel Auth Flow

    func cancelAuth() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UdacityAuthViewController: UIWebViewDelegate

extension UdacityAuthViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("\(webView.request!.url!.absoluteString)")
        if webView.request!.url!.absoluteString == "https://www.udacity.com/" {
            self.dismiss(animated: true) {
                   self.completionHandlerForView!(true, nil)
            }
        }
    }
}

