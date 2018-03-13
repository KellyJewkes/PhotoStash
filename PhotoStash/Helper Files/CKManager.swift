//
//  CKManager.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/12/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import  CloudKit

class CKManager {
    
    func fetchUserRecordID(completion: @escaping((CKRecordID?, Error?) -> Void )) {
        CKContainer.default().fetchUserRecordID(completionHandler: completion)
    }
    
    func save(user: User, completion: @escaping((CKRecord?, Error?) -> Void )) {
        let record = CKRecord(user: user)
        CKContainer.default().sharedCloudDatabase.save(record, completionHandler: completion)
    }
    
}
