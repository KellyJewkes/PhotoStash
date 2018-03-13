//
//  StashImagesViewController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit

class StashImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photoAlbum: PhotoAlbum?
    
    
    // MARK: - Outlets
    @IBOutlet weak var stashNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var holderView: UIView!
    
    
   // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        holderView.clipsToBounds = true
        holderView.layer.cornerRadius = 20
        stashNameLabel.text = photoAlbum?.title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    //MARK: - Invite & share button
    @IBAction func inviteButtonTapped(_ sender: Any) {
      let shareVC = UIActivityViewController(activityItems: ["link to this album"], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
    
    
    //MARK: - Add new image button (camera & photo library)
    @IBAction func addImageButtonTapped(_ sender: Any) {
        CameraPhotoHandler.shared.showActionSheet(vc: self)
        CameraPhotoHandler.shared.imagePickedBlock = { (image) in
            
        }
    }
    
    
    //MARK: - Collection view functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoController.shared.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newImageCell", for: indexPath) as! PhotoCollectionViewCell
        //cell.cellImage.image = PhotoController.shared.photos[indexPath.item]
         return cell
    }
}