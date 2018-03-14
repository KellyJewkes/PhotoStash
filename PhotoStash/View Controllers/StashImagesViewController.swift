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
        navTitleImage()
        super.viewDidLoad()
        holderView.clipsToBounds = true
        holderView.layer.cornerRadius = 20
        stashNameLabel.text = photoAlbum?.title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
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
            let newPhoto = Photo(image: image)
            guard let photoAlbum = self.photoAlbum else {return}
            PhotoAlbumController.shared.add(photo: newPhoto, toPhotoAlbum: photoAlbum)
            
            
            
            
        }
        self.collectionView.reloadData()
    }
    //MARK: - title image
    func navTitleImage() {
        let navController = navigationController!
        
        self.navigationItem.setHidesBackButton(true, animated: false)

        let image = #imageLiteral(resourceName: "finalStache")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth * 2, height: bannerHeight * 2)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    //MARK: - Collection view functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoController.shared.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newImageCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = PhotoController.shared.photos[indexPath.item]
        cell.cellButton.imageView?.image = photo.image
         return cell
    }
}
