//
//  StashImagesViewController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit
import CloudKit

class StashImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photoAlbum: PhotoAlbum?
    var photos: [Photo] = []
    var photoAlbums: [PhotoAlbum] = []
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var stashNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var holderView: UIView!
    
    // -------------------------------------------------
    // MARK: - Life-Cycle
    // -------------------------------------------------
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    
    override func viewDidLoad() {
        //navTitleImage()
        fetchImages()
        super.viewDidLoad()
        holderView.clipsToBounds = true
        holderView.layer.cornerRadius = 20
        stashNameLabel.text = photoAlbum?.title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        checkAlbumAndUser()
        collectionView.reloadData()
    }
    
    
    // -------------------------------------------------
    // MARK: - Invite & share button
    // -------------------------------------------------
    
    @IBAction func inviteButtonTapped(_ sender: Any) {
        let shareVC = UIActivityViewController(activityItems: ["link to this album"], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
    
    
    // -------------------------------------------------
    // MARK: - Add new image button (camera & photo library)
    // -------------------------------------------------
    
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        CameraPhotoHandler.shared.showActionSheet(vc: self)
        CameraPhotoHandler.shared.imagePickedBlock = { (image) in
            //DispatchQueue.main.async {
            PhotoController.sharedController.createPhotoWith(image: image, completion: { (photo) in
            
            })
            
                self.collectionView.reloadData()
            }
       
    }
    
    
    
    // -------------------------------------------------
    // MARK: - Delete PhotoAlbum
    // -------------------------------------------------
    
    
    func deleteAlert(){
        
        let alertController = UIAlertController(title: "Delete this album", message: "Warning! This can not be undone!", preferredStyle: .alert)
        
        let deleteAlbum = UIAlertAction(title: "DELETE", style: .destructive, handler:{(action: UIAlertAction)-> Void in
            //guard let photoAlbum = self.photoAlbum else {return}
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
    
    
    // -------------------------------------------------
    // MARK: - Mustache title image function
    // -------------------------------------------------
    
    
//    func navTitleImage() {
//        let navController = navigationController!
//        
//        self.navigationItem.setHidesBackButton(true, animated: false)
//        
//        let image = #imageLiteral(resourceName: "finalStache")
//        let imageView = UIImageView(image: image)
//        
//        let bannerWidth = navController.navigationBar.frame.size.width
//        let bannerHeight = navController.navigationBar.frame.size.height
//        
//        let bannerX = bannerWidth / 2 - image.size.width / 2
//        let bannerY = bannerHeight / 2 - image.size.height / 2
//        
//        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth * 2, height: bannerHeight * 2)
//        imageView.contentMode = .scaleAspectFit
//        
//        navigationItem.titleView = imageView
//    }
    
    
    func fetchImages(){
        PhotoController.sharedController.photos.removeAll()
        let predicate = NSPredicate(value: true)
        //let sort = NSSortDescriptor(key: "foo", ascending: foo)
        let query = CKQuery(recordType: "Photo", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        //operation.desiredKeys = []
        operation.resultsLimit = 100
        
        var albumPhotos = PhotoController.sharedController.photos
        
        operation.recordFetchedBlock = { record in
            print("This is the photo record \(record)")
            
            guard let thisPhoto = Photo(record: record) else {return}
            
            print("this is the photo data \(String(describing: thisPhoto.imageData))")
            
            albumPhotos.append(thisPhoto)
            
        }
        operation.queryCompletionBlock = { cursor, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Photo fetch failed \(error)")
                } else {
                    PhotoController.sharedController.photos = albumPhotos
                    print("These are the album's photos \(albumPhotos)")
                    self.collectionView.reloadData()
                    self.activityInd.isHidden = true
                }
            }
        }
    CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    // -------------------------------------------------
    // MARK: - Collection View Functions
    // -------------------------------------------------
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("This is how many photos are in the album \(String(describing: PhotoController.sharedController.photos.count))")
        return PhotoController.sharedController.photos.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newImageCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell()}
        let photo = PhotoController.sharedController.photos[indexPath.item]
        cell.cellImage.image = photo.image
        return cell
    }
    
    func checkAlbumAndUser(){
        guard let currentAlbum = PhotoAlbumController.sharedController.photoAlbum?.title else {return}
        guard let currentUser = UserController.sharedController.currentUser?.username else {return}
        print("the current album is \(currentAlbum) & the current user is \(currentUser)")
    }
    
    
    // -------------------------------------------------
    // MARK: - Segue
    // -------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailImageView",
            let indexPath = collectionView.indexPathsForSelectedItems?.first {
            let detailPhoto = PhotoController.sharedController.photos[indexPath.item]
            let destinationVC = segue.destination as? DetailImageViewController
            destinationVC?.detailPhoto = detailPhoto
        }
    }
}
