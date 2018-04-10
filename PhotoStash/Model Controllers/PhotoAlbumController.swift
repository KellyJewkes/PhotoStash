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
//    func loadAlbums() {
//        let predicate = NSPredicate(value: true)
//        let sort = NSSortDescriptor(key: "title", ascending: true)
//        let query = CKQuery(recordType: "PhotoAlbum", predicate: predicate)
//        query.sortDescriptors = [sort]
//        let operation = CKQueryOperation(query: query)
//        operation.desiredKeys = ["title"]
//        operation.resultsLimit = 50
//
//        var newAlbums = [PhotoAlbum]()
//
//        operation.recordFetchedBlock = { record in
//            let album = PhotoAlbumController.sharedController.photoAlbum
//            album?.cloudKitRecordID = record.recordID
//            album?.title = record["title"] as! String
//            newAlbums.append(album!)
//
//            operation.queryCompletionBlock = { [unowned self] (cursor, error) in
//                DispatchQueue.main.async {
//                    if error == nil {
//                        self.photoAlbums = newAlbums
//                        self.tableView.reloadData()
//                    } else {
//                        print("Fetch Failed")
//                    }
//                }
//            }
//        }
//    }

