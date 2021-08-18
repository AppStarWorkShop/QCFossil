//
//  Task.swift
//  QCFossil
//
//  Created by Yin Huang on 16/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class Task {
    var taskId:Int?
    var prodTypeId:Int?
    var inspectionTypeId:Int?
    var bookingNo:String?
    var bookingDate:String?
    var vdrLocationId:Int?
    var reportInspectorId:Int?
    var reportPrefix:String?
    var reportRunningNo:String?
    var inspectionNo:String?
    var inspectionDate:String?
    var taskRemarks:String?
    var vdrNotes:String?
    var inspectionResultValueId:Int?
    var inspectionSignImageFile:String?
    var vdrSignName:String?
    var vdrSignImageFile:String?
    var taskStatus:Int?
    var uploadInspectorId:Int?
    var uploadDeviceId:String?
    var refTaskId:Int?
    var recStatus:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var deleteFlag:Int?
    var deleteUser:String?
    var deleteDate:String?
    var inspectSetupId:Int?
    var shipWin:String?
    var vdrSignDate:String?
    var tmplId:Int?
    var opdRsd:String? //add 08222018
    var qcRemarks:String?
    var additionalAdministrativeItems:String?
    
    //extension
    var vendor:String?
    var vendorLocation:String?
    var brand:String?
    var style:String?
    var poNo:String?
    var inspectionType:String?
    var inspSections = [InspSection]()
    var dataRefuseDesc:String = ""
    var cancelDate:String = ""
    var didModify:Bool = false
    var didKeepPending:Bool = false
    var sortingNum:Int = 0
    var errorCode:Int = 0
    var prodDesc:String?
    var confirmUploadDate:String?
    
    //inspection result
    var inspCatResuts = [InspCatResult]()
    
    //po items
    var poItems = [PoItem]()
    
    //Photos
    var myPhotos = [Photo]()
    
    //Defect Items
    var defectItems = [TaskInspDefectDataRecord]()
    
    init?(taskId:Int,prodTypeId:Int,inspectionTypeId:Int,bookingNo:String,bookingDate:String,vdrLocationId:Int,reportInspectorId:Int,reportPrefix:String,reportRunningNo:String="",inspectionNo:String,inspectionDate:String,taskRemarks:String,vdrNotes:String,inspectionResultValueId:Int,inspectionSignImageFile:String?,vdrSignName:String,vdrSignImageFile:String?,taskStatus:Int,uploadInspectorId:Int,uploadDeviceId:String?,refTaskId:Int,recStatus:Int,createUser:String,createDate:String,modifyUser:String,modifyDate:String,deleteFlag:Int,deleteUser:String?,deleteDate:String?,inspectSetupId:Int=1,qcRemarks:String?,additionalAdministrativeItems:String?) {
        
        self.taskId = taskId
        self.prodTypeId = prodTypeId
        self.inspectionTypeId = inspectionTypeId
        self.bookingNo = bookingNo
        self.bookingDate = bookingDate
        self.vdrLocationId = vdrLocationId
        self.reportInspectorId = reportInspectorId
        self.reportPrefix = reportPrefix
        self.reportRunningNo = reportRunningNo
        self.inspectionNo = inspectionNo
        self.inspectionDate = inspectionDate
        self.taskRemarks = taskRemarks
        self.vdrNotes = vdrNotes
        self.inspectionResultValueId = inspectionResultValueId
        self.inspectionSignImageFile = inspectionSignImageFile
        self.vdrSignName = vdrSignName
        self.vdrSignImageFile = vdrSignImageFile
        self.taskStatus = taskStatus
        self.uploadInspectorId = uploadInspectorId
        self.uploadDeviceId = uploadDeviceId
        self.refTaskId = refTaskId
        self.recStatus = recStatus
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.deleteFlag = deleteFlag
        self.deleteUser = deleteUser
        self.deleteDate = deleteDate
        self.inspectSetupId = inspectSetupId
        self.qcRemarks = qcRemarks
        self.additionalAdministrativeItems = additionalAdministrativeItems
    }
}
