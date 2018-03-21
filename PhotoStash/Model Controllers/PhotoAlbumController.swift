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



//class PhotoAlbumController {
//
//
//    var photoAlbums = [PhotoAlbum]()
//
//    static let shared = PhotoAlbumController()
//
//    func add(photoAlbumWithTitle title: String) {
//        let photoAlbum = PhotoAlbum(title: title)
//        photoAlbums.append(photoAlbum)
//    }
//
//    func delete(photoAlbum: PhotoAlbum) {
//        guard let index = photoAlbums.index(of: photoAlbum) else {return}
//        photoAlbums.remove(at: index)
//
//    }
//
//    func add(photo: Photo, toPhotoAlbum photoAlbum: PhotoAlbum) {
//        photoAlbum.photos.append(photo)
//    }
//
//    func remove(photo: Photo, fromPhotoAlbum photoAlbum: PhotoAlbum) {
//        guard let index = photoAlbum.photos.index(of:photo) else {return}
//        photoAlbum.photos.remove(at: index)
//    }
//
//
//
//}

extension PhotoAlbumController {
    static let photoAlbumChangedNotification = Notification.Name("PhotoAlbumChangedNotification")
}

class PhotoAlbumController {
    
    static let sharedController = PhotoAlbumController()
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    var photoAlbums = [PhotoAlbum]() {
        didSet {
            DispatchQueue.main.async {
                let nC = NotificationCenter.default
                nC.post(name: PhotoAlbumController.photoAlbumChangedNotification, object: self)
            }
        }
    }
    
    
    func createPhotoAlbumWith(title: String, completion: ((PhotoAlbum) -> Void)?) {
        let photoAlbum = PhotoAlbum(title: title)
        photoAlbums.append(photoAlbum)
        
        CKManager.shared.saveRecord(photoAlbum.cloudKitRecord, database: publicDatabase) { (record, error) in
            guard let record = record else {
                if let error = error {
                    NSLog("Error saving new photAlbum \(error)")
                    return
                }
                completion?(photoAlbum)
                return
            }
            photoAlbum.cloudKitRecordID = record.recordID
        }
    }
}










