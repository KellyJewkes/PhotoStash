//
//  User.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/13/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class User: Equatable {
    
    let username: String
    let email: String
   // let referenceToUser: CKReference
    let ckRecordID: CKRecordID?
    
    enum CKKeys {
        static let TypeKey = "User"
        static let usernameKey = "username"
        static let emailKey = "email"
       // static let referenceToUserKey = "referenceToUser"
    }
    
    enum customNotifications {
        static let userSet = Notification.Name("UserWasSet")
    }
    
    init(username: String, email: String) {
        self.email = email
        self.username = username
        self.ckRecordID = nil
       // self.referenceToUser = referenceToUser
    }

    var cloudKitRecordID: CKRecordID?
    
    //convenience required init?(record: CKRecord) {
    //    cloudKitRecordID = record.recordID
    //}

    var recordType: String { return User.CKKeys.TypeKey }
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        return record
    }
    
    
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.username == rhs.username
}

extension CKRecord {
    convenience init(user: User) {
        if let ckRecordID = user.ckRecordID {
            self.init(recordType: User.CKKeys.TypeKey, recordID: ckRecordID)
        } else {
            self.init(recordType: User.CKKeys.TypeKey)
        }
        self.setObject(user.username as CKRecordValue, forKey: User.CKKeys.usernameKey)
        self.setObject(user.email as CKRecordValue, forKey: User.CKKeys.emailKey)
      //  self.setObject(user.referenceToUser as CKRecordValue, forKey: User.CKKeys.referenceToUserKey)
        
    }
}
