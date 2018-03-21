//
//  Photo.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/6/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

//class Photo: Equatable {
//
//    init (image: UIImage) {
//        self.image = image
//    }
//
//    let image: UIImage
//    }
//
//
//    func ==(lhs: Photo, rhs: Photo) -> Bool {
//        return lhs.image == rhs.image
//}

class Photo: Equatable {
    
    
    
    // reusable keys
    static let typeKey = "Photo"
    static let imageDataKey = "imageData"
    
    let imageData: Data?
    
    // computed property for image from data
    var image: UIImage? {
        guard let imageData = self.imageData else {return nil}
        return UIImage(data: imageData)
    }
    
    var cloudKitRecordID: CKRecordID?
    
    init(imageData: Data?) {
        self.imageData = imageData
    }
    
    convenience required init?(record: CKRecord) {
        
        // creating the CKAsset from the image data
        guard let imageAsset = record[Photo.imageDataKey] as? CKAsset else { return nil }
        
        
        let imageData = try? Data(contentsOf: imageAsset.fileURL)
        self.init(imageData: imageData)
        cloudKitRecordID = record.recordID
    }
    
    
    var recordType: String {return Photo.typeKey }
    
    var cloudKitRecord: CKRecord {
        
        // it is going to check if the cloudKitRecordID is already in the clud AND IF NOT if will create a new uuid! cool!
        let recordID = cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Photo.imageDataKey] = CKAsset(fileURL: temporaryImageURL)
        
        // this record uses the temp URLfilepath of the image
        return record
    }
    
    fileprivate var temporaryImageURL: URL {
        
        // create a temporary directory to send image url to CKAsset
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? imageData?.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
}

func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.image == rhs.image

}


