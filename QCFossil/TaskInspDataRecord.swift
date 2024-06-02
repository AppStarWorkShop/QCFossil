//
//  TaskInspDataRecord.swift
//  QCFossil
//
//  Created by pacmobile on 2/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class TaskInspDataRecord {
    var recordId:Int?
    var taskId:Int?
    var refRecordId:Int?
    var inspectSectionId:Int?
    var inspectElementId:Int?
    var inspectPositionId:Int?
    var inspectPositionDesc:String?
    var inspectDetail:String?
    var inspectRemarks:String?
    var resultValueId:Int=0
    var requestSectionId:Int=0
    var requestElementDesc:String=""
    var inspectPositionZoneValueId:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var isPreSave: String?
    
    //Element Display Using 
    var sectObj:SectObj?
    var reqSectObj:SectObj?
    var elmtObj:ElmtObj?
    var postnObj:PositObj?
    var resultObj:ResultValueObj?
    
    init?(recordId:Int?=0, taskId:Int, refRecordId:Int?, inspectSectionId:Int, inspectElementId:Int, inspectPositionId:Int, inspectPositionDesc:String?, inspectDetail:String?, inspectRemarks:String?, resultValueId:Int, requestSectionId:Int, requestElementDesc:String, inspectPositionZoneValueId:Int?=nil, createUser:String="", createDate:String="", modifyUser:String="", modifyDate:String="", isPreSave: String? = nil) {
        
        self.recordId = recordId
        self.taskId = taskId
        self.refRecordId = refRecordId
        self.inspectSectionId = inspectSectionId
        self.inspectElementId = inspectElementId
        self.inspectPositionId = inspectPositionId
        self.inspectPositionDesc = inspectPositionDesc
        self.inspectDetail = inspectDetail
        self.inspectRemarks = inspectRemarks
        self.resultValueId = resultValueId
        self.requestSectionId = requestSectionId
        self.requestElementDesc = requestElementDesc
        self.inspectPositionZoneValueId = inspectPositionZoneValueId
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.isPreSave = isPreSave
    }
}
