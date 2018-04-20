//
//  DetailImageViewController.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/14/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit
import CloudKit

class DetailImageViewController: UIViewController {
    
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    
    var detailPhoto: Photo?
    
    func updateViews() {
        detailImageView.image = detailPhoto?.image
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailImageView.image = detailPhoto?.image
        updateViews()
    }
    
    
    // -------------------------------------------------
    // MARK: - Buttons
    // -------------------------------------------------

    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteAlert()
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let image = detailImageView.image else {return}
        let photoToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: photoToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        guard let currentPhoto = detailImageView.image else {return}
        UIImageWriteToSavedPhotosAlbum(currentPhoto, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    func deleteAlert(){
        
        let alertController = UIAlertController(title: "Delete this photo", message: "Warning! This can not be undone!", preferredStyle: .alert)
        
        let deleteAlbum = UIAlertAction(title: "DELETE", style: .destructive, handler:{(action: UIAlertAction)-> Void in
            
            guard let record = self.detailPhoto?.cloudKitRecordID else {return}
            
            CKManager.shared.deleteRecordWithID(record, completion: { (record, error) in
                if let error = error {
                    print("Error deleting a single photo \(error)")
                } else {
                    if record != nil {
                        print("Photo was deleted")
                    }
                }
            })
            
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
}
