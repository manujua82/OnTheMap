//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Kevin Bilberry on 2/28/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit

class StudentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var students: [StudentLocation] = [StudentLocation]()
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocation { (students, error) in
            if let students = students{
                self.students = students
                DispatchQueue.main.async {
                    self.studentTableView.reloadData()
                }
                
            }
        }
        
        /*TMDBClient.sharedInstance().getFavoriteMovies { (movies, error) in
            if let movies = movies {
                self.movies = movies
                performUIUpdatesOnMain {
                    self.moviesTableView.reloadData()
                }
            } else {
                print(error)
            }
        }*/

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection")
        return students.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        let studentForRow = self.students[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = studentForRow.firstName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)*/
    }
    
    
    @IBAction func showMemeEditor(_ sender: Any) {
       // let storyboard = UIStoryboard (name: "Main", bundle: nil)
       // let editorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
       // self.present(editorVC, animated: true, completion: nil)
        //self.navigationController!.pushViewController(editorVC, animated: true)
        
    }

}
