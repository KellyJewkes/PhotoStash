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
    var photos: [Photo] = []
    
    
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
            
//            var imageData: Data = UIImagePNGRepresentation(image)!
//            var newPhoto: UIImage = UIImage(data: imageData)!
//            let newPhoto2 = Photo(imageData: imageData)
//            guard let photoAlbum = self.photoAlbum else {return}
            
            PhotoController.sharedController.createPhotoWith(image: image, completion: { (_) in
                
                self.collectionView.reloadData()
                
                })
        }
    }
    func deleteAlert(){
        
        let alertController = UIAlertController(title: "Delete this album", message: "Warning! This can not be undone!", preferredStyle: .alert)
        
        let deleteAlbum = UIAlertAction(title: "DELETE", style: .destructive, handler:{(action: UIAlertAction)-> Void in
            guard let photoAlbum = self.photoAlbum else {return}
          //CKManager.
            self.navigationController?.popViewController(animated: true)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAlbum)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAlbum(_ sender: Any) {
        deleteAlert()
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
        return photoAlbum?.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newImageCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell()}
        let photo = photoAlbum?.photos?[indexPath.item]
        cell.cellImage.image = photo?.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailImageView", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailImageView",
            let indexPath = collectionView.indexPathsForSelectedItems?.first {
            let detailPhoto = PhotoController.sharedController.photos[indexPath.item]
            let destinationVC = segue.destination as? DetailImageViewController
            destinationVC?.detailPhoto = detailPhoto
        }
    }
}
