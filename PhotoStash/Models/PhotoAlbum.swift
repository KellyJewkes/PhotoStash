//
//  PhotoAlbum.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class PhotoAlbum {
    
    var photos: [Photo]?
    
    var title: String
    let userReference: CKReference?
    var users: [User] = []
    var recordType: String { return PhotoAlbum.CKKeys.typeKey }
    var cloudKitRecordID: CKRecordID?
    weak var user: User?
    
    enum CKKeys {
        
        static let typeKey = "PhotoAlbum"
        static let titleKey = "title"
        static let userReferenceKey = "userReference"
    }
    
    
    enum customNotifications {
        static let photoAlbumSet = Notification.Name("PhotoAlbumWasSet")
    }
    
    
    init(title: String, userReference: CKReference) {
        self.title = title
        self.userReference = userReference
    }
    
    
    init?(cloudKitRecord: CKRecord) {
        guard let title = cloudKitRecord[PhotoAlbum.CKKeys.titleKey] as? String,
            let userReference = cloudKitRecord[PhotoAlbum.CKKeys.userReferenceKey] as? CKReference else {return nil}
        
        self.title = title
        self.userReference = userReference
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
    
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record.setValue(title, forKey: CKKeys.titleKey)
        
        return record
    }
}


extension CKRecord {
    convenience init(photoAlbum: PhotoAlbum) {
        
        if let RecordID = photoAlbum.cloudKitRecordID {
            
            self.init(recordType: PhotoAlbum.CKKeys.typeKey, recordID:RecordID)
        }else{
            self.init(recordType: PhotoAlbum.CKKeys.typeKey)
        }
        self.setObject(photoAlbum.title as CKRecordValue, forKey: PhotoAlbum.CKKeys.titleKey)
        self.setValue(photoAlbum.userReference, forKey: PhotoAlbum.CKKeys.userReferenceKey)
    }
}
