//
//  GeneralNavigationItem.swift
//  OnTheMap
//
//  Created by Kevin Bilberry on 3/2/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class GeneralNavigationItem: UINavigationItem {
    
    override init(title: String) {
        super.init(title: title)
        print("inicializacion")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
