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

class PhotoAlbum: Equatable {
    
    //    init(title: String, photos: [Photo] = []) {
    //        self.photos = photos
    //        self.title = title
    //    }
    //
       var photos: [Photo]?
    
    let title: String
    let ckRecordID: CKRecordID?
    private let userReferenceKey = "userReference"
    weak var user: User?
    var users: [User] = []
    
    
    enum CKKeys {
        static let typeKey = "PhotoAlbum"
        static let titleKey = "title"
      //  static let referenceKey = "reference"
    }
    
    enum customNotifications {
        static let photoAlbumSet = Notification.Name("PhotoAlbumWasSet")
    }
    
    
    var cloudKitRecordID: CKRecordID?
    
//    convenience required init?(record: CKRecord) {
//        cloudKitRecordID = record.recordID
//    }
    
    init(title: String) {
        self.title = title
      //  self.reference = reference
        self.ckRecordID = nil
    }
    
    var recordType: String { return PhotoAlbum.CKKeys.typeKey }
    
    var cloudKitRecord: CKRecord {
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record.setValue(title, forKey: CKKeys.titleKey)
        
      if let user = user,
        let userID = user.cloudKitRecordID {
        let userReference = CKReference(recordID: userID, action: .deleteSelf)
        record.setObject(userReference, forKey: userReferenceKey)
        }
        
        return record
        
    }
    
    
}

func ==(lhs: PhotoAlbum, rhs: PhotoAlbum) -> Bool {
    return lhs.title == rhs.title
}
    
    extension CKRecord {
        convenience init(photoAlbum: PhotoAlbum) {
            if let ckRecordID = photoAlbum.ckRecordID {
                self.init(recordType: PhotoAlbum.CKKeys.typeKey, recordID:ckRecordID)
            }else{
                self.init(recordType: PhotoAlbum.CKKeys.typeKey)
            }
            self.setObject(photoAlbum.title as CKRecordValue, forKey: PhotoAlbum.CKKeys.titleKey)
            
            
        
}
}
