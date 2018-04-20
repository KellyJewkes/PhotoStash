//
//  CKManager.swift
//  Photo Stash
//
//  Created by Kelly Jewkes on 3/12/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import Foundation
import  CloudKit
import  UIKit

private let CreatorUserRecordIDKey = "creatorUserRecordID"

class CKManager {
    
    static let shared = CKManager()
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    init() {
        checkCloudKitAvailability()
    }
    
    
    func fetchLoggedInUserRecord(_ completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error,
                let completion = completion {
                completion(nil, error)
                
            }
            if let recordID = recordID,
                let completion = completion {
                
                self.fetchRecord(withID: recordID, database: self.publicDatabase, completion: completion)
            }
        }
    }
    
    func fetchRecordsWithType(_ type: String,
                              predicate: NSPredicate = NSPredicate(value: true),
                              recordFetchedBlock: ((_ record: CKRecord) -> Void)?,
                              completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        var fetchedRecords: [CKRecord] = []
        
        let query = CKQuery(recordType: type, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        let perRecordBlock = { (fetchedRecord: CKRecord) -> Void in
            fetchedRecords.append(fetchedRecord)
            recordFetchedBlock?(fetchedRecord)
        }
        queryOperation.recordFetchedBlock = perRecordBlock
        
        var queryCompletionBlock: (CKQueryCursor?, Error?) -> Void = { (_, _) in }
        
        queryCompletionBlock = { (queryCursor: CKQueryCursor?, error: Error?) -> Void in
            
            if let queryCursor = queryCursor {
                
                let continuedQueryOperation = CKQueryOperation(cursor: queryCursor)
                continuedQueryOperation.recordFetchedBlock = perRecordBlock
                continuedQueryOperation.queryCompletionBlock = queryCompletionBlock
                
                self.publicDatabase.add(continuedQueryOperation)
                
            } else {
                completion?(fetchedRecords, error)
            }
        }
        queryOperation.queryCompletionBlock = queryCompletionBlock
        
        self.publicDatabase.add(queryOperation)
    }
    
    
    func fetchRecord(withID recordID: CKRecordID, database: CKDatabase, completion:((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        database.fetch(withRecordID: recordID) { (record, error) in
            
            completion?(record, error)
        }
    }
    
    func delete(withRecordID recordID: CKRecordID,
                completionHandler: @escaping (CKRecordID?, Error?) -> Void) {
        
    }
    
    func deleteRecordWithID(_ recordID: CKRecordID, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        
        publicDatabase.delete(withRecordID: recordID) { (recordID, error) in
            completion?(recordID, error)
        }
    }
    
    
    func deleteRecordsWithID(_ recordIDs: [CKRecordID], database: CKDatabase, completion: ((_ records: [CKRecord]?, _ recordIDs: [CKRecordID]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
        operation.savePolicy = .ifServerRecordUnchanged
        
        operation.modifyRecordsCompletionBlock = completion
        
        database.add(operation)
    }
    
    
    func saveRecords(_ records: [CKRecord], database: CKDatabase, perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        modifyRecords(records, database: database, perRecordCompletion: perRecordCompletion, completion: completion)
    }
    
    
    func saveRecord(_ record: CKRecord, database: CKDatabase, completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        
        modifyRecords([record], database: database, perRecordCompletion: completion, completion: nil)
    }
    
    
    func modifyRecords(_ records: [CKRecord], database: CKDatabase, perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.perRecordCompletionBlock = perRecordCompletion
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) -> Void in
            completion?(records, error)
        }
        database.add(operation)
    }
    
    
    func checkCloudKitAvailability() {
        
        CKContainer.default().accountStatus() {
            (accountStatus: CKAccountStatus, error: Error?) -> Void in
            
            switch accountStatus {
            case .available:
                print("CloudKit available. Initializing sync.")
                return
            default:
                self.handleCloudKitUnavailble(accountStatus, error: error)
            }
        }
    }
    
    
    func handleCloudKitUnavailble(_ accountStatus: CKAccountStatus, error: Error?) {
        
        var errorText = "Sync is disabled"
        if let error = error {
            print("handleCloudKitUnavailablr ERROR: \(error), \(error.localizedDescription)")
            errorText += error.localizedDescription
        }
        
        switch  accountStatus {
        case .restricted:
            errorText += "iCloud is not available due to restrictions"
        case .noAccount:
            errorText += "There is no iCloud account setup. You can setup iCloud in the settings app."
        default:
            break
        }
        displayCloudKitNotAvailableError(errorText)
    }
    
    
    func displayCloudKitNotAvailableError(_ errorText: String) {
        
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "iCloud sync error", message: errorText, preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
            
            alertController.addAction(dismissAction)
            
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    func handleCloudKitPermissionStatus(_ permissionStatus: CKApplicationPermissionStatus, error: Error?) {
        if permissionStatus == .granted {
            print("User Discoverability permission granted. User may proceed with full access.")
        } else {
            var errorText = "Sync is disabled"
            if let error = error {
                print("handleCloudKitUnavailable ERROR: \(error), \(error.localizedDescription)")
                errorText += error.localizedDescription
            }
            switch permissionStatus {
            case .denied:
                errorText += "You have denied User Discoverability permissiojns. you be unable to use certai features of the app."
            case .couldNotComplete:
                errorText += "unable to verify User Discoverability permissions. You may have a connectivity issue. Please try again."
            default:
                break
            }
            displayCloudKitPermissionNotGrantedError(errorText)
        }
    }
    
    
    func displayCloudKitPermissionNotGrantedError(_ errorText: String) {
        
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "CloudKit Permission Error", message: errorText, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "ok", style: .cancel, handler: nil);
            
            alertController.addAction(dismissAction)
            
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    func requestDscoverabilityPermission() {
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (permissionStatus, error) in
            if permissionStatus == .initialState {
                CKContainer.default().requestApplicationPermission(.userDiscoverability, completionHandler: { (permissionStatus, error) in
                    self.handleCloudKitPermissionStatus(permissionStatus, error: error)
                    
                })
            }else{
                self.handleCloudKitPermissionStatus(permissionStatus, error: error)
            }
        }
    }
}

