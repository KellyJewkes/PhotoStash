//
//  UserController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/13/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    lazy var ckManager: CKManager = {
        return CKManager()
    }()
    var user: User? {
        didSet {
            print("New User here.")
            NotificationCenter.default.post(name: User.customNotifications.userSet, object: nil)
        }
    }
    
    private init() {}
    
    func createNewUser(username: String, email: String) {
        ckManager.fetchUserRecordID { (recordID, error) in
            
            if let error = error {
                print("error getting user ID \(error.localizedDescription)")
                return
            }
            guard let recordID = recordID else {return}
            let ckReference = CKReference(recordID: recordID, action: CKReferenceAction.none)
            
            let newUser = User(username: username, email: email, referenceToUser: ckReference)
            
            self.ckManager.save(user: newUser, completion: { (record, error) in
                if let error = error {
                    print("Error saving new user \(error.localizedDescription)")
                } else {
                    print("Save successfully!!! \(record!.recordID)")
                    self.user = newUser
                }
            })
        }
    }
}
