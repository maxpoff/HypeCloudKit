//
//  User.swift
//  HypeCloudKit
//
//  Created by Maxwell Poffenbarger on 2/6/20.
//  Copyright © 2020 Maxwell Poffenbarger. All rights reserved.
//

import Foundation
import CloudKit

struct UserStrings {
    static let userRecordTypeKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let bioKey = "bio"
    static let appleUserRefKey = "appleUserRef"
}//End of struct

class User {
    
    var username: String
    var bio: String
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    
    init(username: String, bio: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        self.username = username
        self.bio = bio
        self.recordID = recordID
        self.appleUserRef = appleUserRef
    }
}//End of class

extension User {
    
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.usernameKey] as? String,
            let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference
        else {return nil}
        
        self.init(username: username, recordID: ckRecord.recordID, appleUserRef: appleUserRef)
    }
}//End of extension

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}//End of extension

extension CKRecord {
    
    convenience init(user: User) {
        self.init(recordType: UserStrings.userRecordTypeKey, recordID: user.recordID)
        
        self.setValuesForKeys([
            UserStrings.usernameKey : user.username,
            UserStrings.bioKey : user.bio,
            UserStrings.appleUserRefKey : user.appleUserRef
        ])
    }
}//End of extension
