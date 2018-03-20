//
//  HomeViewController.swift
//  PhotoHub
//
//  Created by Kelly Jewkes on 3/5/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit
import CloudKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        CKContainer.default()
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navTitleImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    // MARK: - App Title Image
    func navTitleImage() {
        let navController = navigationController!
        
        //        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        //        navigationItem.leftBarButtonItem = backButton
        
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
    
    
    @IBAction func addNewStash(_ sender: Any) {
        addStashAlert()
        //self.tableView.reloadData()
    }
    
    
    // MARK: - Alert function
    func addStashAlert(){
        
        let alertController = UIAlertController(title: "Add a new Stash", message: "", preferredStyle: .alert)
        
        //textfild
        alertController.addTextField { (textField) in
            textField.placeholder = "Add new Stash..."
        }
        //save textfield
        let addStash = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
            let stashText = alertController.textFields?.first
            guard let stashAsString = stashText?.text else {return}
            PhotoAlbumController.shared.add(photoAlbumWithTitle: stashAsString)
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addStash)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotoAlbumController.shared.photoAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StashNameCell", for: indexPath)
        let photoAlbum = PhotoAlbumController.shared.photoAlbums[indexPath.row]
        cell.textLabel?.text = photoAlbum.title
        cell.detailTextLabel?.text = String(PhotoAlbumController.shared.photoAlbums.index(of: photoAlbum)! + 1)
        return cell
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCurrentPhotoAlbum",
            let indexPath = tableView.indexPathForSelectedRow {
            let photoAlbum = PhotoAlbumController.shared.photoAlbums[indexPath.row]
            let destinationVC = segue.destination as? StashImagesViewController
            destinationVC?.photoAlbum = photoAlbum
        }
    }
}
