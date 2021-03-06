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
    
    
    let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
    let ckManager: CKManager = {
        return CKManager()
    }()
    
    static let sharedController = UserController()
    
    var currentUser: User? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.currentUserWasSetNotification, object: nil)
            }
        }
    }
    
    
    func createUserWith(username: String, email: String, completion: @escaping (_ success: Bool) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            guard let appleUsersRecordID = appleUsersRecordID else {return}
            
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)
            
            let user = User(username: username, email: email, appleUserRef: appleUserRef)
            
            let userRecord = CKRecord(user: user)
            
            CKContainer.default().publicCloudDatabase.save(userRecord){ (record, error) in
                if let error = error { print("Error saving record", error.localizedDescription) }
                
                guard let record = record, let currentUser = User(cloudKitRecord: record) else
                {completion(false) ; return }
                
                
                self.currentUser = currentUser
                completion(true)
                
            }
            
        }
    }

    func fetchCurrentUser(completion: @escaping (_ success: Bool) -> Void = { _ in}) {
        
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            if let error = error { print("error fetching user", error.localizedDescription)}
            
            guard let appleUserRecordID = appleUserRecordID else { completion(false); return }
            
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserReference)
            
            self.ckManager.fetchRecordsWithType(User.CKKeys.TypeKey, predicate: predicate, recordFetchedBlock: nil, completion: { (records, error) in
                guard let currentUserRecord = records?.first else { completion(false); return }
                
                let currentUser = User(cloudKitRecord: currentUserRecord)
                
                self.currentUser = currentUser
                
                completion(true)
            })
        }
    }
    
    

}



