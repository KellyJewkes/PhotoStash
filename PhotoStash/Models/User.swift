//
//  User.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/13/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import CloudKit

class User {
    
    let username: String
    let email: String
    let referenceToUser: CKReference
    let ckRecordID: CKRecordID?
    
    enum CKKeys {
        static let recordType = "User"
        static let usernameKey = "username"
        static let emailKey = "email"
        static let referenceToUserKey = "referenceToUser"
    }
    
    enum customNotifications {
        static let userSet = Notification.Name("UserWasSet")
    }
    
    init(username: String, email: String, referenceToUser: CKReference) {
        self.email = email
        self.username = username
        self.referenceToUser = referenceToUser
        self.ckRecordID = nil
    }
    
}

extension CKRecord {
    convenience init(user: User) {
        if let ckRecordID = user.ckRecordID {
            self.init(recordType: User.CKKeys.recordType, recordID: ckRecordID)
        } else {
            self.init(recordType: User.CKKeys.recordType)
        }
        self.setObject(user.username as CKRecordValue, forKey: User.CKKeys.usernameKey)
        self.setObject(user.email as CKRecordValue, forKey: User.CKKeys.emailKey)
        self.setObject(user.referenceToUser as CKRecordValue, forKey: User.CKKeys.referenceToUserKey)
        
    }
}
