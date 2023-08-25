//
//  TaskInspPosinPoint.swift
//  QCFossil
//
//  Created by Yin Huang on 22/3/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class TaskInspPosinPoint{
    var inspRecordId:Int
    var inspPosinId:Int
    var createUser:String
    var createDate:String
    var modifyUser:String
    var modifyDate:String
    
    init?(inspRecordId:Int, inspPosinId:Int, createUser:String, createDate:String, modifyUser:String, modifyDate:String) {
        
        self.inspRecordId = inspRecordId
        self.inspPosinId = inspPosinId
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
    }
    
}