//
//  CameraPhotoHandler.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/8/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import AVFoundation
import MobileCoreServices
import Photos

class CameraPhotoHandler: NSObject {
    
    static let shared = CameraPhotoHandler()
    let myPickerController = UIImagePickerController()
    fileprivate var currentVC: UIViewController?
    
    
    var imagePickedBlock: ((UIImage) -> Void)?
    
    
    // MARK: - to access camera
    func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: - to access photo library
    func usePhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            currentVC?.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //    func useVideoLibrabry(){
    //        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
    //            myPickerController.delegate = self
    //            myPickerController.sourceType = .photoLibrary
    //            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
    //            currentVC?.present(myPickerController, animated: true, completion: nil)
    //        }
    //    }
    
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let cameraPhotoActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        cameraPhotoActionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction) -> Void in
            self.useCamera()
            
        }))
        cameraPhotoActionSheet.addAction(UIAlertAction(title: "Your Photos", style: .default, handler: { (alert:UIAlertAction) -> Void in
            self.usePhotoLibrary()
        }))
        
//        cameraPhotoActionSheet.addAction(UIAlertAction(title: "Your videos", style: .default, handler: { (alert:UIAlertAction) -> Void in
//            self.useVideoLibrabry()
//        }))
        
        cameraPhotoActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(cameraPhotoActionSheet, animated: true, completion: nil)
    }
}


extension CameraPhotoHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }else{
            print("Something went wrong")
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
}




