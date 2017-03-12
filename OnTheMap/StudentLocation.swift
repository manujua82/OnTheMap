//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/28/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation


struct StudentLocation {
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    
    init() {
        self.objectId = ""
        self.uniqueKey = ""
        self.firstName = ""
        self.lastName = ""
        self.mapString = ""
        self.mediaURL = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.createdAt = ""
        self.updatedAt = ""
    }

    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        self.objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String
        
        if let uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String{
            self.uniqueKey = uniqueKey
        }else{
            self.uniqueKey = ""
        }
        
        if let firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String{
            self.firstName = firstName
        }else{
            self.firstName = ""
        }
        
        if let lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String{
            self.lastName = lastName
        }else{
            self.lastName = ""
        }
        
        if let mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String{
            self.mapString = mapString
        }else{
            mapString = ""
        }
        
        if let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String {
            self.mediaURL = mediaURL
        }else{
            self.mediaURL = ""
        }
        
        if let latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double{
            self.latitude = latitude
        }else{
            self.latitude = 0.0
        }
        
        if let longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double{
            self.longitude = longitude
        }else{
            self.longitude = 0.0
        }
        
        if let createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String{
            self.createdAt = createdAt
        }else{
            self.createdAt = ""
        }
        
        if let updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String{
            self.updatedAt = updatedAt
        }else{
            self.updatedAt = ""
        }
    }
    
    static func moviesFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var students = [StudentLocation]()
        
        // iterate through array of dictionaries, each StudentLocation is a dictionary
        for result in results {
            students.append(StudentLocation(dictionary: result))
        }
        
        return students
    }
    
}
