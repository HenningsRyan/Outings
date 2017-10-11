//
//  SJSUAnnotation.swift
//  Outings
//
//  Created by Ryan Hennings on 10/11/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import MapKit

class SJSUAnnotaion: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    
}


