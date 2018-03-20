//
//  PhotoAlbumController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import  UIKit

class PhotoAlbumController {
    
    var photoAlbums = [PhotoAlbum]()
    
    static let shared = PhotoAlbumController()
    
    func add(photoAlbumWithTitle title: String) {
        let photoAlbum = PhotoAlbum(title: title)
        photoAlbums.append(photoAlbum)
    }
    
    func delete(photoAlbum: PhotoAlbum) {
        guard let index = photoAlbums.index(of: photoAlbum) else {return}
        photoAlbums.remove(at: index)
        
    }
    
    func add(photo: Photo, toPhotoAlbum photoAlbum: PhotoAlbum) {
        photoAlbum.photos.append(photo)
    }
    
    func remove(photo: Photo, fromPhotoAlbum photoAlbum: PhotoAlbum) {
        guard let index = photoAlbum.photos.inde
        photoAlbum.photos.remove(at: index)
    }
    
}
