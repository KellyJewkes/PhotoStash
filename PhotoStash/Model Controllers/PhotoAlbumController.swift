//
//  PhotoAlbumController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import  UIKit
import CloudKit


extension PhotoAlbumController {
    static let photoAlbumChangedNotification = Notification.Name("PhotoAlbumChangedNotification")
}

class PhotoAlbumController {
    
    static let sharedController = PhotoAlbumController()
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    var photoAlbums: [PhotoAlbum] = []
       
    
    var photoAlbum: PhotoAlbum? {
        didSet {
            
        }
    }
    
    func createPhotoAlbumWith(title: String, completion: @escaping (_ success: Bool) -> Void) {
        
        
        CKContainer.default().fetchUserRecordID { (ckRecordID, error) in
            
            guard let ckRecordID = ckRecordID else {return}
            
            let userRef = CKReference(recordID: ckRecordID, action: .deleteSelf)
            
            let photoAlbum = PhotoAlbum(title: title, userReference: userRef)
            
            self.photoAlbums.append(photoAlbum)
            
            let photoAlbumRecord = CKRecord(photoAlbum: photoAlbum)
            
            CKContainer.default().publicCloudDatabase.save(photoAlbumRecord){ (record, error) in
                
                if let error = error { print(error, error.localizedDescription) }
                guard let record = record, let currentPhotoAlbum = PhotoAlbum(cloudKitRecord: record) else
                {completion(false) ; return }
                
                
                self.photoAlbum = currentPhotoAlbum
                completion(true)
                
            }
        }
    }
}

