//
//  PhotoController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import UIKit

class PhotoController {
    
    static let shared = PhotoController()
    
    var photos = [Photo]()
    
    static func create(photoWithName name: String, image: UIImage, photoAlbum: PhotoAlbum) {
        let photo = Photo(name: name, image: image)
        PhotoAlbumController.shared.add(photo: photo, toPhotoAlbum: photoAlbum)
        
    }
    
}
