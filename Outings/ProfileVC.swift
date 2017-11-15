//
//  ProfileVC.swift
//  Outings
//
//  Created by Ryan Hennings on 11/15/17.
//  Copyright © 2017 OutingsCo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileVC: UIViewController {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var changeProfilePictureButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        if let user = Auth.auth().currentUser {
            usernameLabel.text = user.displayName
            let imageData = try? Data(contentsOf: user.photoURL!)
            userImage.image = UIImage(data: imageData!)
//            userImage = UIImageView(image: UIImage(data: imageData!))
        } else {
            print("RYAN: Error loading user")
        }
        Firestore.firestore().collection("users")
//        if let let profileURL = URL(string: )!
//        let user = FacebookAuthProvider.credential(withAccessToken: )
//        let userURL = FBSDKProfile.imageURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firedsButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func viewPostsButtonPressed(_ sender: UIButton) {
    }
    
    @IBOutlet weak var changeProfilePicturePressed: UIButton!
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
