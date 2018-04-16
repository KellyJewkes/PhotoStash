//
//  PhotoCollectionViewCell.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/12/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    
    var photo: Photo? {
        didSet {
            updateViews()
        }
    }
    
    
    func updateViews(){
        cellImage.image = photo?.image
    }
    
    
    @IBAction func cellButtonTapped(_ sender: Any) {
    }
}


