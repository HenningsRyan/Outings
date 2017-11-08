//
//  ViewController.swift
//  Outings
//
//  Created by Mitchell Jake Sutton on 4/10/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mapView.mapType = MKMapType.satellite
        
        let location = CLLocationCoordinate2DMake(37.336742774, -121.88154805451632)
        let latitudeMeterSpan: CLLocationDegrees = 1000
        let longitudeMeteresSpan: CLLocationDegrees = 1000
        let mkCoordinate = MKCoordinateRegionMakeWithDistance(location, latitudeMeterSpan, longitudeMeteresSpan )
        mapView.setRegion(mkCoordinate, animated: true)
        
        let sjsuPin = SJSUAnnotaion(title: "SJSU", subtitle: "Engineering Department", coordinate: location)
        mapView.addAnnotation(sjsuPin)
    }
    
    private struct Constants {
        static let locationSJSU = CLLocationCoordinate2DMake(37.33689631985921, 121.88158728182316)
        static let latitudinalMeters: CLLocationDegrees = 2000.0
        static let longitudinalMeters: CLLocationDegrees = 2000.0
    }
    
}

