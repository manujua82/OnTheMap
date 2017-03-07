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
        cancelButton.titleLabel?.textColor = UIColor.white
        showInformationPostin(true)
        showLinkPosting(false)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension InformationPostingViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
