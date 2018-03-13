//
//  Photo.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Photo: Equatable {
    
    init (name: String, image: UIImage) {
        
        self.name = name
        self.image = image

    }
        
    let name: String
    let image: UIImage
    
    }


    func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.name == rhs.name && lhs.image == rhs.image
    
}
