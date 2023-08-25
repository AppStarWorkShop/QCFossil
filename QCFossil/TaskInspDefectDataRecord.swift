//
//  TaskInspDefectDataRecord.swift
//  QCFossil
//
//  Created by Yin Huang on 24/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

//
//  TaskInspDefectDataRecord.swift
//  QCFossil
//
//  Created by pc01 on 24/2/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class TaskInspDefectDataRecord {
    
    var recordId:Int?
    var taskId:Int?
    var inspectRecordId:Int?
    var refRecordId:Int?
    var inspectElementId:Int?
    var defectDesc:String?
    var defectQtyCritical:Int=0
    var defectQtyMajor:Int=0
    var defectQtyMinor:Int=0
    var defectQtyTotal:Int=0
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var inspectElementDefectValueId:Int?
    var inspectElementCaseValueId:Int?
    var defectType:String?
    var defectRemarksOptionList:String?
    var othersRemark:String?
    var isPreSave: String?
    
    //Element Display Using
    var sectObj:SectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "", sectionNameFr: "", inputMode: "")
    var elmtObj:ElmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", elementNameFr:"", reqElmtFlag: 0)
    var postnObj:PositObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"", positionNameFr: "")
    var defectpositionPoints = ""
    
    //UI Obj
    var inputMode:String?
    var inspElmt:InputModeICMaster = InputModeICMaster()
    var photoObjs:[Photo]?
    var photoNames:[String]?
    var cellIdx:Int = 0
    var sortNum:Int = 0
    
    init?(recordId:Int?=0,taskId:Int, inspectRecordId:Int?, refRecordId:Int?, inspectElementId:Int?, defectDesc:String?, defectQtyCritical:Int=0, defectQtyMajor:Int=0, defectQtyMinor:Int=0, defectQtyTotal:Int=0, createUser:String?="", createDate:String?="", modifyUser:String?="", modifyDate:String?="", inspectElementDefectValueId:Int?=0, inspectElementCaseValueId:Int?=0, defectRemarksOptionList:String?="", othersRemark:String?="", isPreSave: String? = nil) {
        
        self.recordId = recordId
        self.taskId = taskId
        self.inspectRecordId = inspectRecordId
        self.refRecordId = refRecordId
        self.inspectElementId = inspectElementId
        self.defectDesc = defectDesc
        self.defectQtyCritical = defectQtyCritical
        self.defectQtyMajor = defectQtyMajor
        self.defectQtyMinor = defectQtyMinor
        self.defectQtyTotal = defectQtyTotal
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.inspectElementDefectValueId = inspectElementDefectValueId
        self.inspectElementCaseValueId = inspectElementCaseValueId
        self.defectRemarksOptionList = defectRemarksOptionList
        self.othersRemark = othersRemark
        self.isPreSave = isPreSave
    }
    
}
