//
//  NavBar.swift
//  Outings
//
//  Created by Ryan Hennings on 11/7/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit

class NavBar: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func setUpNavigationBarItems() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 70, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
//        let userIconButton = UIButton(type: .system)
//        userIconButton.setImage(#imageLiteral(resourceName: "userExpand"), for: .normal)
//        userIconButton.tintColor = UIColor.white
//        //        userIconButton.tintColor = UIColor(red: 26, green: 161, blue: 209, alpha: 1)
//        userIconButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userIconButton)
        
        let mapAddButton = UIButton(type: .system)
        mapAddButton.setImage(#imageLiteral(resourceName: "map-pin"), for: .normal)
        mapAddButton.tintColor = UIColor.white
        mapAddButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mapAddButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
