//
//  SignUpViewController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/12/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 20
        NotificationCenter.default.addObserver(self, selector: #selector(userCreated), name: User.customNotifications.userSet, object: nil)
    }
    
    @objc func userCreated() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        
        self.activityIndicator.isHidden = false
        
        guard let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty else {return}
        
        self.activityIndicator.startAnimating()
        
        UserController.sharedController.createUserWith(username: username, email: email) { (success) in
            
            self.activityIndicator.stopAnimating()
            
            if !success {
                DispatchQueue.main.async {
                    self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
                    self.activityIndicator.stopAnimating()
                }
                return
            }
        }
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
        guard UserController.sharedController.user == nil else {userCreated(); return }
        
        activityIndicator.startAnimating()
        UserController.sharedController.fetchCurrentUser { (success) in
            
            if !success {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    self.presentSimpleAlert(title: "No iCloud account configured", message: "Please navigate to your device's settings app and set up iCloud.")
                    self.activityIndicator.isHidden = true
                }
                return
            }
        }
    }
    
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(dismissAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}



