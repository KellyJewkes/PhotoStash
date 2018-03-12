//
//  HomeViewController.swift
//  PhotoHub
//
//  Created by Kelly Jewkes on 3/5/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func addNewStash(_ sender: Any) {
        addStashAlert()
        self.tableView.reloadData()
    }
    
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotoAlbumController.shared.photoAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StashNameCell", for: indexPath)
        let photoAlbum = PhotoAlbumController.shared.photoAlbums[indexPath.row]
        
        cell.textLabel?.text = photoAlbum.title
        
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
