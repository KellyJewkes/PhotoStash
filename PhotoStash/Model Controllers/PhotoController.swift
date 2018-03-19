//
//  PhotoController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

//class PhotoController {
//
//    static let shared = PhotoController()
//
//    var photos = [Photo]()
//
//    static func create(photoWithImage image: UIImage, photoAlbum: PhotoAlbum) {
//        let photo = Photo(image: image)
//        PhotoAlbumController.shared.add(photo: photo, toPhotoAlbum: photoAlbum)
//
//    }
//
//}

class PhotoController {
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    var photos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
            }
        }
    }
    
    static let sharedController = PhotoController()
    
    func createPhotoWith(image: UIImage, completion: ((Photo) -> Void)?) {
        guard let data = UIImageJPEGRepresentation(image, 0.8) else {return}
        
        let photo = Photo(imageData: data)
        
        photos.append(photo)
        
        CKManager.shared
        
        
    }
    
}







