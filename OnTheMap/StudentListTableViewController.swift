//
//  StudentListTableViewController.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 3/2/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class StudentListTableViewController: UITableViewController {
    
    var students: [StudentLocation] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

   
    override func viewWillAppear(_ animated: Bool) {
        self.students = self.appDelegate.students
        if self.students.count > 0 {
            self.studentTableView.reloadData()
        }
    }
       
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        let studentForRow = self.students[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = UIImage(named: "pin")
        cell.textLabel?.text = studentForRow.firstName! + " " + studentForRow.lastName!
        
        return cell
    }
}
