//
//  TaskInspector.swift
//  QCFossil
//
//  Created by pacmobile on 2/11/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class TaskInspector {
    var inspectorId:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var inspectEnableFlag:Int?
    var taskId:Int?
    
    init(inspectorId:Int, createUser:String?, createDate:String?, modifyUser:String?, modifyDate:String?, inspectEnableFlag:Int, taskId:Int?) {
        
        self.inspectorId = inspectorId
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.inspectEnableFlag = inspectEnableFlag
        self.taskId = taskId
    }
}

struct ProdType {
    var typeId:String?
    var typeCode:String?
    var typeNameEn:String?
    var typeNameCn:String?
    var typeNameFr:String?
    var dataEnv:String?
    var recStatus:String?
    var createDate:String?
    var createUser:String?
    var modifyDate:String?
    var modifyUser:String?
    var deletedFlag:String?
    var deleteDate:String?
    var deleteUser:String?
    
    init() {
        
    }
//    init(typeId:String?, typeCode:String?, typeNameEn:String?, typeNameCn:String?, dataEnv:String?, recStatus:String?, createDate:String?, createUser:String?, modifyDate:String?, modifyUser:String?, deletedFlag:String?, deleteDate:String?, deleteUser:String?) {
//        self.typeId = typeId
//        self.typeCode = typeCode
//        self.typeNameEn = typeNameEn
//        self.typeNameCn = typeNameCn
//        self.dataEnv = dataEnv
//        self.recStatus = recStatus
//        self.createDate = createDate
//        self.createUser = createUser
//        self.modifyDate = modifyDate
//        self.modifyUser = modifyUser
//        self.deletedFlag = deletedFlag
//        self.deleteDate = deleteDate
//        self.deleteUser = deleteUser
//    }
}
