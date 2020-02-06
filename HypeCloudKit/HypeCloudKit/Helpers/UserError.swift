//
//  UserError.swift
//  HypeCloudKit
//
//  Created by Maxwell Poffenbarger on 2/6/20.
//  Copyright © 2020 Maxwell Poffenbarger. All rights reserved.
//

import Foundation

enum UserError: LocalizedError {
    
    case ckError(Error)
    case noUserLoggedIn
    case couldNotUnwrap
    
}

