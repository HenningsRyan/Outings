//
//  NavBar.swift
//  Outings
//
//  Created by Ryan Hennings on 11/7/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit
import Eureka

class NavBar: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        userIconButton.addTarget(self, action: #selector(self.profilePressed), for: .touchUpInside)
        
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
    
    @objc func profilePressed(sender: UIButton!) {
        self.performSegue(withIdentifier: "toProfile", sender: nil)
    }
}
