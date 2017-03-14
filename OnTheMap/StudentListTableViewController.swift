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
    let studentInformation = StudentInformation.shared()
    
    @IBOutlet var studentTableView: UITableView!
    
    var indicadorView: IndicatorUIView = IndicatorUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicadorView = IndicatorUIView(frame: self.view.frame)
        indicadorView.center = self.view.center
        self.view.addSubview(indicadorView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTable()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return students.count
        return self.studentInformation.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        //let studentForRow = self.students[(indexPath as NSIndexPath).row]
        let studentForRow = self.studentInformation.students[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = UIImage(named: "pin")
        cell.textLabel?.text = studentForRow.firstName! + " " + studentForRow.lastName!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let StudentForRow = self.studentInformation.students[(indexPath as NSIndexPath).row]
        var urlString = StudentForRow.mediaURL!
        urlString = urlString.trimmingCharacters(in: .whitespaces)
        if let url = URL(string: urlString){
            if UIApplication.shared.canOpenURL(url){
                let app = UIApplication.shared
                app.open(URL(string: urlString)!, options: [:], completionHandler: nil)
            
            }else{
                UdacityClient.sharedInstance().showAlert(self, "Student link", UdacityClient.ErrorMessage.InvalidLink + " Url: " + urlString)
            }
        }else{
            UdacityClient.sharedInstance().showAlert(self, "Student link", UdacityClient.ErrorMessage.InvalidLink + " Url: " + urlString)
        }
    }
    
    func loadTable(){
        //self.students = self.appDelegate.students
        //if self.students.count > 0 {
        //    self.studentTableView.reloadData()
        //}
        
        if self.studentInformation.students.count > 0{
            self.studentTableView.reloadData()
        }
    }
    
    func refreshTable(){
        indicadorView.loadingView(true)
        ParseClient.sharedInstance().getStudentsLocation { (result, error, errorMessage) in
            if let _ = error{
                DispatchQueue.main.async {
                    self.indicadorView.loadingView(false)
                    UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.TitleInformation, errorMessage!)
                }
            }else{
                //self.appDelegate.students = result!
                self.studentInformation.students = result!
                DispatchQueue.main.async {
                    self.loadTable()
                    self.indicadorView.loadingView(false)
                }
            }
        }
    }
}
