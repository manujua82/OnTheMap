//
//  StudentTabBarController.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 3/2/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class StudentTabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    @IBAction func refreshPressed(_ sender: Any) {
        print("refreshPressed")
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        print("logoutPressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pinPressed(_ sender: Any) {
        print("pinPressed")
    }
    
    func refreshSelectedViewController() {
        
        /*if self.selectedViewController!.isKindOfClass(MapViewController) {
            let controller = self.selectedViewController as! MapViewController
            controller.refreshMap()
        } else if self.selectedViewController!.isKindOfClass(TableViewController){
            let controller = self.selectedViewController as! TableViewController
            controller.refreshTable()
        } else {
            print("trying to refresh an unknown view")
        }*/
    }
}