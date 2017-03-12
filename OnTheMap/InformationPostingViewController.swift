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
    
    var indicadorView: IndicatorUIView = IndicatorUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(geocodeTextField)
        configureTextField(linkTextField)
        
        indicadorView = IndicatorUIView(frame: self.view.frame)
        indicadorView.center = self.view.center
        self.view.addSubview(indicadorView)
        
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
                
                indicadorView.loadingView(true)
                
                var user: StudentLocation = StudentLocation()
                user.objectId = appDelegate.user?.objectId
                user.uniqueKey =  appDelegate.account.key!
                user.firstName = appDelegate.account.firstName!
                user.lastName = appDelegate.account.lastName!
                user.mapString = self.mapString!
                user.mediaURL = self.linkTextField.text!
                user.latitude =  self.latitude!
                user.longitude = self.longitude!
                
                
                ParseClient.sharedInstance().createStudentLocation(user: user, isOverWritten: isOverWritten, completionHandlerForCreateStudentLocation: { (_, _, errorMessage) in
                    
                    if let errorMessage = errorMessage{
                        DispatchQueue.main.async {
                            self.indicadorView.loadingView(false)
                            UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.TitleInformation, errorMessage)
                        }
                    }else{
                        ParseClient.sharedInstance().getStudentsLocation { (result, error, errorMessage) in
                            if let _ = error{
                                DispatchQueue.main.async {
                                    self.indicadorView.loadingView(false)
                                    UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.TitleInformation, errorMessage!)
                                }
                            }else{
                                self.appDelegate.students = result!
                                DispatchQueue.main.async {
                                    self.indicadorView.loadingView(false)
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                })
            }else{
                UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.TitleInformation, UdacityClient.ErrorMessage.InvalidLink)
            }
        }else{
            UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.TitleInformation, UdacityClient.ErrorMessage.InvalidLink)
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
                UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.TitleInformation, message)
            } else if response!.mapItems.count == 0 {
                UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.TitleInformation, UdacityClient.ErrorMessage.NoMatches)
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
