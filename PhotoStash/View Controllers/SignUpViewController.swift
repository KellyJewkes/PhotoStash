//
//  SignUpViewController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/12/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    

    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 20
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
