//
//  Brand.swift
//  QCFossil
//
//  Created by pacmobile on 25/10/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class Brand {
    
    var dataEnv:Int?
    var brandId:Int?
    var brandCode:String?
    var brandName:String?
    var recStatus:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var deletedFlag:Int?
    var deleteUser:String?
    var deleteDate:String?
    init(dataEnv:Int?,brandId:Int?,brandCode:String?,brandName:String?,recStatus:Int?,createUser:String?,createDate:String?,modifyUser:String?,modifyDate:String?,deletedFlag:Int?,deleteUser:String?,deleteDate:String?) {
        
        self.dataEnv = dataEnv
        self.brandId = brandId
        self.brandCode = brandCode
        self.brandName = brandName
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