//
//  NewOutingVC.swift
//  Outings
//
//  Created by Ryan Hennings on 11/12/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//  Uses the Eureka Form Framework
//  https://github.com/xmartlabs/eureka

import UIKit
import CoreLocation
import Eureka

class NewOutingNavController: UINavigationController, RowControllerType {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    var onDismissCallback : ((UIViewController) -> ())?
}

class NewOutingVC: FormViewController {
    
    
    @IBOutlet weak var addOutingButtonLabel: UIButton!
    
    // MARK: - Form data field vars
    private var outingTitle: String?
    
    private var dateTimeValue: Date?
    private var toggleSwitch: Bool?
    private var location: CLLocation?
    private var lattitude: String?
    private var longitude: String?
    private var userImageUpload: UIImage?
    private var locationDescription: String?
    
    
    var locationSelected = "Current Location"
    
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add top logo
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "New-Outing"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 102, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
//
        // Initialize Varibles sent to Firestore
        dateTimeValue = Date()
        toggleSwitch = true
        location = CLLocationManager().location
        lattitude = String(format: "%f", (location?.coordinate.latitude)!)
        longitude = String(format: "%f", (location?.coordinate.longitude)!)
        
//        // Back Button
//        let buttonOptions = UIButton(type: .system)
//        buttonOptions.setImage(#imageLiteral(resourceName: "backButton"), for: .normal)
//        buttonOptions.setTitle(" Back", for: .normal)
//        buttonOptions.sizeToFit()
//        buttonOptions.setTitleColor(.white, for: .normal)
//        buttonOptions.tintColor = .white
//        buttonOptions.addTarget(self, action: #selector(backAction), for: .touchUpInside)
//        let backNavButton = UIBarButtonItem(customView: buttonOptions)
//        navigationItem.leftBarButtonItem = backNavButton
        
        // Add Outing Button
        self.view.bringSubview(toFront: addOutingButtonLabel)
        
        initializeForm()
    }
    
    // MARK: - Back Button Touch Event
    // https://stackoverflow.com/a/38800720
//    @objc func backAction() {
//        let transition: CATransition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionReveal
//        transition.subtype = kCATransitionFromRight
//        self.view.window!.layer.add(transition, forKey: nil)
//        self.dismiss(animated: false, completion: nil)
//    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let fullDate = dateTimeValue?.description.components(separatedBy: " ")
        
        if let dateTime = fullDate,
            let hours = Calendar.current.dateComponents(in: TimeZone.current, from: dateTimeValue!).hour,
            let minutes = Calendar.current.dateComponents(in: TimeZone.current, from: dateTimeValue!).minute {
            let time = "\(hours):\(minutes)"
            print("RYAN: Date   -        \(dateTime[0])")
            print("RYAN: Time   -        \(time)")
        } else {
            print("RYAN: date unwrap failed")
        }
        
        print("RYAN: Title           \(String(describing: outingTitle))")
        print("RYAN: Toggle switch - \(String(describing: toggleSwitch))")
        
        print("RYAN: Latittude       \(String(describing: lattitude))")
        print("RYAN: Logitude        \(String(describing: longitude))")
        print("RYAN: Location Desc   \(String(describing: locationDescription))")
    }
    
    // MARK: - Init Eureka Form
    private func initializeForm() {
        form +++
            
        Section("New Outing Information")
        
        // Title Field
        <<< TextRow("Title").cellSetup { cell, row in
            cell.textField.placeholder = row.tag
            }.onChange({ (row) in
                self.outingTitle = row.value
            })
        
        +++ Section()
        
        // Toggle Button
        <<< SwitchRow("Allow Friends to Join") {
            $0.title = $0.tag
            $0.value = true
            }.onChange { row in // add [weak self] for modifing outside of handler
                if row.value ?? false {
                    self.toggleSwitch = true
                }
                else {
                    self.toggleSwitch = false
                }
        }
        
        // Date/Time Field
        <<< DateTimeInlineRow("Date and Time") {
            $0.title = $0.tag
            $0.value = Date().addingTimeInterval(60*60*24)
            }.onChange({ (dateTime) in
                self.dateTimeValue = dateTime.value
            })
    
        <<< LocationRow() {
            $0.title = "Current Location"
            if locationManager == nil {
                locationManager = CLLocationManager()
            }
            locationManager?.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            $0.value = locationManager.location
            }.onChange({ (row) in
                self.location = row.value
                self.locationDescription = row.title
            })
        
        +++ Section("Add Image to Outing")
        
        <<< ImageRow() {
            $0.title = "Custom Image"
            }.onChange({ (image) in
                self.userImageUpload = image.value
            })
        
            // TODO: - Add Estimated time field
    }

}


