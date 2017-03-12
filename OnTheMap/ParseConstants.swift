//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Juan Salcedo on 2/28/17.
//  Copyright © 2017 Juan Salcedo. All rights reserved.
//

import Foundation

extension ParseClient{
    
    struct Constants {
        
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let StudentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let StudentLocationUpdateURL = "https://parse.udacity.com/parse/classes/StudentLocation/{id}"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let ApplicationID = "X-Parse-Application-Id"
        static let APIKey = "X-Parse-REST-API-Key"
        
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Watchlist = "watchlist"
    }
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
        static let StudentResults = "results"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    

}
