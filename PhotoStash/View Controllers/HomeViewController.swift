
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
    
    var photoAlbums = [PhotoAlbum]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // -------------------------------------------------
    // MARK: - View-Cycles
    // -------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        //navTitleImage()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = UserController.sharedController.currentUser else {return}
        CKContainer.default()
        fetchAlbums()
        // tableView.clipsToBounds = true
        // tableView.layer.cornerRadius = 20
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //navTitleImage()
        print("this is the current user- \(currentUser.username)")
    }
    
    // -------------------------------------------------
    // MARK: - Fetch User's Albums
    // -------------------------------------------------
    
    func fetchAlbums() {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "title", ascending: true)
        let query = CKQuery(recordType: "PhotoAlbum", predicate: predicate)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title"]
        //operation.resultsLimit = 10
        
        var userAlbums = [PhotoAlbum]()
        
        
        operation.recordFetchedBlock = { record in
            
            guard let album = PhotoAlbumController.sharedController.photoAlbum else {return}
            album.cloudKitRecordID = record.recordID
            album.title = record["title"] as! String
            userAlbums.append(album)
            
            operation.queryCompletionBlock = { [unowned self] (cursor, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        self.photoAlbums = userAlbums
                        print("these are the new albums\(userAlbums)")
                        self.tableView.reloadData()
                    } else {
                        print("Fetch Failed")
                    }
                }
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    // -------------------------------------------------
    // MARK: - Mustache title image function
    // -------------------------------------------------
    
    //    func navTitleImage() {
    //        let navController = navigationController!
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
    
    
    // -------------------------------------------------
    // MARK: - Add Photo Album Alert Function
    // -------------------------------------------------
    
    @IBAction func addNewStash(_ sender: Any) {
        addStashAlert()
        self.tableView.reloadData()
    }
    
    
    func addStashAlert(){
        
        let alertController = UIAlertController(title: "Add a new Stache", message: "", preferredStyle: .alert)
        
        //textfild
        alertController.addTextField { (textField) in
            textField.placeholder = "Add a new Stache..."
        }
        //save textfield
        let addStash = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
            let stashText = alertController.textFields?.first
            guard let stacheAsString = stashText?.text else {return}
            PhotoAlbumController.sharedController.createPhotoAlbumWith(title: stacheAsString, completion: { (_) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            print(PhotoAlbumController.sharedController.photoAlbums.count)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addStash)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // -------------------------------------------------
    // MARK: - Table View Functions
    // -------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotoAlbumController.sharedController.photoAlbums.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StashNameCell", for: indexPath)
        let photoAlbum = PhotoAlbumController.sharedController.photoAlbums[indexPath.row]
        cell.textLabel?.text = photoAlbum.title
        return cell
    }
    
    // -------------------------------------------------
    // MARK: - Segue
    // -------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCurrentPhotoAlbum",
            let indexPath = tableView.indexPathForSelectedRow {
            let photoAlbum = PhotoAlbumController.sharedController.photoAlbums[indexPath.row]
            let destinationVC = segue.destination as? StashImagesViewController
            destinationVC?.photoAlbum = photoAlbum
        }
    }
}
