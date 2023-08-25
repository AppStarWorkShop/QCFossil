//
//  InspSection.swift
//  QCFossil
//
//  Created by pacmobile on 26/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class InspSection {
    var taskId:Int?
    var sectionId:Int?
    var inspectSetupId:Int?
    var sectionNameEn:String?
    var sectionNameCn:String?
    var sectionNameFr:String?
    var prodTypeId:Int?
    var inspectTypeId:Int?
    var displayOrder:Int?
    var resultSetId:Int?
    var inputModeCode:String?
    var optionalEnableFlag:Int?
    var adhocSelectFlag:Int?
    var recStatus:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var deletedFlag:Int?
    var deleteUser:String?
    var deleteDate:String?
    //extension
    var taskInspDataRecords = [TaskInspDataRecord]()
    
    init(taskId:Int, sectionId:Int, inspectSetupId:Int, sectionNameEn:String, sectionNameCn:String, sectionNameFr: String?, prodTypeId:Int, inspectTypeId:Int, displayOrder:Int, resultSetId:Int, inputModeCode:String, optionalEnableFlag:Int, adhocSelectFlag:Int, recStatus:Int, createUser:String, createDate:String, modifyUser:String, modifyDate:String, deletedFlag:Int, deleteUser:String?, deleteDate:String?) {
        
        self.taskId = taskId
        self.sectionId = sectionId
        self.inspectSetupId = inspectSetupId
        self.sectionNameEn = sectionNameEn
        self.sectionNameCn = sectionNameCn
        self.sectionNameFr = sectionNameFr ?? ""
        self.prodTypeId = prodTypeId
        self.inspectTypeId = inspectTypeId
        self.displayOrder = displayOrder
        self.resultSetId = resultSetId
        self.inputModeCode = inputModeCode
        self.optionalEnableFlag = optionalEnableFlag
        self.adhocSelectFlag = adhocSelectFlag
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
