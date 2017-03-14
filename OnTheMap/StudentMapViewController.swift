//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 3/1/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController, MKMapViewDelegate {
    
    let studentInformation = StudentInformation.shared()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var indicadorView: IndicatorUIView = IndicatorUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        indicadorView = IndicatorUIView(frame: self.view.frame)
        indicadorView.center = self.view.center
        self.view.addSubview(indicadorView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMap()
    }
    
    func loadMap(){
       // self.students = self.appDelegate.students
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if self.studentInformation.students.count > 0 {
            var annotations = [MKPointAnnotation]()
            for student in self.studentInformation.students {
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(student.latitude!)
                let long = CLLocationDegrees(student.longitude!)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = student.firstName
                let last = student.lastName
                let mediaURL = student.mediaURL
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title =  first! + " " + last!
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
                
                self.mapView.addAnnotations(annotations)
            }
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!{
                let trimmedString = toOpen.trimmingCharacters(in: .whitespaces)
                if trimmedString != "" {
                    app.open(URL(string: trimmedString)!, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func refreshMap(){
        indicadorView.loadingView(true)
        ParseClient.sharedInstance().getStudentsLocation { (result, error, errorMessage) in
            if let _ = error{
                DispatchQueue.main.async {
                    self.indicadorView.loadingView(false)
                    UdacityClient.sharedInstance().showAlert(self, UdacityClient.ErrorMessage.TitleInformation, errorMessage!)
                }
            }else{
                self.studentInformation.students = result!
                DispatchQueue.main.async {
                    self.loadMap()
                    self.indicadorView.loadingView(false)
                    
                }
            }
        }
    }
}
