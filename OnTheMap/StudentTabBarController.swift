//
//  StudentTabBarController.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 3/2/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class StudentTabBarController: UITabBarController {

    let studentInformation = StudentInformation.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        if self.selectedIndex == 0 {
            let controller = self.selectedViewController as! StudentMapViewController
            controller.refreshMap()
        }else if self.selectedIndex == 1 {
            let controller = self.selectedViewController as! StudentListTableViewController
            controller.refreshTable()
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        FacebookClient.sharedInstance().logOutButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pinPressed(_ sender: Any) {
        ParseClient.sharedInstance().getStudentLocation(self.studentInformation.account.key!) { (result, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    print("\(error)")
                    self.openInformationVIew(isOverWritten: false)
                }
            }else{
                let message = "You have already posted a Student Location, Would you like overwrite your current location?"
                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                let overwrite = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    self.studentInformation.user = result!
                    DispatchQueue.main.async {
                        self.openInformationVIew(isOverWritten: true)
                    }
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                
                alert.addAction(overwrite)
                alert.addAction(cancel)
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func openInformationVIew(isOverWritten: Bool){
        let controller = storyboard!.instantiateViewController(withIdentifier: "InformationPostingViewController") as! InformationPostingViewController
        controller.isOverWritten =  isOverWritten
        present(controller, animated: true, completion: nil)
    }
    
}
