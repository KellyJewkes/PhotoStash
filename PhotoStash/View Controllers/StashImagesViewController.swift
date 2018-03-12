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
    
    @IBOutlet weak var stashNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stashNameLabel.text = photoAlbum?.title

    }
    
    
    @IBAction func inviteButtonTapped(_ sender: Any) {
      let shareVC = UIActivityViewController(activityItems: ["link to this album"], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        
        self.present(shareVC, animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        CameraPhotoHandler.shared.showActionSheet(vc: self)
        CameraPhotoHandler.shared.imagePickedBlock = { (image) in
            
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoController.shared.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newImageCell", for: indexPath) as? UICollectionViewCell {
            
            cell.
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
