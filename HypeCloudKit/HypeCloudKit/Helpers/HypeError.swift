//
//  HypeError.swift
//  HypeCloudKit
//
//  Created by Maxwell Poffenbarger on 2/4/20.
//  Copyright © 2020 Maxwell Poffenbarger. All rights reserved.
//

import Foundation


enum HypeError: LocalizedError {
    
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecordsFound
    case noUserLoggedIn
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
            
        case .couldNotUnwrap:
            return "Unable to get this Hype"
            
        case .unexpectedRecordsFound:
            return "Unexpected records were returned when trying to delete"
            
        case .noUserLoggedIn:
            return "No user logged in"
        }
    }
}
