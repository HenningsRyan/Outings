//
//  SettingsVC.swift
//  Outings
//
//  Created by Max Cheiser on 11/7/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit
import Eureka
import Firebase


class SettingsVC: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBarItems()
        
        let settings = SettingsView()
        form +++ Section("Modify Map Tracking Settings")
            <<< SwitchRow(){ row in
                row.title = "Show Stops"
                row.value = true
                }.onChange({ (row) in
                    if let toggle = row.value {
                        showStops = toggle
                    }
                })

            <<< SwitchRow(){ row in
                row.title = "Show Raw Path"
                row.value = false
                }.onChange({ (row) in
                    if let toggle = row.value {
                        showRaw = toggle
                    }
                })
            
            <<< SwitchRow(){ row in
                row.title = "Autozoom"
                row.value = true
                }.onChange({ (row) in
                    if let toggle = row.value {
                        autoZoom = toggle
                    }
                })
        
        form +++ Section("User Settings")
            <<< AlertRow<String>() {
                $0.title = "Logout"
                $0.selectorTitle = "Are you sure you want to logout?"
                $0.options = ["Logout"]
                }.onChange { _ in
                    // User logout
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        self.performSegue(withIdentifier: "logout", sender: nil)
                    } catch let error as NSError {
                        print ("Error signing out: %@", error)
                    }
                    
                }
                .onPresent{ _, to in
                    to.view.tintColor = .blue
        }
        //super.setUpNavigationBarItems()
    }
    
    func setUpNavigationBarItems() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 70, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
        let userIconButton = UIButton(type: .system)
        userIconButton.setImage(#imageLiteral(resourceName: "userExpand"), for: .normal)
        userIconButton.tintColor = UIColor.white
        //        userIconButton.tintColor = UIColor(red: 26, green: 161, blue: 209, alpha: 1)
        userIconButton.frame = CGRect(x: 0, y: 0, width: constants.iconSize, height: constants.iconSize)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userIconButton)
        
        let mapAddButton = UIButton(type: .system)
        
        mapAddButton.setImage(#imageLiteral(resourceName: "locationLine"), for: .normal)
        mapAddButton.tintColor = UIColor.white
        mapAddButton.frame = CGRect(x: 0, y: 0, width: constants.iconSize, height: constants.iconSize)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mapAddButton)
        
        mapAddButton.addTarget(self, action: #selector(self.mapPressed), for: .touchUpInside)
    }
    
    @objc func mapPressed(sender: UIButton!) {
        self.performSegue(withIdentifier: "toNewOuting", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

