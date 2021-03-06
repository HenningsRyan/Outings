//
//  LoginVC
//  AMLoginSingup
//
//  Based on:  https://github.com/amirdew/AMLoginSignupby
//  Modified by Ryan Hennings 11/7/17
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

enum AMLoginSignupViewMode {
    case login
    case signup
}

class LoginVC: UIViewController {
    
    let animationDuration = 0.25
    var mode:AMLoginSignupViewMode = .signup
    
    //MARK: - background image constraints
    @IBOutlet weak var backImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageBottomConstraint: NSLayoutConstraint!
    
    //MARK: - login views and constrains
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    
    //MARK: - signup views and constrains
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    
    //MARK: - logo and constrains
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialsView: UIView!
    @IBOutlet weak var facebookImg: UIImageView!
    
    //MARK: - input views
    @IBOutlet weak var loginEmailInputView: AMInputView!
    @IBOutlet weak var loginPasswordInputView: AMInputView!
    @IBOutlet weak var signupEmailInputView: AMInputView!
    @IBOutlet weak var signupPasswordInputView: AMInputView!
    @IBOutlet weak var signupPasswordConfirmInputView: AMInputView!
    
    //MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
        // set view to login mode
        toggleViewMode(animated: false)
        
        //add keyboard notification
         NotificationCenter.default.addObserver(self, selector: #selector(keyboarFrameChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        //Facebook image action event
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(facebookTapped(tapGestureRecognizer:)))
        facebookImg.isUserInteractionEnabled = true
        facebookImg.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Ryan - FB Sign in
    @objc func facebookTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                else{
                    //MARK: FB User Authenticated
                    print("RYAN: Firebase FB User Authenticated")
                    let fbPhotoURL = String(describing: user?.photoURL)
                    
                    if let userID = user?.uid,
                        let provider = user?.providerID,
                        let emailAddr = user?.email,
                        let username = user?.displayName {
                        let userData = [
                            "provider": provider,
                            "email": emailAddr,
                            "photo": fbPhotoURL,
                            "username": username]
                        self.completeSignIn(id: userID, userData: userData)
                    } else {
                        print("RYAN: Failed to Segue Home")
                    }
                }
            }) // End Completion Handle
        }
    }
    
    //MARK: - button actions
    @IBAction func loginButtonTouchUpInside(_ sender: AnyObject) {
        if mode == .signup { toggleViewMode(animated: true) }
        else {
            if let email = loginEmailInputView.textFieldView.text, let pwd = loginPasswordInputView.textFieldView.text {
                Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    if error == nil {
                        print("RYAN: User authenticated with EMAIL firebase")
                        
                        if let userID = user?.uid,
                            let provider = user?.providerID,
                            let emailAddr = user?.email {
                            
                            let userData = [
                                "provider": provider,
                                "email": emailAddr]
                            
                            self.completeSignIn(id: userID, userData: userData)
                        }
                    }
                    else {
                        let alertController = UIAlertController(title: "Oops!", message: "Invalid email or password", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
            else {
                print("RYAN: Invalid Info here")
            }
            //TODO: Further Validation

            //TODO: login by this data
//            NSLog("Email:\(String(describing: loginEmailInputView.textFieldView.text)) Password:\(String(describing: loginPasswordInputView.textFieldView.text))")
        }
    }
    
    @IBAction func signupButtonTouchUpInside(_ sender: AnyObject) {
        if mode == .login {
            toggleViewMode(animated: true) }
        else {
            if let email = signupEmailInputView.textFieldView.text, let pwd = signupPasswordInputView.textFieldView.text, let cpwd = signupPasswordConfirmInputView.textFieldView.text {

                if pwd != cpwd {
                    print("\(pwd) \(cpwd)")
                    let alertController = UIAlertController(title: "Oops!", message: "Passwords do not match", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if error != nil {
                        let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        print("RYAN: Error creating user")
                    }
                    else {
                        print("RYAN: New User added to Firebase")
                        if let userID = user?.uid,
                            let provider = user?.providerID,
                            let emailAddr = user?.email {
                            let userData = [
                                "provider": provider,
                                "email": emailAddr]
                            self.completeSignIn(id: userID, userData: userData)
                        }
                        // createFirebaseDBUSer
//                        self.performSegue(withIdentifier: "toMainMenu", sender: nil)
                    }
                })
            }
        }
    }
    
    //MARK: User Authenticated - Segue to Home
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.dataStorage.createFirestoreDBUser(uid: id, userData: userData)
        self.performSegue(withIdentifier: "toMainMenu", sender: nil)
    }
    
    
    //MARK: - toggle view
    func toggleViewMode(animated:Bool){
        // toggle mode
        mode = mode == .login ? .signup:.login
        
        // set constraints changes
        backImageLeftConstraint.constant = mode == .login ? 0:-self.view.frame.size.width
        
        loginWidthConstraint.isActive = mode == .signup ? true:false
        logoCenterConstraint.constant = (mode == .login ? -1:1) * (loginWidthConstraint.multiplier * self.view.frame.size.width)/2
        loginButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(mode == .login ? 300:900))
        signupButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(mode == .signup ? 300:900))
        
        //animate
        self.view.endEditing(true)
        
        UIView.animate(withDuration:animated ? animationDuration:0) {
            //animate constraints
            self.view.layoutIfNeeded()
            
            //hide or show views
            self.loginContentView.alpha = self.mode == .login ? 1:0
            self.signupContentView.alpha = self.mode == .signup ? 1:0
            
            // rotate and scale login button
            let scaleLogin:CGFloat = self.mode == .login ? 1:0.4
            let rotateAngleLogin:CGFloat = self.mode == .login ? 0:CGFloat(-Double.pi / 2)
            
            var transformLogin = CGAffineTransform(scaleX: scaleLogin, y: scaleLogin)
            transformLogin = transformLogin.rotated(by: rotateAngleLogin)
            self.loginButton.transform = transformLogin
            
            // rotate and scale signup button
            let scaleSignup:CGFloat = self.mode == .signup ? 1:0.4
            let rotateAngleSignup:CGFloat = self.mode == .signup ? 0:CGFloat(-Double.pi / 2)
            
            var transformSignup = CGAffineTransform(scaleX: scaleSignup, y: scaleSignup)
            transformSignup = transformSignup.rotated(by: rotateAngleSignup)
            self.signupButton.transform = transformSignup
        }
    }
    
    
    //MARK: - keyboard
    @objc func keyboarFrameChange(notification:NSNotification){
        let userInfo = notification.userInfo as! [String:AnyObject]
        
        // get top of keyboard in view
        let topOfKetboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue .origin.y
        
        // get animation curve for animate view like keyboard animation
        var animationDuration:TimeInterval = 0.25
        var animationCurve:UIViewAnimationCurve = .easeOut
        if let animDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = animDuration.doubleValue
        }
        
        if let animCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve =  UIViewAnimationCurve.init(rawValue: animCurve.intValue)!
        }
        
        // check keyboard is showing
        let keyboardShow = topOfKetboard != self.view.frame.size.height
        
        //hide logo in little devices
        let hideLogo = self.view.frame.size.height < 667
        
        // set constraints
        backImageBottomConstraint.constant = self.view.frame.size.height - topOfKetboard
        
        logoTopConstraint.constant = keyboardShow ? (hideLogo ? 0:20):50
        logoHeightConstraint.constant = keyboardShow ? (hideLogo ? 0:40):60
        logoBottomConstraint.constant = keyboardShow ? 20:32
        logoButtomInSingupConstraint.constant = keyboardShow ? 20:32
        
        forgotPassTopConstraint.constant = keyboardShow ? 30:45
        
        loginButtonTopConstraint.constant = keyboardShow ? 25:30
        signupButtonTopConstraint.constant = keyboardShow ? 23:35
        
        loginButton.alpha = keyboardShow ? 1:0.7
        signupButton.alpha = keyboardShow ? 1:0.7
        
        // animate constraints changes
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
    }
    
    //MARK: - hide status bar in swift3
    override var prefersStatusBarHidden: Bool {
        return true
    }  
}

