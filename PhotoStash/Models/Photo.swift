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
    
    init (image: UIImage) {
        
        
        self.image = image

    }
        
    
    let image: UIImage
    
    }


    func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.image == rhs.image
    
}
