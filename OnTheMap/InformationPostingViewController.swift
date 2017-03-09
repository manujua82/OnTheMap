//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 3/6/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var geocodeTextField: UITextField!
    @IBOutlet weak var labelTop1: UILabel!
    @IBOutlet weak var labelTop2: UILabel!
    @IBOutlet weak var labelTop3: UILabel!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    
    var isOverWritten: Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(geocodeTextField)
        configureTextField(linkTextField)
        
        showLinkPosting(true)
    }
    
    func configureTextField(_ textView: UITextField){
        textView.attributedPlaceholder = NSAttributedString(string: textView.placeholder!,
                                                                    attributes: [NSForegroundColorAttributeName: UIColor.white])
        textView.textAlignment = .center
        textView.delegate = self
        
    }
    
    func showLinkPosting(_ isHidden: Bool){
        mapView.isHidden = isHidden
        linkTextField.isHidden = isHidden
        submitButton.isHidden = isHidden
    }
    
    func showInformationPostin(_ isHidden: Bool){
        labelTop1.isHidden = isHidden
        labelTop2.isHidden = isHidden
        labelTop3.isHidden = isHidden
        geocodeTextField.isHidden = isHidden
        findButton.isHidden = isHidden
    }

    @IBAction func findMapPressed(_ sender: Any) {
        performSearch()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if let mediaUrl = linkTextField.text {
            if verifyUrl(urlString: mediaUrl) {
                
                if !isOverWritten{
                    print("uniqueKey: \(appDelegate.account.key)")
                    print("firstName: \(appDelegate.account.firstName)")
                    print("lastName: \(appDelegate.account.lastName)")
                    print("mapString: " + self.mapString!)
                    
                    
                    //print("mapString: \()")
                    
                    /*
                     "{\"uniqueKey\": \"1234\",
                     \"firstName\": \"John\",
                     \"lastName\": \"Doe\",
                     \"mapString\": \"Mountain View, CA\",
                     \"mediaURL\": \"https://udacity.com\",
                     \"latitude\": 37.386052,
                     \"longitude\": -122.083851}"
                     */
                    
                    
                }

            }else{
                UdacityClient.sharedInstance().showAlert(self, "Information Posting Faild", "Link is not valid")
            }
        }else{
            UdacityClient.sharedInstance().showAlert(self, "Information Posting Faild", "Link is empty")
        }
    }
    
    
    func performSearch() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = geocodeTextField.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                let message = "Error occured in search location: \(error!.localizedDescription)"
                UdacityClient.sharedInstance().showAlert(self, "Information Posting Faild", message)
            } else if response!.mapItems.count == 0 {
                UdacityClient.sharedInstance().showAlert(self, "Information Posting Faild", "No matches found")
            } else {
                
                DispatchQueue.main.async {
                    self.cancelButton.titleLabel?.textColor = UIColor.white
                    self.showInformationPostin(true)
                    self.showLinkPosting(false)
                }
                
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = self.geocodeTextField.text
                self.latitude = response!.boundingRegion.center.latitude
                self.longitude = response!.boundingRegion.center.longitude
                
                let coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                pointAnnotation.coordinate = coordinate
              
                let item = response!.mapItems[0]
                if let title = item.placemark.title{
                    self.mapString = title
                }else{
                    self.mapString = self.geocodeTextField.text
                }

                self.mapView.addAnnotation(pointAnnotation)
                
                let region = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, 50000, 50000)
                self.mapView.setRegion(region, animated: true)
            }
        })
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create URL instance
            if let url = URL(string: urlString) {
                // check if your application can open the URL instance
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
}

extension InformationPostingViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
