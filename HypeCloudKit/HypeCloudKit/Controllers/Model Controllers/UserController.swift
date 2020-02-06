//
//  UserController.swift
//  HypeCloudKit
//
//  Created by Maxwell Poffenbarger on 2/6/20.
//  Copyright © 2020 Maxwell Poffenbarger. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    //MARK: - Properties
    let publicDB = CKContainer.default().publicCloudDatabase
    
    static let sharedInstance = UserController()
    
    var currentUser: User?
    
    //MARK: - CRUD Functions
    func createUserWith(username: String, completion: @escaping (_ result: Result<User?, UserError>) -> Void) {
        
        fetchAppleUserReference { (reference) in
            guard let reference = reference else {return completion(.failure(.noUserLoggedIn))}
            
            let newUser = User(username: username, appleUserRef: reference)
            
            let record = CKRecord(user: newUser)
            
            self.publicDB.save(record) { (record, error) in
                
                if let error = error {
                    print(error, error.localizedDescription)
                    completion(.failure(.ckError(error)))
                }
                guard let record = record,
                let savedUser = User(ckRecord: record)
                    else {return completion(.failure(.couldNotUnwrap))}
                self.currentUser = savedUser
                print("created user: \(record.recordID.recordName) successfully")
                completion(.success(savedUser))
            }
        }
        //_191733211b868f89a77a006f267d7024
    }
    
    func fetchUser(completion: @escaping (Result<User?, UserError>) -> Void) {
        
        fetchAppleUserReference { (reference) in
            guard let reference = reference else {return completion(.failure(.noUserLoggedIn))}
            
            let predicate = NSPredicate(format: "%K == %@", argumentArray:[UserStrings.appleUserRefKey, reference])
            
            let query = CKQuery(recordType: UserStrings.userRecordTypeKey, predicate: predicate)
            
            self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print(error, error.localizedDescription)
                    completion(.failure(.ckError(error)))
                }
                
                guard let record = records?.first,
                    let foundUser = User(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
                
                print("fetched user successfully")
                completion(.success(foundUser))
            }
        }
    }
    
    private func fetchAppleUserReference(completion: @escaping (_ reference: CKRecord.Reference?) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print(error, error.localizedDescription)
                completion(nil)
            }
            
            if let recordID = recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                completion(reference)
            }
        }
    }
    
    func updateUser() {
        
    }
    
    func deleteUser() {
        
    }
    
}//End of class
