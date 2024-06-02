//
//  DataHelperMaster.swift
//  QCFossil
//
//  Created by Yin Huang on 1/3/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class DataHelperMaster {
    var db = DatabaseManager.sharedDatabaseManager.db
    
    func notNilObject(_ value : AnyObject?) -> AnyObject? {
        if value == nil {
            return NSNull()
        } else {
            return value
        }
    }
}
