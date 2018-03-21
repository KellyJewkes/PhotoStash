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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(userCreated), name: User.customNotifications.userSet, object: nil)
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 20
    }
    
    @objc func userCreated() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty else {return}
        UserController.sharedController.createUserWith(userName: username, email: email) { (_) in
        
        }
        
    }
    
    
}
