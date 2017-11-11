//
//  MapStartVC.swift
//  Outings
//
//  Created by Ryan Hennings on 11/10/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit
import ArcKit
import MapKit
import MGEvents
import Cartography
import CoreLocation
import XLActionController

class MapStartVC: UIViewController {
//    @IBOutlet weak var startButtonLabel: UIButton!
//    @IBOutlet weak var stopButtonLabel: UIButton!
    @IBOutlet weak var mapNavBarButton: UIBarButtonItem!
    
    var rawLocations: [CLLocation] = []
    var filteredLocations: [CLLocation] = []
    var locomotionSamples: [LocomotionSample] = []
    var baseClassifier: ActivityTypeClassifier<ActivityTypesCache>?
    var transportClassifier: ActivityTypeClassifier<ActivityTypesCache>?
    
    var settings = SettingsView()
    
    public var appIsTracking = false
    
    // MARK: controller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        tappedStart()
    }
    
    @IBAction func mapTrackingTogglePressed(_ sender: UIButton) {
        let actionController = PeriscopeActionController()
        
        var imageFill = UIImage(named: "locationFill")
        imageFill = imageFill?.withRenderingMode(.alwaysOriginal)
        var imageLine = UIImage(named: "locationLine")
        imageLine = imageLine?.withRenderingMode(.alwaysOriginal)
        
        print("RYAN: Tracking Status \(appIsTracking)")
        if !appIsTracking {
            print("RYAN: Start Pressed")
            actionController.headerData = "Are you sure you want to Start?"
            actionController.addAction(Action("Start", style: .destructive, handler: { action in
                self.tappedStart()
                self.appIsTracking = true
            }))
            
            // TODO: Change Map Icon
//            if appIsTracking { self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageFill, style: .plain, target: nil, action: nil) }
        }
        else {
            print("RYAN: Stop Pressed")
            actionController.headerData = "Are you sure you want to end this Outing?"
            actionController.addAction(Action("Stop", style: .destructive, handler: { action in
                self.tappedStop()
                self.appIsTracking = false
            }))
            
//            if !appIsTracking { self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageLine, style: .plain, target: nil, action: nil) }
        }
        
        actionController.addSection(PeriscopeSection())
        actionController.addAction(Action("Cancel", style: .cancel, handler: { action in
        }))
        present(actionController, animated: true, completion: nil)
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        
//        startButtonLabel.imageView?.contentMode = .scaleAspectFit
//        stopButtonLabel.imageView?.contentMode = .scaleAspectFit
        buildViewTree()
        buildResultsViewTree()
        
        // the Core Location / Core Motion singleton
        let loco = LocomotionManager.highlander
        
        // an API key is only necessary if you're using ActivityTypeClassifier
        loco.apiKey = "13921b60be4611e7b6e021acca45d94f"
        
        let centre = NotificationCenter.default
        
        // observe incoming location / locomotion updates
        centre.addObserver(forName: .locomotionSampleUpdated, object: loco, queue: OperationQueue.main) { note in
            self.locomotionSampleUpdated(note: note)
        }
        
        centre.addObserver(forName: .settingsChanged, object: settings, queue: OperationQueue.main) { _ in
            self.updateTheMap()
        }
        loco.requestLocationPermission()
    }
    
    // MARK: process incoming locations
    func locomotionSampleUpdated(note: Notification) {
        if let location = note.userInfo?["rawLocation"] as? CLLocation { rawLocations.append(location) }
        
        if let location = note.userInfo?["filteredLocation"] as? CLLocation { filteredLocations.append(location) }
        
        let sample = LocomotionManager.highlander.locomotionSample()
        
        locomotionSamples.append(sample)
        
        updateTheBaseClassifier()
        updateTheTransportClassifier()
        
        buildResultsViewTree(sample: sample)
        updateTheMap()
    }
    
    func updateTheBaseClassifier() {
        guard settings.enableTheClassifier else { return }
        
        // need a coordinate to know what classifier to fetch (there's thousands of them)
        guard let coordinate = LocomotionManager.highlander.filteredLocation?.coordinate else { return }
        
        // no need to update anything if the current classifier is still valid
        if let classifier = baseClassifier, classifier.contains(coordinate: coordinate), !classifier.isStale { return }
        
        // note: this will return nil if the ML models haven't been fetched yet, but will also trigger a fetch
        baseClassifier = ActivityTypeClassifier(requestedTypes: ActivityTypeName.baseTypes, coordinate: coordinate)
    }
    
    func updateTheTransportClassifier() {
        guard settings.enableTheClassifier && settings.enableTransportClassifier else { return }
        
        // need a coordinate to know what classifier to fetch (there's thousands of them)
        guard let coordinate = LocomotionManager.highlander.filteredLocation?.coordinate else { return }
        
        // no need to update anything if the current classifier is still valid
        if let classifier = transportClassifier, classifier.contains(coordinate: coordinate), !classifier.isStale { return }
        
        // note: this will return nil if the ML models haven't been fetched yet, but will also trigger a fetch
        transportClassifier = ActivityTypeClassifier(requestedTypes: ActivityTypeName.transportTypes, coordinate: coordinate)
    }
    
    // MARK: tap actions
    func tappedStart() {
        let loco = LocomotionManager.highlander
        
        // for demo purposes only. the default value already best balances accuracy with battery use
        loco.maximumDesiredLocationAccuracy = kCLLocationAccuracyBest
        
        // this is independent of the user's setting, and will show a blue bar if user has denied "always"
        loco.locationManager.allowsBackgroundLocationUpdates = true
        
        loco.startCoreLocation()
        loco.startCoreMotion()
    }
    
    func tappedStop() {
        let loco = LocomotionManager.highlander
        loco.stopCoreLocation()
        loco.stopCoreMotion()
    }

    // MARK: UI updating
    func updateTheMap() {
        // don't bother updating the map when we're not in the foreground
        guard UIApplication.shared.applicationState == .active else { return }
        
        map.removeOverlays(map.overlays)
        map.removeAnnotations(map.annotations)
        map.showsUserLocation = settings.showUserLocation && LocomotionManager.highlander.recordingCoreLocation
        
        let mapType: MKMapType = settings.showSatelliteMap ? .hybrid : .standard
        if mapType != map.mapType {
            map.mapType = mapType
            setNeedsStatusBarAppearanceUpdate()
        }
        
        if settings.showRawLocations { addPath(locations: rawLocations, color: .red) }
        if settings.showFilteredLocations { addPath(locations: filteredLocations, color: .purple) }
        if settings.showLocomotionSamples { addSamples(samples: locomotionSamples) }
        if settings.autoZoomMap { zoomToShow(overlays: map.overlays) }
    }
    
    func zoomToShow(overlays: [MKOverlay]) {
        guard !overlays.isEmpty else { return }
        
        var mapRect: MKMapRect?
        for overlay in overlays {
            if mapRect == nil { mapRect = overlay.boundingMapRect }
            else { mapRect = MKMapRectUnion(mapRect!, overlay.boundingMapRect) }
        }
        
        let padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        map.setVisibleMapRect(mapRect!, edgePadding: padding, animated: true)
    }
    
    // MARK: view tree building
    func buildViewTree() {
        view.addSubview(map)
        constrain(map) { map in
            map.top == map.superview!.top
            map.left == map.superview!.left
            map.right == map.superview!.right
            map.bottom == map.superview!.bottom
        }
    }
    
    // TODO: Handle Results
    func buildResultsViewTree(sample: LocomotionSample? = nil) {
        // don't bother updating the UI when we're not in the foreground
        guard UIApplication.shared.applicationState == .active else { return }
    }
    
    // MARK: map building
    func addPath(locations: [CLLocation], color: UIColor) {
        guard !locations.isEmpty else { return }
        
        var coords = locations.flatMap { $0.coordinate }
        let path = PathPolyline(coordinates: &coords, count: coords.count)
        path.color = color
        
        map.add(path)
    }
    
    func addSamples(samples: [LocomotionSample]) {
        var currentGrouping: [LocomotionSample]?
        
        for sample in samples where sample.location != nil {
            let currentState = sample.movingState
            
            // state changed? close off the previous grouping, add to map, and start a new one
            if let previousState = currentGrouping?.last?.movingState, previousState != currentState {
            
                // add new sample to previous grouping, to link them end to end
                currentGrouping?.append(sample)
                
                // add it to the map
                addGrouping(currentGrouping!)
                
                currentGrouping = nil
            }
            
            currentGrouping = currentGrouping ?? []
            currentGrouping?.append(sample)
        }
        
        // add the final grouping to the map
        if let grouping = currentGrouping { addGrouping(grouping) }
    }
    
    func addGrouping(_ samples: [LocomotionSample]) {
        guard let movingState = samples.first?.movingState else { return }
        
        let locations = samples.flatMap { $0.location }
        
        switch movingState {
        case .moving:
            addPath(locations: locations, color: .blue)
        case .stationary:
            if settings.showStationaryCircles { addVisit(locations: locations) }
            else { addPath(locations: locations, color: .orange) }
        case .uncertain:
            addPath(locations: locations, color: .magenta)
        }
    }
    
    func addVisit(locations: [CLLocation]) {
        if let center = CLLocation(locations: locations) {
            map.addAnnotation(VisitAnnotation(coordinate: center.coordinate))
            
            let radius = locations.radiusFrom(center: center)
            let circle = VisitCircle(center: center.coordinate, radius: radius.mean + radius.sd * 2)
            circle.color = .orange
            map.add(circle, level: .aboveLabels)
        }
    }
    
    // MARK: view property getters
//    @IBOutlet weak var map: MKMapView!
    lazy var map: MKMapView = {
        let map = MKMapView()
        map.delegate = self

        map.isRotateEnabled = false
        map.isPitchEnabled = false
        map.showsScale = true

        return map
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        
        button.backgroundColor = .white
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.red, for: .normal)
        
        button.onControlEvent(.touchUpInside) { [weak self] in
//            self?.tappedStop()
        }
        
        return button
    }()
}

// MARK: MKMapViewDelegate
extension MapStartVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let path = overlay as? PathPolyline { return path.renderer }
        else if let circle = overlay as? VisitCircle { return circle.renderer }
        else { fatalError("RYAN: Map Path Error") }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? VisitAnnotation { return annotation.view }
        return nil
    }
}
