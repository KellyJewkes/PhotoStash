//
//  UserController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/13/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import CloudKit


extension UserController {
    //static let userChangedNotification = Notification.Name("UserChangedNotification")
}

class UserController {
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.currentUserWasSetNotification, object: nil)
                //let nC = NotificationCenter.default
               // nC.post(name: UserController.userChangedNotification, object: self)
            }
        }
    }
    
    static let sharedController = UserController()
    
    func createUserWith(username: String, email: String, completion: @escaping (_ success: Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            guard let appleUsersRecordID = appleUsersRecordID else {return}
            
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)
            
            let user = User(username: username, email: email, appleUserRef: appleUserRef)
            
            let userRecord = CKRecord(user: user)
            
            CKContainer.default().publicCloudDatabase.save(userRecord){ (record, error) in
                if let error = error { print("Error saving record\(error.localizedDescription)") }
                
                guard let record = record, let currentUser = User(cloudKitRecord: record) else
                {completion(false) ; return }
                
                
                self.user = currentUser
                completion(true)
                
            }
            
        }
    }
}


