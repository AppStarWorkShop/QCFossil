//
//  VdrLoc.swift
//  QCFossil
//
//  Created by pc01 on 24/2/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class VdrLoc {
    
    var dataEnv:Int?
    var locationId:Int?
    var vdrId:Int?
    var locationCode:String?
    var locationName:String?
    var recStatus:String?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var deletedFlag:Int?
    var deleteUser:String?
    var deleteDate:String?
    
    init(dataEnv:Int?,locationId:Int?,vdrId:Int?,locationCode:String?,locationName:String?,recStatus:String?,createUser:String?,createDate:String?,modifyUser:String?,modifyDate:String?,deletedFlag:Int?,deleteUser:String?,deleteDate:String?) {
        
        self.dataEnv = dataEnv
        self.locationId = locationId
        self.vdrId = vdrId
        self.locationCode = locationCode
        self.locationName = locationName
        self.recStatus = recStatus
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.deletedFlag = deletedFlag
        self.deleteUser = deleteUser
        self.deleteDate = deleteDate
        
    }
    
}