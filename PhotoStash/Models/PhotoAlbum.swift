//
//  PhotoAlbum.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation

class PhotoAlbum: Equatable {
    init(title: String, photos: [Photo] = []) {
        self.photos = photos
        self.title = title
    }
    
    var photos: [Photo]
    let title: String
    
}
func ==(lhs: PhotoAlbum, rhs: PhotoAlbum) -> Bool {
    return lhs.title == rhs.title
  
}

