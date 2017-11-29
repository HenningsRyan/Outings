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
        
        // Add top logo
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "ProfileLogo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 75, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView

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
// MARK - Button Rounding
// https://stackoverflow.com/a/38876025
@IBDesignable
class ButtonRounding: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

@IBDesignable
class ImageRounding: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
