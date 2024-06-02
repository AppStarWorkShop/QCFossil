//
//  InspSectionPosition.swift
//  QCFossil
//
//  Created by pacmobile on 27/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class InspSectionPosition {
    
    var positionId:Int?
    var inspectSetupId:Int?
    var positionCode:String?
    var positionNameEn:String?
    var positionNameCn:String?
    var positionNameFr:String?
    var prodTypeId:Int?
    var inspectTypeId:Int?
    var currentLevel:Int?
    var parentPositionId:Int?
    var displayOrder:Int?
    var recStatus:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var deletedFlag:Int?
    var deleteUser:String?
    var deleteDate:String?
    
    init(positionId:Int, inspectSetupId:Int, positionCode:String, positionNameEn:String, positionNameFr:String, positionNameCn:String, prodTypeId:Int, inspectTypeId:Int, currentLevel:Int, parentPositionId:Int, displayOrder:Int, recStatus:Int, createUser:String, createDate:String, modifyUser:String, modifyDate:String, deletedFlag:Int, deleteUser:String?, deleteDate:String?) {
        
        self.positionId = positionId
        self.inspectSetupId = inspectSetupId
        self.positionCode = positionCode
        self.positionNameEn = positionNameEn
        self.positionNameCn = positionNameCn
        self.positionNameFr = positionNameFr
        self.prodTypeId = prodTypeId
        self.inspectTypeId = inspectTypeId
        self.currentLevel = currentLevel
        self.parentPositionId = parentPositionId
        self.displayOrder = displayOrder
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
