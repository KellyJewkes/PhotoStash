//
//  UserController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/13/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import CloudKit

//class UserController {

//    static let shared = UserController()
//
//    lazy var ckManager: CKManager = {
//        return CKManager()
//    }()
//    var user: User? {
//        didSet {
//            print("New User here.")
//            NotificationCenter.default.post(name: User.customNotifications.userSet, object: nil)
//        }
//    }
//
//    private init() {}
//
//    func createNewUser(username: String, email: String) {
//        ckManager.saveRecord(<#T##record: CKRecord##CKRecord#>, database: , completion: <#T##((CKRecord?, Error?) -> Void)?##((CKRecord?, Error?) -> Void)?##(CKRecord?, Error?) -> Void#>)
//
//            if let error = error {
//                print("error getting user ID \(error.localizedDescription)")
//                return
//            }
//            guard let recordID = recordID else {return}
//            let ckReference = CKReference(recordID: recordID, action: CKReferenceAction)
//
//            let newUser = User(username: username, email: email, referenceToUser: ckReference)
//
//            self.ckManager.save(user: newUser, completion: { (record, error) in
//                if let error = error {
//                    print("Error saving new user \(error.localizedDescription)")
//                } else {
//                    print("Save successful!!! \(record!.recordID)")
//                    self.user = newUser
//                }
//            })
//        }
//    }
//}

extension UserController {
    static let userChangedNotification = Notification.Name("UserChangedNotification")
}

class UserController {
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                let nC = NotificationCenter.default
                nC.post(name: UserController.userChangedNotification, object: self)
            }
        }
    }
    
    static let sharedController = UserController()
    
    func createUserWith(userName: String, email: String, completion: ((User) -> Void)?) {
        let user = User(username: userName, email: email)
        users.append(user)
        
        CKManager.shared.saveRecord(user.cloudKitRecord, database: publicDatabase) { (record, error) in
            guard let record = record else {
                if let error = error {
                    NSLog("Error saving new user \(error)")
                    return
                }
                completion?(user)
                return
            }
            user.cloudKitRecordID = record.recordID
        }
    }
}



