//
//  Hype.swift
//  HypeCloudKit
//
//  Created by Maxwell Poffenbarger on 2/4/20.
//  Copyright © 2020 Maxwell Poffenbarger. All rights reserved.
//

import Foundation
import CloudKit

struct HypeStrings {
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
    static let recordTypeKey = "Hype"
}//End of struct

class Hype {
    
    var body: String
    var timestamp: Date
    var recordID: CKRecord.ID
    
    init(body: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
    }
}//End of class

extension CKRecord {
    
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey, recordID: hype.recordID)
        
        self.setValuesForKeys([
            HypeStrings.bodyKey : hype.body,
            HypeStrings.timestampKey : hype.timestamp
        ])
    }
}//End of extension

extension Hype {
    
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
            let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
            else {return nil}
        self.init(body: body, timestamp: timestamp, recordID: ckRecord.recordID)
    }
}//End of extension

extension Hype: Equatable {
    static func == (lhs: Hype, rhs: Hype) -> Bool {
        lhs.recordID == rhs.recordID
    }
}//End of extension
