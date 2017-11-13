//
//  MapSearchVC.swift
//  Outings
//
//  Created by Ryan Hennings on 11/12/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//
//  Based on tutorial by Maxim Bilan
//  https://github.com/maximbilan/iOS-MapKit-Tutorial

import UIKit
import MapKit

class MapSearchVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    private var searchController: UISearchController!
    private var localSearchRequest: MKLocalSearchRequest!
    private var localSearch: MKLocalSearch!
    private var localSearchResponse: MKLocalSearchResponse!
    
    private var annotation: MKAnnotation!
    private var locationManager: CLLocationManager!
    private var isCurrentLocation: Bool = false
    
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentLocationButton = UIBarButtonItem(title: "Current Location", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapSearchVC.currentLocationButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = currentLocationButton
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(MapSearchVC.searchButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = searchButton
        
        mapView.delegate = self
        mapView.mapType = .standard
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.center = self.view.center
    }
    
    // MARK: - Get Snapshot
    @IBAction func getSnapshotPressed(_ sender: UIButton) {
        let snapOptions = MKMapSnapshotOptions()
        snapOptions.region = mapView.region
        snapOptions.size = mapView.frame.size
        snapOptions.scale = UIScreen.main.scale

        let fileURL = NSURL(fileURLWithPath: "/Users/ryanhennings/Desktop/snap8.png")
        
        let image = screenshot()
//        image.crop(rect: CGRect(x: 0, y: 0, width: 50, height: 50))
        let data = UIImagePNGRepresentation(image.crop(rect: CGRect(x: view.center.x-200, y: view.center.y-200, width: 400, height: 400)))
        try? data?.write(to: fileURL as URL)

//        let snapshot = MKMapSnapshotter(options: snapOptions)

//        snapshot.start(with: DispatchQueue.global(qos: .default)) { (snap, error) in
//            guard let snap = snap else {
//                print("RYAN: Snapshot error \(String(describing: error))")
//                fatalError("RYAN: Image DispatchQueue Failed")
//            }
//
//            let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
//            let image = snap.image
//
//            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
//            image.draw(at: CGPoint.zero)
//
//            let visibleRect = CGRect(origin: CGPoint.zero, size: image.size)
//            for annotation in self.mapView.annotations {
//                var point = snap.point(for: annotation.coordinate)
//
//                if visibleRect.contains(point) {
//                    point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
//                    point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
//                    pin.image?.draw(at: point)
//                }
//            }
//
//            let completeImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//
//            let data = UIImagePNGRepresentation(completeImage!)
//            try? data?.write(to: fileURL as URL)
//
//            print("RYAN: snap saved to /Users/ryanhennings/Desktop/snap2.png")
//        }
    }
    
    // https://stackoverflow.com/a/41308750
    func screenshot() -> UIImage {
        let imageSize = UIScreen.main.bounds.size as CGSize;
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        for obj : AnyObject in UIApplication.shared.windows {
            if let window = obj as? UIWindow {
                if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                    // so we must first apply the layer's geometry to the graphics context
                    context!.saveGState();
                    // Center the context around the window's anchor point
                    context!.translateBy(x: window.center.x, y: window.center
                        .y);
                    // Apply the window's transform about the anchor point
                    context!.concatenate(window.transform);
                    // Offset by the portion of the bounds left of and above the anchor point
                    context!.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x,
                                         y: -window.bounds.size.height * window.layer.anchorPoint.y);
                    
                    // Render the layer hierarchy to the current context
                    window.layer.render(in: context!)
                    
                    // Restore the context
                    context!.restoreGState();
                }
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        return image!
    }


    // MARK: - Actions
    
    @objc func currentLocationButtonAction(_ sender: UIBarButtonItem) {
        if (CLLocationManager.locationServicesEnabled()) {
            if locationManager == nil {
                locationManager = CLLocationManager()
            }
            locationManager?.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            isCurrentLocation = true
        }
    }
    
    // MARK: - Search
    
    @objc func searchButtonAction(_ button: UIBarButtonItem) {
        if searchController == nil {
            searchController = UISearchController(searchResultsController: nil)
        }
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { [weak self] (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
                let alert = UIAlertController(title: nil, message: "Location not found", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
                alert.addAction(defaultAction)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            let pointAnnotation = MKPointAnnotation()
            
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            // TODO: Add Pin Annotations
//            let placeMark = MKPlacemark(coordinate: pointAnnotation.coordinate)
//            if let city = placeMark.locality,
//                let state = placeMark.administrativeArea {
//                pointAnnotation.subtitle = "\(city) \(state)"
//            }
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self!.mapView.centerCoordinate = pointAnnotation.coordinate
            self!.mapView.addAnnotation(pinAnnotationView.annotation!)
            
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isCurrentLocation {
            return
        }
        
        isCurrentLocation = false
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = ""
        mapView.addAnnotation(pointAnnotation)
    }
}

// https://stackoverflow.com/questions/39310729/problems-with-cropping-a-uiimage-in-swift
extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}




