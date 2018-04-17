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

class User {
    
    var username: String
    var email: String
    var photoAlbums: [PhotoAlbum] = []
    let appleUserRef: CKReference?
    var cloudKitRecordID: CKRecordID?
    
    
    enum CKKeys {
        
        static let TypeKey = "User"
        static let usernameKey = "username"
        static let emailKey = "email"
        static let appleUserRefKey = "appleUserRef"
        
    }
    
    enum customNotifications {
        static let userSet = Notification.Name("UserWasSet")
    }
    
    init(username: String, email: String, appleUserRef: CKReference) {
        self.email = email
        self.username = username
        self.appleUserRef = appleUserRef
        
    }
    
    
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[User.CKKeys.usernameKey] as? String,
            let email = cloudKitRecord[User.CKKeys.emailKey] as? String,
            let appleUserRef = cloudKitRecord[User.CKKeys.appleUserRefKey] as? CKReference else { return nil}
        
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
        self.cloudKitRecordID = cloudKitRecord.recordID
        
    }
    
    var recordType: String { return User.CKKeys.TypeKey }
    
    var cloudKitRecord: CKRecord? {
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record.setValue(username, forKey: CKKeys.usernameKey)
        record.setValue(email, forKey: CKKeys.emailKey)
        
        return record
    }
}


extension CKRecord {
    convenience init(user: User) {
        
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: User.CKKeys.TypeKey, recordID: recordID)
        
        self.setObject(user.username as CKRecordValue, forKey: User.CKKeys.usernameKey)
        self.setObject(user.email as CKRecordValue, forKey: User.CKKeys.emailKey)
        self.setValue(user.appleUserRef, forKey: User.CKKeys.appleUserRefKey)
        
    }
}
