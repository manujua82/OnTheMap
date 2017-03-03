//
//  IndicatorView.swift
//  OnTheMap
//
//  Created by Kevin Bilberry on 3/2/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class IndicatorView: UIActivityIndicatorView {
    
    required init(coder aDecoder: NSCoder){
        fatalError("use init(")
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.hidesWhenStopped = true
    }
    
    func loadingView(_ isloading: Bool) {
        if isloading {
            self.startAnimating()
        } else {
            self.stopAnimating()
            self.hidesWhenStopped = true
            
        }
    }


}
