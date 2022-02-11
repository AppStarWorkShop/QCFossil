//
//  TaskDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 26/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class TaskDataHelper:DataHelperMaster{
    
    func getAllTaskItems() ->[TaskItem]? {
        //let sql = "SELECT iti.* FROM inspect_task_item iti INNER JOIN inspect_task_inspector iti2 ON iti.task_id = iti2.task_id WHERE iti2.inspector_id = ? GROUP BY iti.task_id ORDER BY iti.modify_date DESC"
        let sql = "SELECT iti.* FROM inspect_task_item iti INNER JOIN inspect_task_inspector iti2 ON iti.task_id = iti2.task_id INNER JOIN inspect_task it ON iti.task_id = it.task_id WHERE iti2.inspector_id = ? GROUP BY iti.task_id ORDER BY iti.modify_date DESC"
        var taskItems = [TaskItem]()
        
        if db.open() {
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.inspectorId)!]) {
            
            while rs.next() {
                let taskId = Int(rs.int(forColumn: "task_id"))
                let poItemId = Int(rs.int(forColumn: "po_item_id"))
                let targetInspectQty = Int(rs.int(forColumn: "target_inspect_qty"))
                let availInspectQty = Int(rs.int(forColumn: "avail_inspect_qty"))
                let inspectEnableFlag = Int(rs.int(forColumn: "inspect_enable_flag"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let samplingQty = Int(rs.int(forColumn: "sampling_qty"))
                
                let taskItem = TaskItem(taskId: taskId, poItemId: poItemId, targetInspectQty: targetInspectQty, availInspectQty: availInspectQty, inspectEnableFlag: inspectEnableFlag, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, samplingQty: samplingQty)
                
                taskItems.append(taskItem)
            }
            }
            
            db.close()
            
            return taskItems
        }
        
        return nil
    }
    
    func getTaskById(_ taskId:Int) ->Task? {
        let sql = "SELECT * FROM inspect_task WHERE task_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var task:Task!
        
        //extension
        var inspTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
            if rs.next() {
                let taskId = Int(rs.int(forColumn: "task_id"))
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectionTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let bookingNo = rs.string(forColumn: "booking_no")
                var bookingDate = rs.string(forColumn: "booking_date")
                let vdrLocationId = Int(rs.int(forColumn: "vdr_location_id"))
                let reportInspectorId = Int(rs.int(forColumn: "report_inspector_id"))
                let reportPrefix = rs.string(forColumn: "report_prefix")
                let inspectionNo = rs.string(forColumn: "inspection_no")
                var inspectionDate = rs.string(forColumn: "inspection_date")
                let taskRemarks = rs.string(forColumn: "task_remarks")
                let vdrNotes = rs.string(forColumn: "vdr_notes")
                let inspectionResultValueId = Int(rs.int(forColumn: "inspect_result_value_id"))
                let inspectionSignImageFile = rs.string(forColumn: "inspector_sign_image_file")
                let vdrSignName = rs.string(forColumn: "vdr_sign_name")
                let vdrSignImageFile = rs.string(forColumn: "vdr_sign_image_file")
                let taskStatus = Int(rs.int(forColumn: "task_status"))
                let uploadInspectorId = Int(rs.int(forColumn: "upload_inspector_id"))
                let uploadDeviceId = rs.string(forColumn: "upload_device_id")
                let refTaskId = Int(rs.int(forColumn: "ref_task_id"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deleteFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                let tmplId = Int(rs.int(forColumn: "tmpl_id"))
                var cancelDate = rs.string(forColumn: "cancel_date")
                let dataRefuseDesc = rs.string(forColumn: "data_refuse_desc")
                let qcRemarks = rs.string(forColumn: "qc_remarks_option_list")
                let additionalAdministrativeItems = rs.string(forColumn: "additional_admin_item_option_list")
                let confirmUploadDate = rs.string(forColumn: "confirm_upload_date")
                
                if bookingDate != nil && bookingDate != "" {
                    let bookingDateTmp = bookingDate
                    let bookingDateTmpArray = bookingDateTmp?.characters.split{$0 == " "}.map(String.init)
                    
                    if bookingDateTmpArray?.count>0 {
                        bookingDate = bookingDateTmpArray?[0]
                        
                        let dateFormatter:DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = _DATEFORMATTER
                        if let stringDate = dateFormatter.date(from: bookingDate!) {
                            bookingDate = dateFormatter.string(from: stringDate)
                        }
                    }
                }
                
                if inspectionDate != nil {
                    let inspectionDateTmp = inspectionDate
                    let inspectionDateTmpArray = inspectionDateTmp?.characters.split{$0 == " "}.map(String.init)
                    
                    if inspectionDateTmpArray?.count>0 {
                        inspectionDate = inspectionDateTmpArray?[0]
                        
                        let dateFormatter:DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = _DATEFORMATTER
                        
                        if let stringDate = dateFormatter.date(from: inspectionDate!) {
                            inspectionDate = dateFormatter.string(from: stringDate)
                        }
                    }
                }
                
                if cancelDate == nil {
                    cancelDate = ""
                }
                
                var sortingNum = 0
                if bookingNo != nil {
                    let bookingNoTmp = bookingNo
                    let bookingNoTmpArray = bookingNoTmp?.characters.split{$0 == "-"}.map(String.init)
                    
                    if bookingNoTmpArray?.count > 1 {
                        if Int((bookingNoTmpArray?[1])!) != nil {
                            sortingNum = Int((bookingNoTmpArray?[1])!)!
                        }
                    
                    }
                }
                
                //extension
                inspTypeId = inspectionTypeId
                
                task = Task(taskId: taskId, prodTypeId: prodTypeId, inspectionTypeId: inspectionTypeId, bookingNo: bookingNo!, bookingDate: bookingDate!, vdrLocationId: vdrLocationId, reportInspectorId: reportInspectorId, reportPrefix: reportPrefix!, inspectionNo: inspectionNo!, inspectionDate: inspectionDate!, taskRemarks: taskRemarks!, vdrNotes: vdrNotes!, inspectionResultValueId: inspectionResultValueId, inspectionSignImageFile: inspectionSignImageFile, vdrSignName: vdrSignName!, vdrSignImageFile: vdrSignImageFile, taskStatus: taskStatus, uploadInspectorId: uploadInspectorId, uploadDeviceId: uploadDeviceId, refTaskId: refTaskId, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deleteFlag: deleteFlag, deleteUser: deleteUser, deleteDate: deleteDate, qcRemarks: qcRemarks, additionalAdministrativeItems: additionalAdministrativeItems)
                
                task.tmplId = tmplId
                task.cancelDate = cancelDate!
                task.dataRefuseDesc =  dataRefuseDesc == nil ? "" : dataRefuseDesc!
                task.sortingNum = sortingNum
                task.confirmUploadDate = confirmUploadDate
            }
            }
            
            db.close()
        }
        
        //extension
        if task != nil {
        let poDataHelper = PoDataHelper()
        task.poItems = poDataHelper.getPoByTaskId(taskId)
        
        let vendorDataHelper = VendorDataHelper()
        task.vendorLocation = vendorDataHelper.getVdrLocationCodeById(task.vdrLocationId ?? 0)
            
        if task.poItems.count>0 {
            let poItem = task.poItems[0]
            
            task.vendor = poItem.vdrDisplayName
            task.brand = poItem.brandName
            task.style = poItem.styleNo
            task.shipWin = poItem.shipWin
            task.opdRsd = poItem.opdRsd
            
            /*
            var poNo = poItem.poNo
            if task.poItems.count>1 {
                for idx in 1...task.poItems.count-1 {
                    poNo! += ","+task.poItems[idx].poNo!
                }
            }*/
            
            var poNos = [String]()
            for poNo in task.poItems {
                if poNo.isEnable == 1 || task.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue || (task.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && task.cancelDate != "") {
                    poNos.append(poNo.poNo!)
                }
            }
            
            var shipWins = [String]()
            for poItem in task.poItems {
                if poItem.isEnable == 1 || task.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue || (task.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && task.cancelDate != "") {
                    shipWins.append(poItem.shipWin)
                }
            }
            
            var opdRsds = [String]()
            for poItem in task.poItems {
                if poItem.isEnable == 1 || task.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue || (task.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && task.cancelDate != "") {
                    opdRsds.append(poItem.opdRsd)
                }
            }
            
            if poItem.dimen2 != nil && poItem.prodDesc != nil {
                let prodDesc = "\(poItem.dimen2!) / \(poItem.prodDesc!)"
//                let prodDesc = "\(poItem.styleNo!) / \(poItem.dimen1!)"
                task.prodDesc = prodDesc
            }
            
            var uniquePoNos = Array(Set(poNos))
            var uniqueShipWins = Array(Set(shipWins))
            var uniqueOpdRsds = Array(Set(opdRsds))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = _DATEFORMATTER
            
            uniquePoNos.sort(by: { Int($0) < Int($1) })
            uniqueShipWins.sort(by: { $0 != "" && $1 != "" && dateFormatter.date(from: $0)!.isGreaterThanDate(dateFormatter.date(from: $1)!) })
            uniqueOpdRsds.sort(by: { $0 != "" && $1 != "" && dateFormatter.date(from: $0)!.isGreaterThanDate(dateFormatter.date(from: $1)!) })
            
            task.poNo = uniquePoNos.joined(separator: ",")
            task.shipWin = uniqueShipWins.joined(separator: ",")
            task.opdRsd = uniqueOpdRsds.joined(separator: ",")
        }
        
        task.inspectionType = getInspTypeByInspTypeId(inspTypeId)
        task.inspSections = getInspSectionsByTaskId(taskId)!
        }
        return task
    }
    
    func setupTaskInspDataRcords(_ inspSec:InspSection) {
        for taskInspDataRecord in inspSec.taskInspDataRecords {
            
            if taskInspDataRecord.inspectSectionId>0 {
                let section = getInspSectionsById(taskInspDataRecord.inspectSectionId!)
                if section != nil {
                    taskInspDataRecord.sectObj = SectObj(sectionId:(section?.sectionId)!, sectionNameEn: (section?.sectionNameEn)!, sectionNameCn: (section?.sectionNameCn)!, sectionNameFr: section?.sectionNameFr ?? "",inputMode: (section?.inputModeCode)!)
                }else{
                    taskInspDataRecord.sectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "", sectionNameFr: "",inputMode: "")
                }
            }else{
                taskInspDataRecord.sectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "", sectionNameFr: "",inputMode: "")
            }
            
            if taskInspDataRecord.requestSectionId>0 {
                let section = getInspSectionsById(taskInspDataRecord.requestSectionId)
                if section != nil {
                    taskInspDataRecord.reqSectObj = SectObj(sectionId:(section?.sectionId)!, sectionNameEn: (section?.sectionNameEn)!, sectionNameCn: (section?.sectionNameCn)!, sectionNameFr: section?.sectionNameFr ?? "",inputMode: (section?.inputModeCode)!)
                }else{
                    taskInspDataRecord.reqSectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "", sectionNameFr: "",inputMode: "")
                }
            }else{
                taskInspDataRecord.reqSectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "", sectionNameFr: "",inputMode: "")
            }
            
            if taskInspDataRecord.inspectElementId>0 {
                let element = getInspSecElementById(taskInspDataRecord.inspectElementId!)
                if element != nil {
                    taskInspDataRecord.elmtObj = ElmtObj(elementId:(element?.elementId)!,elementNameEn:(element?.elementNameEn)!, elementNameCn:(element?.elementNameCn)!, elementNameFr: element?.elementNameFr ?? "", reqElmtFlag: (element?.requiredElementFlag)!)
                }else{
                    taskInspDataRecord.elmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", elementNameFr: "", reqElmtFlag: 0)
                }
            }else{
                taskInspDataRecord.elmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", elementNameFr: "", reqElmtFlag: 0)
            }
            
            if taskInspDataRecord.inspectPositionId>0 {
                let position = getInspSecPositionById(taskInspDataRecord.inspectPositionId!)
                if position != nil {
                    taskInspDataRecord.postnObj = PositObj(positionId:(position?.positionId)!, positionNameEn:(position?.positionNameEn)!,positionNameCn:(position?.positionNameCn)!, positionNameFr: position?.positionNameFr ?? "")
                }else{
                    taskInspDataRecord.postnObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"", positionNameFr: "")
                }
            }else{
                taskInspDataRecord.postnObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"", positionNameFr: "")
            }
            
            if taskInspDataRecord.resultValueId>0 {
                let resultValue = getResultValueById(taskInspDataRecord.resultValueId)
                if resultValue != nil {
                    taskInspDataRecord.resultObj = ResultValueObj(resultValueId:(resultValue?.resultValueId)!, resultValueNameEn:resultValue!.resultValueNameEn, resultValueNameCn:resultValue!.resultValueNameCn, resultValueNameFr: resultValue?.resultValueNameFr ?? "")
                }else{
                    taskInspDataRecord.resultObj = ResultValueObj(resultValueId:0, resultValueNameEn:"", resultValueNameCn:"", resultValueNameFr: "")
                }
            }else{
                taskInspDataRecord.resultObj = ResultValueObj(resultValueId:0, resultValueNameEn:"", resultValueNameCn:"", resultValueNameFr: "")
            }
        }
    }
    
    func getTaskDetailByTask(_ task:Task) ->Task {
        //Init PO Items
        let poDataHelper = PoDataHelper()
        task.poItems = poDataHelper.getPoByTaskId(task.taskId!)
        
        //Init Task From TaskInspDataRecord
        for inspSec in task.inspSections{
            
            let taskInspDateRecords = getTaskInspDataRecords(task.taskId!, inspectSecId: inspSec.sectionId!, inputMode: inspSec.inputModeCode ?? "")
            
            if taskInspDateRecords!.count > 0{
                
                inspSec.taskInspDataRecords = taskInspDateRecords!
                
                setupTaskInspDataRcords(inspSec)
                
                //If not yet init, just init the Task and add TaskInspDataRecords into DB
            }else{
                
                let inspSecElms = getInspSecElementsByPTIdITId(inspSec.sectionId!, inputMode: inspSec.inputModeCode!, optionEnableFlag: inspSec.optionalEnableFlag ?? 1)
                
                var taskInspDataRecords = [TaskInspDataRecord]()
                for inspSecElm in inspSecElms! {
                    
                    let taskInspDataRecord = TaskInspDataRecord.init(taskId: inspSec.taskId!, refRecordId: 0, inspectSectionId: inspSec.sectionId!, inspectElementId: inspSecElm.elementId!, inspectPositionId: inspSecElm.inspectPositionId!, inspectPositionDesc: "", inspectDetail: "", inspectRemarks: "", resultValueId: inspSecElm.resultValueId, requestSectionId: 0, requestElementDesc: "", createUser: (Cache_Inspector?.appUserName)!, createDate: UIView.init().getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: UIView.init().getCurrentDateTime())
                    
                    taskInspDataRecords.append(taskInspDataRecord!)
                }
                
                inspSec.taskInspDataRecords = updateInspDataRecord(taskInspDataRecords)
                setupTaskInspDataRcords(inspSec)
            }
        }
        
        //Init Defect List
        let thumbNailPath = _TASKSPHYSICALPATH+(Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!+"/"+_THUMBSPHYSICALNAME
        let taskDefectDateRecords = getTaskDefectDataRecords(task.taskId!)
        task.defectItems = [TaskInspDefectDataRecord]()
        
        for taskDefectDateRecord in taskDefectDateRecords! {
            
            //init InputMode base on Element
            taskDefectDateRecord.inputMode = getInputModeCodeByTaskDefectDataId(taskDefectDateRecord.recordId!)
            
            if taskDefectDateRecord.inspectElementId>0 {
                //init Element
                let element = getInspSecElementById(taskDefectDateRecord.inspectElementId!)
                
                if element != nil {
                    taskDefectDateRecord.elmtObj = ElmtObj(elementId:(element?.elementId)!,elementNameEn:(element?.elementNameEn)!, elementNameCn:(element?.elementNameCn)!, elementNameFr: element?.elementNameFr ?? "", reqElmtFlag: (element?.requiredElementFlag)!)
                }else{
                    taskDefectDateRecord.elmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", elementNameFr: "", reqElmtFlag: 0)
                }
                
                //init Sections
                let sectionId = getSectionIdByElementId(taskDefectDateRecord.inspectElementId!)
                let section = getInspSectionsById(sectionId)
                
                if section != nil {
                    taskDefectDateRecord.sectObj = SectObj(sectionId:(section?.sectionId)!, sectionNameEn: (section?.sectionNameEn)!, sectionNameCn: (section?.sectionNameCn)!, sectionNameFr: section?.sectionNameFr ?? "",inputMode: (section?.inputModeCode)!)
                }else{
                    taskDefectDateRecord.sectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "", sectionNameFr: "",inputMode: "")
                }
                
                //init Positions
                let positionId = getPositionIdByElementId(taskDefectDateRecord.inspectElementId!, inputMode: taskDefectDateRecord.inputMode!)
                let position = getInspSecPositionById(positionId)
                
                if position != nil {
                    taskDefectDateRecord.postnObj = PositObj(positionId:(position?.positionId)!, positionNameEn:(position?.positionNameEn)!,positionNameCn:(position?.positionNameCn)!, positionNameFr: position?.positionNameFr ?? "")
                }else{
                    taskDefectDateRecord.postnObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"", positionNameFr: "")
                }
                
                //init Defect Photos
                let photoDataHelper = PhotoDataHelper()
                //taskDefectDateRecord.photoObjs = photoDataHelper.getDefectPhotosById(taskDefectDateRecord.taskId!, dataRecordId: taskDefectDateRecord.recordId!, taskPath: thumbNailPath)
                
                taskDefectDateRecord.photoNames = photoDataHelper.getDefectPhotoNamesById(taskDefectDateRecord.taskId!, dataRecordId: taskDefectDateRecord.recordId!, taskPath: thumbNailPath)
                
            }else{
                //If no relative element
                taskDefectDateRecord.elmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", elementNameFr: "", reqElmtFlag: 0)
                taskDefectDateRecord.postnObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"", positionNameFr: "")
                
                let section = getSectionByTaskInspDataId(taskDefectDateRecord.inspectRecordId!)
                if section != nil {
                    taskDefectDateRecord.sectObj = SectObj(sectionId:(section?.sectionId)!, sectionNameEn: (section?.sectionNameEn)!, sectionNameCn: (section?.sectionNameCn)!, sectionNameFr: section?.sectionNameFr ?? "",inputMode: (section?.inputModeCode)!)
                }else{
                    taskDefectDateRecord.sectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "", sectionNameFr: "",inputMode: "")
                }
    
                //init Defect Photos
                let photoDataHelper = PhotoDataHelper()
                //taskDefectDateRecord.photoObjs = photoDataHelper.getDefectPhotosById(taskDefectDateRecord.taskId!, dataRecordId: taskDefectDateRecord.recordId!, taskPath: thumbNailPath)
                
                taskDefectDateRecord.photoNames = photoDataHelper.getDefectPhotoNamesById(taskDefectDateRecord.taskId!, dataRecordId: taskDefectDateRecord.recordId!, taskPath: thumbNailPath)
            }
            
            task.defectItems.append(taskDefectDateRecord)
        }
        
        return task
    }
    
    func getPoNoByTaskId(_ taskId:Int) ->String {
        let poDataHelper = PoDataHelper()
        
        return poDataHelper.getPoNoByPoId(getPoIdByTaskId(taskId))
    }
    
    func getPoStyleByTaskId(_ taskId:Int) ->String {
        let poDataHelper = PoDataHelper()
        
        return poDataHelper.getPoStyleByPoId(getPoIdByTaskId(taskId))
    }
    
    func getPoIdByTaskId(_ taskId:Int) ->Int {
        let sql = "SELECT po_item_id FROM inspect_task_item WHERE task_id = ?"
        var poId:Int = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
                if rs.next() {
                    poId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return poId
    }
    
    func getInspTypeByInspTypeId(_ inspTypeId:Int) ->String {
        let sql = "SELECT type_name_en, type_name_cn, type_name_fr FROM inspect_type_mstr WHERE type_id = ? AND rec_status = 0 AND deleted_flag = 0"
        var inspType:String = "null"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspTypeId]) {
                if rs.next() {
                    inspType = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "type_name_en"), .zh: rs.string(forColumn: "type_name_cn"), .fr: rs.string(forColumn: "type_name_fr")])
                }
            }
            db.close()
        }
        
        return inspType
    }
    
    func getAllInspType() ->[String] {
        let sql = "SELECT type_name_en,type_name_cn, type_name_fr FROM inspect_type_mstr WHERE rec_status = 0 AND deleted_flag = 0 ORDER BY type_name_en ASC"
        var inspType = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    inspType.append(MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "type_name_en"), .zh: rs.string(forColumn: "type_name_cn"), .fr: rs.string(forColumn: "type_name_fr")]))
                }
            }
            db.close()
        }
        
        return inspType
    }
    
    func getAllTmplType() ->[String] {
        let sql = "SELECT tmpl_name_en, tmpl_name_cn, tmpl_name_fr FROM inspect_task_tmpl_mstr ittm INNER JOIN inspect_type_mstr itm ON ittm.inspect_type_id = itm.type_id WHERE ittm.prod_type_id = ? AND (itm.type_name_fr = ? OR itm.type_name_en = ? OR itm.type_name_cn = ?) AND itm.rec_status = 0 AND itm.deleted_flag = 0 AND ittm.rec_status = 0 AND ittm.deleted_flag = 0"
        var tmplType = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.prodTypeId)!, (Cache_Inspector?.selectedInspType)!, (Cache_Inspector?.selectedInspType)!, (Cache_Inspector?.selectedInspType)!]) {
                while rs.next() {
                    tmplType.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "tmpl_name_en"), .zh: rs.string(forColumn: "tmpl_name_cn"), .fr: rs.string(forColumn: "tmpl_name_fr")]) )
                }
            }
            db.close()
        }
        
        return tmplType
    }
    
    func getTmplIdByName(_ tmplName:String) ->Int {
        let sql = "SELECT tmpl_id FROM inspect_task_tmpl_mstr WHERE (tmpl_name_fr = ? OR tmpl_name_en = ? OR tmpl_name_cn = ?) AND rec_status = 0 AND deleted_flag = 0"
        var tmplId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [tmplName, tmplName, tmplName]) {
                if rs.next() {
                    tmplId = Int(rs.int(forColumn: "tmpl_id"))
                }
            }
            
            db.close()
        }
        
        return tmplId
    }
    
    func getInspSetupIdByName(_ tmplName:String) ->Int {
        let sql = "SELECT inspect_setup_id FROM inspect_task_tmpl_mstr WHERE (tmpl_name_fr = ? OR tmpl_name_en = ? OR tmpl_name_cn = ?) AND rec_status = 0 AND deleted_flag = 0"
        var inspSetupId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [tmplName, tmplName, tmplName]) {
                if rs.next() {
                    inspSetupId = Int(rs.int(forColumn: "inspect_setup_id"))
                }
            }
            
            db.close()
        }
        
        return inspSetupId
    }

    
    func getAllProdType() ->[String] {
        let sql = "SELECT type_name_en, type_name_cn, type_name_fr FROM prod_type_mstr WHERE rec_status = 0 AND deleted_flag = 0"
        var inspType = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    inspType.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "type_name_en"), .zh: rs.string(forColumn: "type_name_cn"), .fr: rs.string(forColumn: "type_name_fr")]) )
                }
            }
            db.close()
        }
        
        return inspType
    }
    
    func getInspectorIdByTaskId(_ taskId:Int) ->Int {
        let sql = "SELECT inspector_id FROM inspect_task_inspector WHERE task_id = ?"
        var insptorId:Int = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
                if rs.next() {
                    insptorId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return insptorId
    }
    
    func getInspectorByTaskId(_ taskId:Int) ->String {
        let sql = "SELECT inspector_name FROM inspector_mstr WHERE inspector_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var insptorName:String = ""
        let insptorId = getInspectorIdByTaskId(taskId)
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [insptorId]) {
            
                if rs.next() {
                    insptorName = rs.string(forColumnIndex: 0) ?? ""
                }
            }
                
            db.close()
        }
        
        return insptorName
    }
    
    func getProdTypeIdByTaskId(_ taskId:Int) ->Int {
        let sql = "SELECT prod_type_id FROM inspect_task WHERE task_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var prodTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
                if rs.next() {
                    prodTypeId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return prodTypeId
    }
    
    func getInspTypeIdByTaskId(_ taskId:Int) ->Int {
        let sql = "SELECT inspect_type_id FROM inspect_task WHERE task_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var inspTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
                if rs.next() {
                    inspTypeId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return inspTypeId
    }
    
    func getInspSectionsByTaskId(_ taskId:Int) ->[InspSection]? {
        /*let sql = "SELECT * FROM inspect_section_mstr WHERE prod_type_id = ? AND inspect_type_id = ? ORDER BY display_order ASC"
        var inspSections = [InspSection]()
        let prodTypeId = getProdTypeIdByTaskId(taskId)
        let inspTypeId = getInspTypeIdByTaskId(taskId)
        */
        let sql = "SELECT * FROM inspect_task_tmpl_mstr ittm INNER JOIN inspect_task it ON ittm.tmpl_id = it.tmpl_id INNER JOIN inspect_task_tmpl_section itts ON ittm.tmpl_id = itts.tmpl_id INNER JOIN inspect_section_mstr ism ON itts.inspect_section_id = ism.section_id WHERE it.task_id = ? AND ittm.rec_status = 0 AND ittm.deleted_flag = 0 ORDER BY ism.display_order ASC"
        var inspSections = [InspSection]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
                
            while rs.next() {
                let sectionId = Int(rs.int(forColumn: "section_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let sectionNameEn = rs.string(forColumn: "section_name_en")
                let sectionNameCn = rs.string(forColumn: "section_name_cn")
                let sectionNameFr = rs.string(forColumn: "section_name_fr") ?? ""
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let displayOrder = Int(rs.int(forColumn: "display_order"))
                let resultSetId = Int(rs.int(forColumn: "result_set_id"))
                let inputModeCode = rs.string(forColumn: "input_mode_code")
                let optionalEnableFlag = Int(rs.int(forColumn: "optional_enable_flag"))
                let adhoSelectFlag = Int(rs.int(forColumn: "adhoc_select_flag"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                let inspSection = InspSection(taskId: taskId, sectionId: sectionId, inspectSetupId: inspectSetupId, sectionNameEn: sectionNameEn!, sectionNameCn: sectionNameCn!, sectionNameFr: sectionNameFr, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, displayOrder: displayOrder, resultSetId: resultSetId, inputModeCode: inputModeCode!, optionalEnableFlag: optionalEnableFlag, adhocSelectFlag: adhoSelectFlag, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                inspSections.append(inspSection)
            }
            }
            
            db.close()
            
            return inspSections
        }
        
        return nil
    }
    
    func getInspSecElementsByPTIdITId(_ inspSectionId:Int, inputMode:String = _INPUTMODE04, optionEnableFlag:Int = 1) ->[InspSectionElement]? {
        
        var sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON iem.element_id = ipe.inspect_element_id INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.required_element_flag = 1 AND iem.element_type = 1 AND iem.deleted_flag = 0 ORDER BY iem.display_order ASC"
        
        if optionEnableFlag < 1 {
            sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON iem.element_id = ipe.inspect_element_id INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.element_type = 1 AND iem.deleted_flag = 0 ORDER BY iem.display_order ASC"
        }
        
        if inputMode == _INPUTMODE01 {
            sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.required_element_flag = 1 AND iem.element_type = 1 AND iem.deleted_flag = 0 ORDER BY iem.display_order ASC"
            if optionEnableFlag < 1 {
                sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id INNER JOIN inspect_position_element ipe ON iem.element_id = ipe.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.element_type = 1 AND iem.deleted_flag = 0 ORDER BY iem.display_order ASC"
            }
        }else if inputMode == _INPUTMODE02 {
            return [InspSectionElement]()
        }
        
        var inspSecElms = [InspSectionElement]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspSectionId]) {
                
                while rs.next() {
                    
                    let elementId = Int(rs.int(forColumn: "element_id"))
                    let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                    let elementNameEn = rs.string(forColumn: "element_name_en")
                    let elementNameCn = rs.string(forColumn: "element_name_cn")
                    let elementNameFr = rs.string(forColumn: "element_name_fr") ?? ""
                    let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                    let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                    let elementType = Int(rs.int(forColumn: "element_type"))
                    let inspectSectionId = Int(rs.int(forColumn: "inspect_section_id"))
                    let inspectPositionId = Int(rs.int(forColumn: "inspect_position_id"))
                    let displayOrder = Int(rs.int(forColumn: "display_order"))
                    let resultSetId = Int(rs.int(forColumn: "result_set_id"))
                    let requiredElementFlag = Int(rs.int(forColumn: "required_element_flag"))
                    let detailDefaultValue = rs.string(forColumn: "detail_default_value")
                    var detailRequiredResultList = rs.string(forColumn: "detail_required_result_set_id")
                    let detailSuggestFlag = Int(rs.int(forColumn: "detail_suggest_flag"))
                    let recStatus = Int(rs.int(forColumn: "rec_status"))
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                    let deleteUser = rs.string(forColumn: "delete_user")
                    let deleteDate = rs.string(forColumn: "delete_date")
                    
                    if (detailRequiredResultList == nil) {
                        detailRequiredResultList = ""
                    }
                    
                    let inspSecElm = InspSectionElement(elementId: elementId, inspectSetupId: inspectSetupId, elementNameEn: elementNameEn!, elementNameCn: elementNameCn!, elementNameFr: elementNameFr, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, elementType: elementType, inspectSectionId: inspectSectionId, inspectPositionId: inspectPositionId, displayOrder: displayOrder, resultSetId: resultSetId, requiredElementFlag: requiredElementFlag, detailDefaultValue: detailDefaultValue!, detailRequiredResultList: detailRequiredResultList!, detailSuggestFlag: detailSuggestFlag, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    inspSecElms.append(inspSecElm)
                }
            }
            
            db.close()
            
            return inspSecElms
        }
        
        return nil
    }
    
    func getInspSecPositionByIds(_ prodTypeId:Int, inspectTypeId:Int) ->[InspSectionPosition]? {
        //let sql = "SELECT * FROM inspect_position_mstr WHERE prod_type_id = ? AND inspect_type_id = ? AND parent_position_id < 1"
        let sql = "SELECT * FROM inspect_task_tmpl_position ittp INNER JOIN inspect_task_tmpl_mstr ittm ON ittp.tmpl_id = ittm.tmpl_id INNER JOIN inspect_position_mstr ipm ON ittp.inspect_position_id = ipm.position_id WHERE ittm.prod_type_id = ? AND ittm.inspect_type_id = ? AND ittm.rec_status = 0 AND ittm.deleted_flag = 0 AND ipm.rec_status = 0 AND ipm.deleted_flag = 0 AND ipm.parent_position_id < 1 ORDER BY ipm.display_order ASC"
        var inspSecPostns = [InspSectionPosition]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [prodTypeId, inspectTypeId]) {
            
            while rs.next() {
                
                let positionId = Int(rs.int(forColumn: "position_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let positionCode = rs.string(forColumn: "position_code")
                let positionNameEn = rs.string(forColumn: "position_name_en")
                let positionNameCn = rs.string(forColumn: "position_name_cn")
                let positionNameFr = rs.string(forColumn: "position_name_fr") ?? ""
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let currentLevel = Int(rs.int(forColumn: "current_level"))
                let parentPositionId = Int(rs.int(forColumn: "parent_position_id"))
                let displayOrder = Int(rs.int(forColumn: "display_order"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                let inspSecPostn = InspSectionPosition(positionId: positionId, inspectSetupId: inspectSetupId, positionCode: positionCode!, positionNameEn: positionNameEn!, positionNameFr: positionNameFr, positionNameCn: positionNameCn!, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, currentLevel: currentLevel, parentPositionId: parentPositionId, displayOrder: displayOrder, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                inspSecPostns.append(inspSecPostn)
            }
            }
            
            db.close()
            
            return inspSecPostns
        }
        
        return nil
    }
    
    func getResultSetIdByElmId(_ elmId:Int) ->Int {
        let sql = "SELECT result_set_id FROM inspect_element_mstr WHERE element_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultSetId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [elmId]) {
            
                if rs.next() {
                    resultSetId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return resultSetId
    }
    
    func getResultSetValueByElmId(_ elmId:Int) ->[String]? {
        let sql = "SELECT v.value_name_en,v.value_name_cn, v.value_name_fr FROM result_set_value as s INNER JOIN result_value_mstr as v ON s.value_id=v.value_id WHERE s.set_id = ? AND (v.rec_status = 0 AND v.deleted_flag = 0) ORDER BY v.display_order"
        var resultSetValues = [String]()
        let rsId = getResultSetIdByElmId(elmId)
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [rsId]) {
            
            while rs.next() {
                resultSetValues.append(MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")]))
            }
            }
            
            db.close()
            
            return resultSetValues
        }
        
        return nil
    }
    
    func getResultSetValueBySetId(_ rsId:Int) ->[String]? {
        let sql = "SELECT v.value_name_en,v.value_name_cn, v.value_name_fr FROM result_set_value as s INNER JOIN result_value_mstr as v ON s.value_id=v.value_id WHERE s.set_id = ? AND (v.rec_status = 0 AND v.deleted_flag = 0) ORDER BY v.display_order"
        var resultSetValues = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [rsId]) {
            
            while rs.next() {
                resultSetValues.append(MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")]))
            }
            }
            
            db.close()
            
            return resultSetValues
        }
        
        return nil
    }
    
    func getResultKeyValueBySetId(_ rsId:Int) ->[String:Int]? {
        let sql = "SELECT v.value_id,v.value_name_en,v.value_name_cn,v.value_name_fr FROM result_set_value as s INNER JOIN result_value_mstr as v ON s.value_id=v.value_id WHERE s.set_id = ? AND (v.rec_status = 0 AND v.deleted_flag = 0) ORDER BY v.display_order"
        var resultKeyValues = [String:Int]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [rsId]) {
                
                while rs.next() {
                    resultKeyValues[MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")])] = Int(rs.int(forColumn: "value_id"))
                }
            }
            
            db.close()
            
            return resultKeyValues
        }
        
        return nil
    }
    
    func updateInspDataRecord(_ inspDataRecords:[TaskInspDataRecord]) ->[TaskInspDataRecord] {
        
        if db.open() && inspDataRecords.count > 0 {
            db.beginTransaction()
            
            for inspDataRecord in inspDataRecords {
                let sql = "INSERT OR REPLACE INTO task_inspect_data_record  ('record_id','task_id','ref_record_id','inspect_section_id','inspect_element_id','inspect_position_id','inspect_position_desc','inspect_detail','inspect_remarks','result_value_id','create_user','create_date','modify_user','modify_date','request_section_id','request_element_desc') VALUES ((SELECT record_id FROM task_inspect_data_record WHERE record_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                
                if db.executeUpdate(sql, withArgumentsIn: [notNilObject(inspDataRecord.recordId as AnyObject)!,inspDataRecord.taskId!,inspDataRecord.refRecordId!,inspDataRecord.inspectSectionId!,inspDataRecord.inspectElementId!,inspDataRecord.inspectPositionId!,inspDataRecord.inspectPositionDesc!,inspDataRecord.inspectDetail!,inspDataRecord.inspectRemarks!,inspDataRecord.resultValueId,inspDataRecord.createUser!,inspDataRecord.createDate!,inspDataRecord.modifyUser!,inspDataRecord.modifyDate!,notNilObject(inspDataRecord.requestSectionId as AnyObject)!,notNilObject(inspDataRecord.requestElementDesc as AnyObject)!]) {
                
                    inspDataRecord.recordId = Int(db.lastInsertRowId)
                }else{
                    //UIView.init().alertView("Saving Inspect Items Error!")
                    db.rollback()
                    db.close()
                    
                    return inspDataRecords
                }
            }
            
            db.commit()
            db.close()
        }
        
        return inspDataRecords
    }
    
    func updateInspDataRecord(_ inspDataRecord:TaskInspDataRecord) ->TaskInspDataRecord {
        
        if db.open() {
            db.beginTransaction()
            
            
            let sql = "INSERT OR REPLACE INTO task_inspect_data_record  ('record_id','task_id','ref_record_id','inspect_section_id','inspect_element_id','inspect_position_id','inspect_position_desc','inspect_detail','inspect_remarks','result_value_id','create_user','create_date','modify_user','modify_date','request_section_id','request_element_desc', 'inspect_position_zone_value_id') VALUES ((SELECT record_id FROM task_inspect_data_record WHERE record_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                
            if db.executeUpdate(sql, withArgumentsIn: [notNilObject(inspDataRecord.recordId as AnyObject)!,inspDataRecord.taskId!,inspDataRecord.refRecordId!,inspDataRecord.inspectSectionId!,inspDataRecord.inspectElementId!,inspDataRecord.inspectPositionId!,inspDataRecord.inspectPositionDesc!,inspDataRecord.inspectDetail!,inspDataRecord.inspectRemarks!,inspDataRecord.resultValueId,inspDataRecord.createUser!,inspDataRecord.createDate!,inspDataRecord.modifyUser!,inspDataRecord.modifyDate!,notNilObject(inspDataRecord.requestSectionId as AnyObject)!,notNilObject(inspDataRecord.requestElementDesc as AnyObject)!, inspDataRecord.inspectPositionZoneValueId ?? 0]) {
                    
                inspDataRecord.recordId = Int(db.lastInsertRowId)
            }else{
                //UIView.init().alertView("Saving Inspect Items Error!")
                db.rollback()
                db.close()
                    
                return inspDataRecord
            }
            
            
            db.commit()
            db.close()
        }
        
        return inspDataRecord
    }
    
    func checkAllInspDataRecordDone() ->Bool {
        let sql = "SELECT 1 FROM task_inspect_data_record tidr INNER JOIN inspect_element_mstr iem ON tidr.inspect_element_id = iem.element_id INNER JOIN inspect_position_mstr ipm ON tidr.inspect_position_id = ipm.position_id WHERE tidr.task_id = ? AND tidr.result_value_id < 1 AND iem.rec_status = 0 AND iem.deleted_flag <>1 AND ipm.rec_status = 0 AND ipm.deleted_flag <>1"
        //"SELECT 1 FROM task_inspect_data_record WHERE task_id = ? AND result_value_id < 1"
        var result = true
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Task_On?.taskId)!]) {
                if rs.next() {
                    result = false
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func getOptInspSecElementsByIds(_ prodTypeId:Int, inspTypeId:Int, inspSectionId:Int) ->[InspSectionElement]? {
        //let sql = "SELECT * FROM inspect_element_mstr WHERE prod_type_id = ? AND inspect_type_id = ? AND inspect_section_id = ? AND required_element_flag = 0 ORDER BY element_name_en ASC"
        let sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.required_element_flag = 0 AND iem.element_type = 1 AND (iem.rec_status = 0 AND iem.deleted_flag = 0)"
        var inspSecElms = [InspSectionElement]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspSectionId]) {
            
            while rs.next() {
                
                let elementId = Int(rs.int(forColumn: "element_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let elementNameEn = rs.string(forColumn: "element_name_en")
                let elementNameCn = rs.string(forColumn: "element_name_cn")
                let elementNameFr = rs.string(forColumn: "element_name_fr") ?? ""
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let elementType = Int(rs.int(forColumn: "element_type"))
                let inspectSectionId = Int(rs.int(forColumn: "inspect_section_id"))
                let inspectPositionId = Int(rs.int(forColumn: "inspect_position_id"))
                let displayOrder = Int(rs.int(forColumn: "display_order"))
                let resultSetId = Int(rs.int(forColumn: "result_set_id"))
                let requiredElementFlag = Int(rs.int(forColumn: "required_element_flag"))
                let detailDefaultValue = rs.string(forColumn: "detail_default_value")
                let detailRequiredResultList = rs.string(forColumn: "detail_required_result_set_id")
                let detailSuggestFlag = Int(rs.int(forColumn: "detail_suggest_flag"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                let inspSecElm = InspSectionElement(elementId: elementId, inspectSetupId: inspectSetupId, elementNameEn: elementNameEn!, elementNameCn: elementNameCn!, elementNameFr: elementNameFr, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, elementType: elementType, inspectSectionId: inspectSectionId, inspectPositionId: inspectPositionId, displayOrder: displayOrder, resultSetId: resultSetId, requiredElementFlag: requiredElementFlag, detailDefaultValue: detailDefaultValue!, detailRequiredResultList: detailRequiredResultList!, detailSuggestFlag: detailSuggestFlag, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                inspSecElms.append(inspSecElm)
            }
            }
            
            db.close()
            
            return inspSecElms
        }
        
        return nil
    }
    
    
    func getOptInspSecPositionByIds(_ prodTypeId:Int, inspTypeId:Int, sectionId:Int) ->[InspSectionPosition]? {
        //let sql = "SELECT DISTINCT ipm.* FROM inspect_element_mstr as iem INNER JOIN inspect_position_mstr as ipm ON iem.inspect_position_id=ipm.position_id WHERE iem.prod_type_id = ? AND iem.inspect_type_id = ? AND iem.inspect_section_id = ? AND iem.required_element_flag = 0 ORDER BY ipm.position_name_en ASC"
        let sql = "SELECT DISTINCT ipm.* FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_section_element ise ON ipe.inspect_element_id = ise.inspect_element_id INNER JOIN inspect_element_mstr iem ON ise.inspect_element_id = iem.element_id WHERE ise.inspect_section_id = ? AND iem.required_element_flag = 0 AND (ipm.rec_status = 0 AND ipm.deleted_flag = 0) ORDER BY ipm.position_name_en ASC"
        var inspSecPostns = [InspSectionPosition]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [sectionId]) {
            
            while rs.next() {
                
                let positionId = Int(rs.int(forColumn: "position_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let positionCode = rs.string(forColumn: "position_code")
                let positionNameEn = rs.string(forColumn: "position_name_en")
                let positionNameCn = rs.string(forColumn: "position_name_cn")
                let positionNameFr = rs.string(forColumn: "position_name_fr") ?? ""
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let currentLevel = Int(rs.int(forColumn: "current_level"))
                let parentPositionId = Int(rs.int(forColumn: "parent_position_id"))
                let displayOrder = Int(rs.int(forColumn: "display_order"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                let inspSecPostn = InspSectionPosition(positionId: positionId, inspectSetupId: inspectSetupId, positionCode: positionCode!, positionNameEn: positionNameEn!, positionNameFr: positionNameFr, positionNameCn: positionNameCn!, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, currentLevel: currentLevel, parentPositionId: parentPositionId, displayOrder: displayOrder, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                inspSecPostns.append(inspSecPostn)
            }
            }
            
            db.close()
            
            return inspSecPostns
        }
        
        return nil
    }
    
    func getTaskInspDataRecordByTaskId(_ taskId:Int, inspSecId:Int) ->[TaskInspDataRecord]? {
        let sql = "SELECT * FROM task_inspect_data_record WHERE task_id = ? AND inspect_section_id = ? ORDER BY record_id ASC"
        var taskInspDataRecs = [TaskInspDataRecord]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId,inspSecId]) {
            
            while rs.next() {
                
                let recordId = Int(rs.int(forColumn: "record_id"))
                let taskId = Int(rs.int(forColumn: "task_id"))
                let refRecordId = Int(rs.int(forColumn: "ref_record_id"))
                let inspectSectionId = Int(rs.int(forColumn: "inspect_section_id"))
                let inspectElementId = Int(rs.int(forColumn: "inspect_element_id"))
                let inspectPositionId = Int(rs.int(forColumn: "inspect_position_id"))
                let inspectPositionDesc = rs.string(forColumn: "inspect_position_desc")
                let inspectDetail = rs.string(forColumn: "inspect_detail")
                let inspectRemarks = rs.string(forColumn: "inspect_remarks")
                let resultValueId = Int(rs.int(forColumn: "result_value_id"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let requestSectionId = Int(rs.int(forColumn: "request_section_id"))
                let requestElementDesc = rs.string(forColumn: "request_element_desc")
                
                let taskInspDataRec = TaskInspDataRecord(recordId: recordId,taskId: taskId, refRecordId: refRecordId, inspectSectionId: inspectSectionId, inspectElementId: inspectElementId, inspectPositionId: inspectPositionId, inspectPositionDesc: inspectPositionDesc, inspectDetail: inspectDetail, inspectRemarks: inspectRemarks, resultValueId: resultValueId, requestSectionId: requestSectionId, requestElementDesc: requestElementDesc!,  createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!)
                
                taskInspDataRecs.append(taskInspDataRec!)
            }
            }
            
            db.close()
            
            return taskInspDataRecs
        }
        
        return nil
    }
    
    
    func getInspSecPositionById(_ inspPostId:Int) ->InspSectionPosition? {
        let sql = "SELECT * FROM inspect_position_mstr WHERE position_id = ?"
        var inspSecPost:InspSectionPosition?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspPostId]) {
            
            if rs.next() {
                
                let positionId = Int(rs.int(forColumn: "position_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let positionCode = rs.string(forColumn: "position_code")
                let positionNameEn = rs.string(forColumn: "position_name_en")
                let positionNameCn = rs.string(forColumn: "position_name_cn")
                let positionNameFr = rs.string(forColumn: "position_name_fr") ?? ""
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let currentLevel = Int(rs.int(forColumn: "current_level"))
                let parentPositionId = Int(rs.int(forColumn: "parent_position_id"))
                let displayOrder = Int(rs.int(forColumn: "display_order"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                inspSecPost = InspSectionPosition(positionId: positionId, inspectSetupId: inspectSetupId, positionCode: positionCode!, positionNameEn: positionNameEn!, positionNameFr: positionNameFr, positionNameCn: positionNameCn!, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, currentLevel: currentLevel, parentPositionId: parentPositionId, displayOrder: displayOrder, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
            }
            }
            
            db.close()
            
            return inspSecPost
        }
        
        return nil
    }
    
    func getInspSecElementById(_ inspElmId:Int) ->InspSectionElement? {
        let sql = "SELECT * FROM inspect_element_mstr WHERE element_id = ?"
        var inspSecElm:InspSectionElement?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspElmId]) {
            
            if rs.next() {
                
                let elementId = Int(rs.int(forColumn: "element_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let elementNameEn = rs.string(forColumn: "element_name_en")
                let elementNameCn = rs.string(forColumn: "element_name_cn")
                let elementNameFr = rs.string(forColumn: "element_name_fr") ?? ""
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let elementType = Int(rs.int(forColumn: "element_type"))
                let inspectSectionId = 0//Int(rs.intForColumn("inspect_section_id"))
                let inspectPositionId = 0//Int(rs.intForColumn("inspect_position_id"))
                let displayOrder = Int(rs.int(forColumn: "display_order"))
                let resultSetId = Int(rs.int(forColumn: "result_set_id"))
                let requiredElementFlag = Int(rs.int(forColumn: "required_element_flag"))
                let detailDefaultValue = rs.string(forColumn: "detail_default_value")
                var detailRequiredResultList = rs.string(forColumn: "detail_required_result_set_id")
                let detailSuggestFlag = Int(rs.int(forColumn: "detail_suggest_flag"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                if (detailRequiredResultList == nil) {
                    detailRequiredResultList = ""
                }
                
                inspSecElm = InspSectionElement(elementId: elementId, inspectSetupId: inspectSetupId, elementNameEn: elementNameEn!, elementNameCn: elementNameCn!, elementNameFr: elementNameFr, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, elementType: elementType, inspectSectionId: inspectSectionId, inspectPositionId: inspectPositionId, displayOrder: displayOrder, resultSetId: resultSetId, requiredElementFlag: requiredElementFlag, detailDefaultValue: detailDefaultValue!, detailRequiredResultList: detailRequiredResultList!, detailSuggestFlag: detailSuggestFlag, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
            }
            }
            
            db.close()
            
            return inspSecElm
        }
        
        return nil
    }
    
    func getResultValueIdByResultValue(_ resultValue:String, prodTypeId:Int, inspTypeId:Int) ->Int {
        //let sql = "SELECT value_id FROM result_value_mstr WHERE (value_name_en LIKE ? OR value_name_cn LIKE ?) AND prod_type_id = ? AND inspect_type_id = ?"
        let sql = "SELECT value_id FROM result_value_mstr WHERE value_name_en LIKE ? OR value_name_cn LIKE ? OR value_name_fr LIKE ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValueId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [resultValue,resultValue, resultValue]) {
            
                if rs.next() {
                    resultValueId = Int(rs.int(forColumn: "value_id"))
                }
            }
            
            db.close()
        }
        
        return resultValueId
    }
    
    func getResultValueByResultValueId(_ resultValueId:Int) ->String {
        let sql = "SELECT * FROM result_value_mstr WHERE value_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValue = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [resultValueId]) {
            
                if rs.next() {
                    resultValue = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")])
                }
            }
            
            db.close()
        }
        
        return resultValue
    }
    
    func getResultValueById(_ resultValueId:Int) ->ResultValueObj? {
        let sql = "SELECT * FROM result_value_mstr WHERE value_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValue:ResultValueObj?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [resultValueId]) {
            
            if rs.next() {
                let resultValueId = Int(rs.int(forColumn: "value_id"))
                let resultValueNameEn = rs.string(forColumn: "value_name_en")
                let resultValueNameCn = rs.string(forColumn: "value_name_cn")
                let resultValueNameFr = rs.string(forColumn: "value_name_fr") ?? ""
                
                resultValue = ResultValueObj(resultValueId:resultValueId, resultValueNameEn:resultValueNameEn!, resultValueNameCn:resultValueNameCn!, resultValueNameFr: resultValueNameFr)
            }
            }
            
            db.close()
            
            return resultValue
        }
        
        return nil
    }
    
    func getResultSetValuesByTaskId(_ taskId:Int) ->[SummaryResultValue] {
        let sql = "SELECT ism.section_id, ism.section_name_en,ism.section_name_cn, ism.section_name_fr,rvm.value_id, rvm.value_name_en,rvm.value_name_cn, rvm.value_name_fr,IFNULL(dr.result_cnt, 0) AS result_cnt FROM inspect_task it INNER JOIN inspect_task_tmpl_section itts ON it.tmpl_id = itts.tmpl_id INNER JOIN inspect_section_mstr ism ON ism.section_id = itts.inspect_section_id AND ism.rec_status = 0 AND ism.deleted_flag = 0 INNER JOIN result_set_mstr rsm ON rsm.set_id = ism.result_set_id AND rsm.rec_status = 0 AND rsm.deleted_flag = 0 INNER JOIN result_set_value rsv ON rsv.set_id = rsm.set_id INNER JOIN result_value_mstr rvm ON rvm.value_id = rsv.value_id AND rvm.rec_status = 0 AND rvm.deleted_flag = 0 LEFT OUTER JOIN (SELECT task_id, inspect_section_id, result_value_id, COUNT(record_id) AS result_cnt FROM task_inspect_data_record GROUP BY task_id, inspect_section_id, result_value_id) dr ON dr.task_id = it.task_id AND dr.inspect_section_id = ism.section_id AND dr.result_value_id = rsv.value_id WHERE it.task_id=? AND (it.rec_status = 0 AND it.deleted_flag = 0) AND (ism.rec_status = 0 AND ism.deleted_flag = 0) AND (rsm.rec_status = 0 AND rsm.deleted_flag = 0) AND (rvm.rec_status = 0 AND rvm.deleted_flag = 0) ORDER BY ism.display_order ASC, rvm.display_order ASC"
        
        var resultSetValues = [SummaryResultValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
            while rs.next() {
                
                let sectionId = Int(rs.int(forColumn: "section_id"))
                let sectionName = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "section_name_en"), .zh: rs.string(forColumn: "section_name_cn"), .fr: rs.string(forColumn: "section_name_fr")])
                let valueId = Int(rs.int(forColumn: "value_id"))
                let valueName = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")])
                let resultCount = Int(rs.int(forColumn: "result_cnt"))
                
                let resultSetValue = SummaryResultValue(sectionId: sectionId,sectionName: sectionName,valueId: valueId,valueName: valueName,resultCount: resultCount)
                resultSetValues.append(resultSetValue)
            }
            }
            
            db.close()
        }
        
        return resultSetValues
    }
    
    func getResultSetValuesBySectionId(_ sectionId:Int) ->[String] {
        let sql = "SELECT value_name_en, value_name_cn, value_name_fr FROM result_set_value AS rsv INNER JOIN result_value_mstr AS rvm ON rsv.value_id = rvm.value_id WHERE set_id = (SELECT rsm.set_id FROM inspect_section_mstr AS ism INNER JOIN result_set_mstr AS rsm ON ism.result_set_id = rsm.set_id WHERE ism.section_id = ?) ORDER BY rvm.display_order ASC"
        var resultSetValues = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [sectionId]) {
            
            while rs.next() {
                resultSetValues.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")]) )
            }
            }
            
            db.close()
        }
        
        return resultSetValues
    }
    
    func updateInspDefectDataRecord(_ taskInspDefectDataRecord:TaskInspDefectDataRecord) ->Int {
        if db.open() {
            db.beginTransaction()
            
            var lastInsertId = 0
            
            let sql = "INSERT OR REPLACE INTO task_defect_data_record  ('record_id','task_id','inspect_record_id','ref_record_id','inspect_element_id','defect_desc','defect_qty_critical','defect_qty_major','defect_qty_minor','defect_qty_total','create_user','create_date','modify_user','modify_date','inspect_element_defect_value_id','inspect_element_case_value_id','defect_remarks_option_list','other_remarks') VALUES ((SELECT record_id FROM task_defect_data_record WHERE record_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
            if db.executeUpdate(sql, withArgumentsIn:[notNilObject(taskInspDefectDataRecord.recordId as AnyObject)!,taskInspDefectDataRecord.taskId!,taskInspDefectDataRecord.inspectRecordId!,taskInspDefectDataRecord.refRecordId!,taskInspDefectDataRecord.inspectElementId!,taskInspDefectDataRecord.defectDesc!,taskInspDefectDataRecord.defectQtyCritical,taskInspDefectDataRecord.defectQtyMajor,taskInspDefectDataRecord.defectQtyMinor,taskInspDefectDataRecord.defectQtyTotal,taskInspDefectDataRecord.createUser!,taskInspDefectDataRecord.createDate!,taskInspDefectDataRecord.modifyUser!,taskInspDefectDataRecord.modifyDate!,taskInspDefectDataRecord.inspectElementDefectValueId ?? 0,taskInspDefectDataRecord.inspectElementCaseValueId ?? 0,taskInspDefectDataRecord.defectRemarksOptionList ?? "",taskInspDefectDataRecord.othersRemark ?? ""]){
            
                lastInsertId = Int(db.lastInsertRowId)
            }else{
                
                db.rollback()
                db.close()
                return 0
            }
            
            db.commit()
            db.close()
            
            return lastInsertId
        }
        
        return 0
    }
    
    func getTypeNameByTypeId(_ typeId:Int) ->String {
        let sql = "SELECT type_name_en, type_name_cn, type_name_fr FROM prod_type_mstr WHERE type_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var typeName = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [typeId]) {
            
                if rs.next() {
                    typeName = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "type_name_en"), .zh: rs.string(forColumn: "type_name_cn"), .fr: rs.string(forColumn: "type_name_fr")])
                }
            }
            
            db.close()
        }
        return typeName
    }
    
    func updateTask(_ task:Task) ->Bool {
        //let sql = "UPDATE inspect_task SET task_remarks=?,vdr_notes=?,inspect_result_value_id=?,inspector_sign_image_file=?,vdr_sign_name=?,vdr_sign_image_file=?,task_status=?,upload_inspector_id=?,upload_device_id=?, vdr_sign_date=datetime('now','localtime'),cancel_date=?,report_prefix=?,report_inspector_id=? WHERE task_id = ?"
        let sql = "UPDATE inspect_task SET task_remarks=?,vdr_notes=?,inspect_result_value_id=?,inspector_sign_image_file=?,vdr_sign_name=?,vdr_sign_image_file=?,task_status=?,upload_inspector_id=?,upload_device_id=?, vdr_sign_date=?,cancel_date=?,report_prefix=?,report_inspector_id=?,qc_remarks_option_list=?,additional_admin_item_option_list=? WHERE task_id = ?"
        
        if db.open() {
            db.beginTransaction()
            
            let vdrSignDate = (task.vdrSignDate != nil) ? task.vdrSignDate:UIView.init().getCurrentDateTime()
            
            if !db.executeUpdate(sql, withArgumentsIn: [task.taskRemarks!,task.vdrNotes!,task.inspectionResultValueId!,task.inspectionSignImageFile!,task.vdrSignName!,task.vdrSignImageFile!,task.taskStatus!,task.uploadInspectorId!,task.uploadDeviceId!,vdrSignDate!,task.cancelDate,task.reportPrefix!,task.reportInspectorId!,task.qcRemarks ?? "",task.additionalAdministrativeItems ?? "",task.taskId!]) {
                
                db.rollback()
                db.close()
                return false
            }
            
            db.commit()
            db.close()
        }
        return true
    }
    
    func getResultValueIdByName(_ resultValueName:String) ->Int {
        let sql = "SELECT value_id FROM result_value_mstr WHERE value_name_en=? OR value_name_cn=? OR value_name_fr=? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValueId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [resultValueName,resultValueName, resultValueName]) {
            
                if rs.next() {
                    resultValueId = Int(rs.int(forColumn: "value_id"))
                }
            }
            
            db.close()
        }
        
        return resultValueId
    }
    
    func getResultValueNameById(_ resultValueId:Int) ->String {
        let sql = "SELECT value_name_en,value_name_cn, value_name_fr FROM result_value_mstr WHERE value_id=? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValueName = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [resultValueId]) {
            
            if rs.next() {
                resultValueName = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")])
            }
            }
            
            db.close()
        }
        
        return resultValueName
    }
    
    func removeRecordMarkedDeleted(_ taskId: Int) {
        
        var sql = "DELETE FROM task_defect_data_record WHERE inspect_record_id IN (SELECT record_id FROM task_inspect_data_record WHERE task_id = ? AND task_id NOT IN (SELECT task_id FROM inspect_task WHERE task_status > 3 ) AND inspect_element_id IN (SELECT element_id FROM inspect_element_mstr WHERE deleted_flag = 1))"
        
        if db.open(){
            db.beginTransaction()
            
            // Step1: Delete Task Defect Data Recored
            if db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                
                // Step2: Delete Task Inspect Data Recored
                sql = "DELETE FROM task_inspect_data_record WHERE task_id = ? AND task_id NOT IN (SELECT task_id FROM inspect_task WHERE task_status > 3 ) AND inspect_element_id IN (SELECT element_id FROM inspect_element_mstr WHERE deleted_flag = 1)"
                if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                    db.rollback()
                    db.close()
                    return
                }
            } else {
                db.rollback()
                db.close()
                return
            }
            
            db.commit()
            db.close()
        }
    }
    
    func getTaskInspDataRecords(_ taskId:Int, inspectSecId:Int, inputMode:String) ->[TaskInspDataRecord]? {
        var sql = "SELECT * FROM task_inspect_data_record tidr INNER JOIN inspect_task it ON tidr.task_id = it.task_id INNER JOIN inspect_element_mstr iem ON tidr.inspect_element_id = iem.element_id WHERE tidr.task_id = ? AND tidr.inspect_section_id= ? AND ((it.task_status < 4 AND iem.rec_status = 0 AND iem.deleted_flag = 0) OR it.task_status > 3)"
        
        if inputMode == _INPUTMODE02 {
            sql = "SELECT * FROM task_inspect_data_record tidr INNER JOIN inspect_task it ON tidr.task_id = it.task_id INNER JOIN inspect_element_mstr iem ON tidr.inspect_element_id = iem.element_id INNER JOIN inspect_position_mstr ipm ON tidr.inspect_position_id = ipm.position_id WHERE tidr.task_id = ? AND tidr.inspect_section_id= ? AND ((it.task_status < 4 AND ipm.rec_status = 0 AND ipm.deleted_flag = 0) OR it.task_status > 3)"
        }
        
        var taskInspDataRecords = [TaskInspDataRecord]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, inspectSecId]) {
            
            while rs.next() {
                
                let recordId = Int(rs.int(forColumn: "record_id"))
                let taskId = Int(rs.int(forColumn: "task_id"))
                let refRecordId = Int(rs.string(forColumn: "ref_record_id") ?? "0")
                let inspSecId = Int(rs.string(forColumn: "inspect_section_id") ?? "0")
                let inspElmtId = Int(rs.string(forColumn: "inspect_element_id") ?? "0")
                let inspPostnId = Int(rs.int(forColumn: "inspect_position_id"))
                let inspPostnDesc = rs.string(forColumn: "inspect_position_desc")
                let inspDetail = rs.string(forColumn: "inspect_detail")
                let inspRemarks = rs.string(forColumn: "inspect_remarks")
                let resultValueId = Int(rs.int(forColumn: "result_value_id"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let reqSecId = Int(rs.int(forColumn: "request_section_id"))
                let reqElmtDesc = rs.string(forColumn: "request_element_desc")
                let inspectPositionZoneValueId = Int(rs.int(forColumn: "inspect_position_zone_value_id"))
                
                let taskInspDataRecord = TaskInspDataRecord(recordId: recordId, taskId: taskId, refRecordId: refRecordId, inspectSectionId: inspSecId!, inspectElementId: inspElmtId!, inspectPositionId: inspPostnId, inspectPositionDesc: inspPostnDesc, inspectDetail: inspDetail, inspectRemarks: inspRemarks, resultValueId: resultValueId, requestSectionId: reqSecId, requestElementDesc: reqElmtDesc == nil ? "":reqElmtDesc!, inspectPositionZoneValueId: inspectPositionZoneValueId, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!)
                
                taskInspDataRecords.append(taskInspDataRecord!)
            }
            }
            
            db.close()
            
            return taskInspDataRecords
        }
        
        return nil
    }
    
    func getInspSectionsById(_ sectionId:Int) ->InspSection? {
        //let sql = "SELECT * FROM inspect_section_mstr WHERE section_id=? AND rec_status = 0 AND deleted_flag = 0"
        let sql = "SELECT * FROM inspect_section_mstr WHERE section_id=? AND (rec_status = 0 AND deleted_flag = 0)"
        var inspSection:InspSection?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [sectionId]) {
            
            if rs.next() {
                let sectionId = Int(rs.int(forColumn: "section_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let sectionNameEn = rs.string(forColumn: "section_name_en")
                let sectionNameCn = rs.string(forColumn: "section_name_cn")
                let sectionNameFr = rs.string(forColumn: "section_name_fr") ?? ""
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let displayOrder = Int(rs.int(forColumn: "display_order"))
                let resultSetId = Int(rs.int(forColumn: "result_set_id"))
                let inputModeCode = rs.string(forColumn: "input_mode_code")
                let optionalEnableFlag = Int(rs.int(forColumn: "optional_enable_flag"))
                let adhoSelectFlag = Int(rs.int(forColumn: "adhoc_select_flag"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                inspSection = InspSection(taskId: 0, sectionId: sectionId, inspectSetupId: inspectSetupId, sectionNameEn: sectionNameEn!, sectionNameCn: sectionNameCn!, sectionNameFr: sectionNameFr, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, displayOrder: displayOrder, resultSetId: resultSetId, inputModeCode: inputModeCode!, optionalEnableFlag: optionalEnableFlag, adhocSelectFlag: adhoSelectFlag, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
            }
            }
            
            db.close()
            
            return inspSection
        }
        
        return nil
    }
    
    func getReqSectionIdByName(_ sectionName:String) ->Int {
        let sql = "SELECT section_id FROM inspect_section_mstr WHERE section_name_fr = ? OR section_name_en = ? OR section_name_cn = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var reqSecId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [sectionName,sectionName]) {
            
                if rs.next() {
                    reqSecId = Int(rs.int(forColumn: "section_id"))
                }
            }
            
            db.close()
        }
        return reqSecId
    }
    
    func getTaskDefectDataRecords(_ taskId:Int) ->[TaskInspDefectDataRecord]? {
        let sql = "SELECT * FROM task_defect_data_record WHERE task_id = ?"
        var taskDefectDataRecords = [TaskInspDefectDataRecord]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
            while rs.next() {
                
                let recordId = Int(rs.int(forColumn: "record_id"))
                let taskId = Int(rs.int(forColumn: "task_id"))
                let inspRecordId = Int(rs.string(forColumn: "inspect_record_id") ?? "0")
                let refRecordId = Int(rs.string(forColumn: "ref_record_id") ?? "0")
                let inspElmtId = Int(rs.string(forColumn: "inspect_element_id") ?? "0")
                let defectDesc = rs.string(forColumn: "defect_desc")
                let defectQtyCritical = Int(rs.int(forColumn: "defect_qty_critical"))
                let defectQtyMajor = Int(rs.int(forColumn: "defect_qty_major"))
                let defectQtyMinor = Int(rs.int(forColumn: "defect_qty_minor"))
                let defectQtyTotal = Int(rs.int(forColumn: "defect_qty_total"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let inspectElementDefectValueId = Int(rs.int(forColumn: "inspect_element_defect_value_id"))
                let inspectElementCaseValueId = Int(rs.int(forColumn: "inspect_element_case_value_id"))
                let defectRemarksOptionList = rs.string(forColumn: "defect_remarks_option_list")
                let othersRemark = rs.string(forColumn: "other_remarks")
                
                let taskDefectDataRecord = TaskInspDefectDataRecord(recordId: recordId, taskId: taskId, inspectRecordId: inspRecordId, refRecordId: refRecordId, inspectElementId: inspElmtId, defectDesc: defectDesc, defectQtyCritical: defectQtyCritical, defectQtyMajor: defectQtyMajor, defectQtyMinor: defectQtyMinor, defectQtyTotal: defectQtyTotal, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, inspectElementDefectValueId: inspectElementDefectValueId, inspectElementCaseValueId: inspectElementCaseValueId, defectRemarksOptionList: defectRemarksOptionList, othersRemark: othersRemark)
                
                taskDefectDataRecords.append(taskDefectDataRecord!)
            }
            }
            
            db.close()
            
            return taskDefectDataRecords
        }
        
        return nil
    }
    
    func getSectionIdByElementId(_ elmId:Int) ->Int {
        //let sql = "SELECT section_id FROM inspect_section_mstr AS ism INNER JOIN inspect_element_mstr AS iem ON ism.section_id = iem.inspect_section_id WHERE iem.element_id = ?"
        let sql = "SELECT inspect_section_id FROM inspect_section_element WHERE inspect_element_id = ?"
        var sectionId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [elmId]) {
            
                if rs.next() {
                
                    sectionId = Int(rs.int(forColumn: "inspect_section_id"))
                }
            }
            
            db.close()
        }
        
        return sectionId
    }
    
    func getPositionIdByElementId(_ elmId:Int, inputMode:String = _INPUTMODE04) ->Int {
        var sql = "SELECT inspect_position_id FROM inspect_position_element WHERE inspect_element_id = ?"
        
        if inputMode == _INPUTMODE02 {
            sql = "SELECT ipe.inspect_position_id FROM inspect_position_element ipe INNER JOIN task_inspect_data_record tidr ON ipe.inspect_position_id = tidr.inspect_position_id INNER JOIN  task_defect_data_record tddr ON tddr.inspect_record_id = tidr.record_id WHERE tddr.inspect_record_id = ?"
        }

        var positionId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [elmId]) {
                
                if rs.next() {
                    
                    positionId = Int(rs.int(forColumn: "inspect_position_id"))
                }
            }
            
            db.close()
        }
        
        return positionId
    }
    
    func getInputModeCodeByTaskDefectDataId(_ recordId:Int) ->String? {
        var sql = "SELECT input_mode_code FROM inspect_section_mstr AS ism INNER JOIN task_inspect_data_record AS tidr ON ism.section_id = tidr.inspect_section_id INNER JOIN task_defect_data_record AS tddr ON tidr.record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"//"SELECT input_mode_code FROM inspect_section_mstr AS ism INNER JOIN inspect_element_mstr AS iem ON ism.section_id = iem.inspect_section_id INNER JOIN task_inspect_data_record AS tidr ON iem.element_id = tidr.inspect_element_id INNER JOIN task_defect_data_record AS tddr ON tidr.record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"
        var inputMode = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [recordId]) {
            
            if rs.next() {
                inputMode = rs.string(forColumn: "input_mode_code") ?? ""
                
            }else{
                
                sql = "SELECT request_section_id FROM task_inspect_data_record AS tidr INNER JOIN task_defect_data_record AS tddr ON tidr.record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"
                
                let rs = db.executeQuery(sql, withArgumentsIn: [recordId])
                
                if (rs?.next())! {
                    let requestSecId = Int((rs?.int(forColumn: "request_section_id"))!)
                    
                    if requestSecId>0 {
                        inputMode = _INPUTMODE03
                    }
                }
            }
            }
            
            db.close()
        }
        
        return inputMode
    }
    
    func getSectionByTaskInspDataId(_ dataRecordId:Int) ->InspSection? {
        let sql = "SELECT * FROM inspect_section_mstr AS ism INNER JOIN task_inspect_data_record AS tidr ON ism.section_id = tidr.inspect_section_id WHERE tidr.record_id = ?"
        var inspSection:InspSection?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [dataRecordId]) {
            
            if rs.next() {
                let sectionId = Int(rs.int(forColumn: "section_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let sectionNameEn = rs.string(forColumn: "section_name_en")
                let sectionNameCn = rs.string(forColumn: "section_name_cn")
                let sectionNameFr = rs.string(forColumn: "section_name_fr") ?? ""
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let inspectTypeId = Int(rs.int(forColumn: "inspect_type_id"))
                let displayOrder = Int(rs.int(forColumn: "display_order"))
                let resultSetId = Int(rs.int(forColumn: "result_set_id"))
                let inputModeCode = rs.string(forColumn: "input_mode_code")
                let optionalEnableFlag = Int(rs.int(forColumn: "optional_enable_flag"))
                let adhoSelectFlag = Int(rs.int(forColumn: "adhoc_select_flag"))
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                inspSection = InspSection(taskId: 0, sectionId: sectionId, inspectSetupId: inspectSetupId, sectionNameEn: sectionNameEn!, sectionNameCn: sectionNameCn!, sectionNameFr: sectionNameFr, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, displayOrder: displayOrder, resultSetId: resultSetId, inputModeCode: inputModeCode!, optionalEnableFlag: optionalEnableFlag, adhocSelectFlag: adhoSelectFlag, recStatus: recStatus, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
            }
            }
            
            db.close()
            
            return inspSection
        }
        
        return nil
    }
    
    func updateTaskItem(_ taskItem:TaskItem) ->Bool {
        //let sql = "INSERT OR REPLACE INTO inspect_task_item('rowid','task_id','po_item_id','target_inspect_qty','avail_inspect_qty','inspect_enable_flag','create_user','create_date','modify_user','modify_date','sampling_qty') VALUES((SELECT rowid FROM inspect_task_item WHERE task_id = ? AND po_item_id = ?),?,?,?,?,?,?,?,?,?,?)"
        let sql = "UPDATE inspect_task_item SET po_item_id=?, avail_inspect_qty=?, inspect_enable_flag=?, create_user=?, create_date=?, modify_user=?, modify_date=?, sampling_qty=? WHERE task_id=? AND po_item_id=?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsIn: [taskItem.poItemId!,taskItem.availInspectQty!,taskItem.inspectEnableFlag!,taskItem.createUser!,taskItem.createDate!,taskItem.modifyUser!,taskItem.modifyDate!,taskItem.samplingQty!,taskItem.taskId!,taskItem.poItemId!])
            
            db.close()
            return rs
        }
        
        return false
    }
    
    func deleteTaskInspDataRecordById(_ taskInspDataRocordId:Int) ->Bool {
        let sql = "DELETE FROM task_inspect_data_record WHERE record_id = ?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsIn: [taskInspDataRocordId])
            
            db.close()
            
            if !rs {
                return false
            }
        }
        
        return true
    }
    
    func deletePOItemByIds(_ poItemId:Int, taskId:Int) ->Bool {
        let sql = "DELETE FROM inspect_task_item WHERE po_item_id = ? AND task_id = ?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsIn: [poItemId, taskId])
            
            db.close()
            
            if !rs {
                return false
            }
        }
        
        return true
    }
    
    func deleteTaskInspDefectDataRecordById(_ id:Int) ->Bool {
        let sql = "DELETE FROM task_defect_data_record WHERE record_id = ?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsIn: [id])
            
            db.close()
            
            if !rs {
                return false
            }
        }
        
        return true
    }
    
    func insertTaskInspDataRecord(_ taskInspDataRecord:TaskInspDataRecord) ->Int {
        let sql = "INSERT OR REPLACE INTO task_inspect_data_record  ('record_id','task_id','ref_record_id','inspect_section_id','inspect_element_id','inspect_position_id','inspect_position_desc','inspect_detail','inspect_remarks','result_value_id','create_user','create_date','modify_user','modify_date','request_section_id','request_element_desc') VALUES ((SELECT record_id FROM task_inspect_data_record WHERE record_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        var taskInspDataRecordId = 0
        
        if db.open() {
            db.executeUpdate(sql, withArgumentsIn: [taskInspDataRecord.recordId!,taskInspDataRecord.taskId!,taskInspDataRecord.refRecordId!,taskInspDataRecord.inspectSectionId!,taskInspDataRecord.inspectElementId!,taskInspDataRecord.inspectPositionId!,taskInspDataRecord.inspectPositionDesc!,taskInspDataRecord.inspectDetail!,taskInspDataRecord.inspectRemarks!,taskInspDataRecord.resultValueId,taskInspDataRecord.createUser!,taskInspDataRecord.createDate!,taskInspDataRecord.modifyUser!,taskInspDataRecord.modifyDate!,notNilObject(taskInspDataRecord.requestSectionId as AnyObject)!,notNilObject(taskInspDataRecord.requestElementDesc as AnyObject)!])
        
            taskInspDataRecordId = Int(db.lastInsertRowId)
            
            
            db.close()
        }
        
        return taskInspDataRecordId
    }
    
    func getInspTypeIdByName(_ inspTypeName:String) ->Int {
        let sql = "SELECT type_id FROM inspect_type_mstr WHERE type_name_fr = ? OR type_name_en = ? OR type_name_cn =? AND (rec_status = 0 AND deleted_flag = 0)"
        var inspTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspTypeName, inspTypeName, inspTypeName]) {
                if rs.next() {
                    inspTypeId = Int(rs.int(forColumn: "type_id"))
                }
            }
            
            db.close()
        }
        
        return inspTypeId
    }
    
    func getProdTypeIdByName(_ prodTypeName:String) ->Int {
        let sql = "SELECT type_id FROM prod_type_mstr WHERE type_name_fr = ? OR type_name_en = ? OR type_name_cn = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var prodTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [prodTypeName, prodTypeName, prodTypeName]) {
                if rs.next() {
                    prodTypeId = Int(rs.int(forColumn: "type_id"))
                }
            }
            
            db.close()
        }
        
        return prodTypeId
    }
    
    func getCatItemCountById(_ taskId:Int, sectionId:Int) ->Int {
        let sql = "SELECT COUNT(tidr.record_id) AS record_cnt FROM task_inspect_data_record tidr INNER JOIN inspect_task it ON tidr.task_id = it.task_id INNER JOIN inspect_element_mstr iem ON tidr.inspect_element_id = iem.element_id INNER JOIN inspect_position_mstr ipm ON tidr.inspect_position_id = ipm.position_id WHERE it.task_id = ? AND tidr.inspect_section_id = ? AND ((it.task_status < 4 AND iem.rec_status = 0 AND iem.deleted_flag <> 1 AND ipm.rec_status = 0 AND ipm.deleted_flag <>1) OR it.task_status > 3)"
        var itemCount = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, sectionId]) {
                if rs.next() {
                    itemCount = Int(rs.int(forColumn: "record_cnt"))
                }
            }
            
            db.close()
        }
        
        return itemCount
    }
    
    func deleteTaskById(_ taskId:Int) ->Bool {
        
        if db.open() {
            db.beginTransaction()
            
            //1. Delete From Inspect Task
            var sql = "DELETE FROM inspect_task WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //2. Delete From Inspect Task Inspector
            sql = "DELETE FROM inspect_task_inspector WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //3. Delete From Inspect Task Item
            sql = "DELETE FROM inspect_task_item WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //4. Delete From Inspect Task Item
            sql = "DELETE FROM inspect_task_item WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //5. Delete From Task Defect Data Record
            sql = "DELETE FROM task_defect_data_record WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //6. Delete From Task Inspect Position Point
            sql = "DELETE FROM task_inspect_position_point WHERE inspect_record_id IN (SELECT record_id FROM task_inspect_data_record WHERE task_id = ?)"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //7. Delete From Task Inspect Data Record
            sql = "DELETE FROM task_inspect_data_record WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //8. Delete From Task Inspect Field Value
            sql = "DELETE FROM task_inspect_field_value WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //9. Delete From Task Inspect Photo File
            sql = "DELETE FROM task_inspect_photo_file WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsIn: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            db.commit()
            db.close()
        }
        
        return true
    }
    
    func setConfirmedTaskUploaded() ->Bool {
        let sql = "UPDATE inspect_task SET task_status = ? WHERE task_status = ?"
        let taskStatus_Uploaded = GetTaskStatusId(caseId: "Uploaded").rawValue
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: [taskStatus_Uploaded, GetTaskStatusId(caseId: "Confirmed").rawValue]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getResultSetIdByTmplId(_ tmplId:Int) ->Int {
        let sql = "SELECT result_set_id FROM inspect_task_tmpl_mstr WHERE tmpl_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultSetId = 1
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [tmplId]) {
                if rs.next() {
                    resultSetId = Int(rs.int(forColumn: "result_set_id"))
                }
            }
            
            db.close()
        }
        
        return resultSetId
    }
    
    func updateTaskInspectionDate(_ bookingNo:String, inspectionDate:String, taskId:Int) -> Bool {
        let sql = "UPDATE inspect_task SET inspection_no = ?, inspection_date = ?, report_inspector_id = ? WHERE task_id = ?"
        var result = false
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: [bookingNo, inspectionDate, (Cache_Inspector?.inspectorId)!, taskId]) {
                result = true
            }
            
            db.close()
            
        }
        
        return result
    }
    
    func updateTaskItemQty(_ availInspQty:Int, samplingQty:Int, taskId:Int, poItemId:Int) ->Bool {
        let sql = "UPDATE inspect_task_item SET avail_inspect_qty = ? AND sampling_qty = ? WHERE task_id = ? AND po_item_id = ?"
        var result = false
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: [availInspQty, samplingQty, taskId, poItemId]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getAllTaskBrands() ->[Brand] {
        let sql = "SELECT * FROM brand_mstr bm INNER JOIN vdr_brand_map vbm ON bm.brand_id = vbm.brand_id INNER JOIN vdr_location_mstr vlm ON vbm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE (bm.rec_status = 0 AND bm.deleted_flag = 0)"
        
        var brands = [Brand]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                
                while rs.next() {
                    
                    let dataEnv = Int(rs.int(forColumn: "data_env"))
                    let brandId = Int(rs.int(forColumn: "brand_id"))
                    let brandCode = rs.string(forColumn: "brand_code")
                    let brandName = rs.string(forColumn: "brand_name")
                    let recStatus = Int(rs.int(forColumn: "rec_status"))
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                    let deleteUser = rs.string(forColumn: "delete_user")
                    let deleteDate = rs.string(forColumn: "delete_date")
                    
                    let brand = Brand(dataEnv:dataEnv,brandId:brandId,brandCode:brandCode,brandName:brandName,recStatus:recStatus,createUser:createUser,createDate:createDate,modifyUser:modifyUser,modifyDate:modifyDate,deletedFlag:deletedFlag,deleteUser:deleteUser,deleteDate:deleteDate)
                    
                    brands.append(brand)
                }
            }
            
            db.close()
        }
        
        return brands
    }
    
    func getAllTaskBrandCodes() ->[String] {
        let sql = "SELECT DISTINCT(brand_code) FROM brand_mstr bm INNER JOIN vdr_brand_map vbm ON bm.brand_id = vbm.brand_id INNER JOIN vdr_location_mstr vlm ON vbm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE (bm.rec_status = 0 AND bm.deleted_flag = 0)"
        
        var brands = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                
                while rs.next() {
                    
                    let brandCode = rs.string(forColumn: "brand_code")
                    
                    brands.append(brandCode!)
                }
            }
            
            db.close()
        }
        
        return brands
    }
    
    func getAllTaskBrandNames() ->[String] {
        let sql = "SELECT DISTINCT(brand_name) FROM brand_mstr bm INNER JOIN vdr_brand_map vbm ON bm.brand_id = vbm.brand_id INNER JOIN vdr_location_mstr vlm ON vbm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE (bm.rec_status = 0 AND bm.deleted_flag = 0)"
        
        var brands = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                
                while rs.next() {
                    
                    let brandCode = rs.string(forColumn: "brand_name")
                    
                    brands.append(brandCode!)
                }
            }
            
            db.close()
        }
        
        return brands
    }
    
    func getAllTaskBrandCodes(_ inputCode:String) ->[String] {
        let sql = "SELECT DISTINCT(brand_code) FROM brand_mstr bm INNER JOIN vdr_brand_map vbm ON bm.brand_id = vbm.brand_id INNER JOIN vdr_location_mstr vlm ON vbm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE brand_Code LIKE ? AND (bm.rec_status = 0 AND bm.deleted_flag = 0)"
        
        var brands = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:["%"+inputCode+"%"]) {
                
                while rs.next() {
                    
                    let brandCode = rs.string(forColumn: "brand_code")
                    
                    brands.append(brandCode!)
                }
            }
            
            db.close()
        }
        
        return brands
    }
    
    func getAllTaskBrandNames(_ inputCode:String) ->[String] {
        let sql = "SELECT DISTINCT(brand_name) FROM brand_mstr bm INNER JOIN vdr_brand_map vbm ON bm.brand_id = vbm.brand_id INNER JOIN vdr_location_mstr vlm ON vbm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE brand_Code LIKE ? AND (bm.rec_status = 0 AND bm.deleted_flag = 0)"
        
        var brands = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:["%"+inputCode+"%"]) {
                
                while rs.next() {
                    
                    let brandCode = rs.string(forColumn: "brand_name")
                    
                    brands.append(brandCode!)
                }
            }
            
            db.close()
        }
        
        return brands
    }
    
    func getAllTaskBookingNo(_ inputCode:String) ->[String] {
        let sql = "SELECT booking_no, inspection_no FROM inspect_task WHERE booking_no LIKE ? OR inspection_no LIKE ? AND (rec_status = 0 AND deleted_flag = 0)"
        
        var bookingNos = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:["%"+inputCode+"%", "%"+inputCode+"%"]) {
                
                while rs.next() {
                    
                    let bookingNo = rs.string(forColumn: "booking_no") == "" ? rs.string(forColumn: "inspection_no") : rs.string(forColumn: "booking_no")
                    
                    bookingNos.append(bookingNo!)
                }
            }
            
            db.close()
        }
        
        return bookingNos
    }
    
    func getBookingNoByTaskId(_ taskId:Int) ->String {
        let sql = "SELECT booking_no, inspection_no FROM inspect_task WHERE task_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var bookingNo = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:[taskId]) {
                
                if rs.next() {
                    bookingNo = (rs.string(forColumn: "booking_no") != "" ? rs.string(forColumn: "booking_no") : rs.string(forColumn: "inspection_no")) ?? ""
                }
            }
            
            db.close()
        }
        
        return bookingNo
    }
    
    func didChangeInTaskPoItems(_ taskId:Int, poItemId:Int) ->Bool {
        let sql = "SELECT * FROM inspect_task_item WHERE task_id = ? AND po_item_id = ? AND ((avail_inspect_qty = '' AND sampling_qty = '') OR (avail_inspect_qty < 1 AND sampling_qty < 1)) AND inspect_enable_flag = 1"
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, poItemId]) {
                if rs.next() {
                    return false
                }
            }
        
            db.close()
        }
        
        return true
    }
    
    func checkIfKeepPendingTaskStatus(_ taskId:Int) ->Bool {
        var sql = ""
        
        if db.open() {
            
            sql = "SELECT iem.required_element_flag FROM task_inspect_data_record tidr LEFT JOIN inspect_element_mstr iem ON tidr.inspect_element_id = iem.element_id WHERE tidr.task_id = ?"
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
                
                while rs.next() {
                    let requiredElementFlag = rs.int(forColumn: "required_element_flag")
                    
                    if Int(requiredElementFlag) < 1 {
                        
                        db.close()
                        return false
                    }
                }
            }
            
            sql = "SELECT 1 FROM task_defect_data_record WHERE task_id = ?"
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
                
                if rs.next() {
                    
                    db.close()
                    return false
                }
            }
            
            sql = "SELECT 1 FROM task_inspect_photo_file WHERE task_id = ?"
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
                
                if rs.next() {
                    
                    db.close()
                    return false
                }
            }
            
            db.close()
        }
        
        return true
    }
    
    func updateTaskStatusByTaskId(_ taskStatus:Int, taskId:Int) ->Bool {
        let sql = "UPDATE inspect_task SET task_status = ? WHERE task_id = ?"
        
        if db.open() {
        
            if !db.executeUpdate(sql, withArgumentsIn: [taskStatus, taskId]) {
                
                db.close()
                return false
            }
         
            db.close()
        }
        
        return true
    }
    
    func getLastVdrConfirmerNameToday(_ vdrLocId:Int) ->String {
        //let sql = "SELECT vdr_sign_name FROM inspect_task WHERE task_status = ? AND vdr_location_id = ? AND vdr_sign_date >= date('now','-1 day')"
        let sql = "SELECT vdr_sign_name FROM inspect_task WHERE task_status >= ? AND vdr_location_id = ? ORDER BY vdr_sign_date DESC LIMIT 0,1"
        var vdrConfirmerName = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [GetTaskStatusId(caseId: "Confirmed").rawValue, vdrLocId]) {
                if rs.next() {
                    if rs.string(forColumn: "vdr_sign_name") != nil && rs.string(forColumn: "vdr_sign_name") != "" {
                        vdrConfirmerName = rs.string(forColumn: "vdr_sign_name") ?? ""
                    }
                }
            }
            
            db.close()
        }
        
        return vdrConfirmerName
    }
    
    func getVdrConfirmerNameByTaskId(_ taskId:Int) ->String {
        let sql = "SELECT vlm.vdr_sign_name FROM inspect_task it INNER JOIN vdr_location_mstr vlm ON it.vdr_location_id = vlm.location_id WHERE it.task_id = ?"
        var vdrConfirmerName = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
                if rs.next() {
                    if rs.string(forColumn: "vdr_sign_name") != nil && rs.string(forColumn: "vdr_sign_name") != "" {
                        vdrConfirmerName = rs.string(forColumn: "vdr_sign_name") ?? ""
                    }
                }
            }
            
            db.close()
        }
        
        return vdrConfirmerName
    }
    
    func ifPhotosAddedInTask(_ taskId:Int) ->Bool {
        let sql = "SELECT 1 FROM task_inspect_photo_file WHERE task_id = ?"
        var result = false
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
                if rs.next() {
                    result = true
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func getAllStyleNoByValue(_ inputValue:String) ->[String] {
        let sql = "SELECT DISTINCT(style_no) FROM fgpo_line_item fli INNER JOIN inspect_task_item iti ON fli.item_id = iti.po_item_id WHERE style_no LIKE ?"
        var styleNoList = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["%"+inputValue+"%"]) {
                while rs.next() {
                    styleNoList.append(rs.string(forColumn: "style_no") ?? "")
                }
            }
            
            db.close()
        }
        
        return styleNoList
    }
    
    func getAllInvalidTaskId() ->[Int] {
        let sql = "SELECT task_id FROM inspect_task WHERE prod_type_id < 1 AND inspect_type_id < 1 AND tmpl_id < 1"
        var ids = [Int]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    ids.append(Int(rs.int(forColumn: "task_id")))
                }
            }
            
            db.close()
        }
        
        return ids
    }
    
    func getPositionIdByElementIdForINPUT02(_ recordId:Int) ->Int {
        let sql = "SELECT ipe.inspect_position_id FROM inspect_position_element ipe INNER JOIN task_inspect_data_record tidr ON ipe.inspect_position_id = tidr.inspect_position_id INNER JOIN  task_defect_data_record tddr ON tddr.inspect_record_id = tidr.record_id WHERE tddr.inspect_record_id = ?"
        var positionId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [recordId]) {
                
                if rs.next() {
                    
                    positionId = Int(rs.int(forColumn: "inspect_position_id"))
                }
            }
            
            db.close()
        }
        
        return positionId
    }
    
    func deleteTaskDefectDataPPTRecordsByInspItemId(_ id:Int) ->Bool {
        let sql = "DELETE FROM task_inspect_position_point WHERE inspect_record_id = ?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsIn: [id])
            
            db.close()
            
            if !rs {
                return false
            }
        }
        
        return true
    }
    
    func getInptElementDetailSelectValueByElementId(_ elementId: Int) ->[String] {
        
        let sql = "SELECT * FROM inspect_element_detail_select_val WHERE element_id = ? ORDER BY select_text_en ASC"
        
        var values = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:[elementId]) {
                
                while rs.next() {
                    
                    let value = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "select_text_en"), .zh: rs.string(forColumn: "select_text_cn"), .fr: rs.string(forColumn: "select_text_fr")])
                    
                    values.append(value)
                    
                }
            }
            
            db.close()
        }
        return values
        
    }

    func getQCRemarksOptionList(_ valueCode:String="0") ->[DropdownValue] {
        
        let valueCode = getValueCodeByResultId(valueCode)
        //let sql = "SELECT option_id, option_text_en, option_text_zh FROM task_selection_option_mstr WHERE selection_type = 2"
        let sql = "SELECT result_code_match_list, option_id, option_text_en, option_text_zh, option_text_fr FROM task_selection_option_mstr tsom WHERE tsom.selection_type = 2 AND tsom.rec_status = 0 AND tsom.deleted_flag = 0 AND tsom.data_env IN (SELECT data_env FROM prod_type_mstr ptm INNER JOIN inspector_mstr im ON ptm.type_id = im.prod_type_id WHERE im.deleted_flag = 0 AND ptm.rec_status = 0 AND ptm.deleted_flag = 0 AND im.inspector_id = ?) AND (tsom.result_code_match_list IS NULL OR tsom.result_code_match_list LIKE ? OR tsom.result_code_match_list = '') ORDER BY tsom.display_order ASC"
        var values = [DropdownValue]()
            
        if db.open() {
                
            if let rs = db.executeQuery(sql, withArgumentsIn: [Cache_Inspector?.inspectorId ?? 0, "%"+valueCode+"%"]) {
                while rs.next() {
                        
                    let id = Int(rs.int(forColumn: "option_id"))
                    let nameEn = rs.string(forColumn: "option_text_en")
                    let nameCn = rs.string(forColumn: "option_text_zh")
                    let nameFr = rs.string(forColumn: "option_text_fr")
                    let value = DropdownValue(valueId: id, valueNameEn: nameEn, valueNameCn: nameCn, valueNameFr: nameFr)
                        
                    values.append(value)
                }
            }
                
            db.close()
        }
            
        return values
    }
    
    func getAdditionalAdministrativeItemOptionList(_ valueCode:String="0") ->[DropdownValue] {
        
        let valueCode = getValueCodeByResultId(valueCode)
        //let sql = "SELECT option_id, option_text_en, option_text_zh FROM task_selection_option_mstr WHERE selection_type = 3"
        let sql = "SELECT result_code_match_list, option_id, option_text_en, option_text_zh, option_text_fr FROM task_selection_option_mstr tsom WHERE tsom.selection_type = 3 AND tsom.rec_status = 0 AND tsom.deleted_flag = 0 AND tsom.data_env IN (SELECT data_env FROM prod_type_mstr ptm INNER JOIN inspector_mstr im ON ptm.type_id = im.prod_type_id WHERE im.deleted_flag = 0 AND ptm.rec_status = 0 AND ptm.deleted_flag = 0 AND im.inspector_id = ?) AND (tsom.result_code_match_list IS NULL OR tsom.result_code_match_list LIKE ? OR tsom.result_code_match_list = '') ORDER BY tsom.display_order ASC"
        var values = [DropdownValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [Cache_Inspector?.inspectorId ?? 0, "%"+valueCode+"%"]) {
                while rs.next() {
                    
                    let id = Int(rs.int(forColumn: "option_id"))
                    let nameEn = rs.string(forColumn: "option_text_en")
                    let nameCn = rs.string(forColumn: "option_text_zh")
                    let nameFr = rs.string(forColumn: "option_text_fr")
                    let value = DropdownValue(valueId: id, valueNameEn: nameEn, valueNameCn: nameCn, valueNameFr: nameFr)
                    
                    values.append(value)
                }
            }
            
            db.close()
        }
        
        return values
    }
    
    func getValueCodeByResultId(_ valueId:String) ->String {
        let sql = "SELECT value_code FROM result_value_mstr WHERE value_id = ?"
        var valueCode = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [valueId]) {
                if rs.next() {
                    valueCode = rs.string(forColumn: "value_code") ?? ""
                }
            }
            
            db.close()
        }
        
        return valueCode

    }
    
    func getRemarksOptionList(_ valueCode:String="0") ->[DropdownValue] {
        
        let valueCode = getValueCodeByResultId(valueCode)
        
        //let sql = "SELECT option_id, option_text_en, option_text_zh FROM task_selection_option_mstr WHERE selection_type = 1"
        let sql = "SELECT result_code_match_list, option_id, option_text_en, option_text_zh, option_text_fr FROM task_selection_option_mstr tsom WHERE tsom.selection_type = 1 AND tsom.rec_status = 0 AND tsom.deleted_flag = 0 AND tsom.data_env IN (SELECT data_env FROM prod_type_mstr ptm INNER JOIN inspector_mstr im ON ptm.type_id = im.prod_type_id WHERE im.deleted_flag = 0 AND ptm.rec_status = 0 AND ptm.deleted_flag = 0 AND im.inspector_id = ?) AND (tsom.result_code_match_list IS NULL OR tsom.result_code_match_list LIKE ? OR tsom.result_code_match_list = '') ORDER BY tsom.display_order ASC"
        var values = [DropdownValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [Cache_Inspector?.inspectorId ?? 0, "%"+valueCode+"%"]) {
                while rs.next() {
                    
                    let id = Int(rs.int(forColumn: "option_id"))
                    let nameEn = rs.string(forColumn: "option_text_en")
                    let nameCn = rs.string(forColumn: "option_text_zh")
                    let nameFr = rs.string(forColumn: "option_text_fr")
                    let value = DropdownValue(valueId: id, valueNameEn: nameEn, valueNameCn: nameCn, valueNameFr: nameFr)
                    
                    values.append(value)
                }
            }
            
            db.close()
        }
        
        return values
    }
    
    func getRemarksOptionValueById(_ Ids:[String]) ->String {
        
        var sql = "SELECT option_text_en, option_text_zh, option_text_fr FROM task_selection_option_mstr WHERE option_id IN ("
        var textValue = ""
        sql += Ids.joined(separator: ",") + ")"
        
        if db.open() {
            
            var count = 0
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    textValue += MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "option_text_en"), .zh: rs.string(forColumn: "option_text_zh"), .fr: rs.string(forColumn: "option_text_fr")]) + ","
                    count += 1
                }
                
                if textValue != "" {
                    textValue += ")"
                }
            }
            
            db.close()
        }
        
        return textValue.replacingOccurrences(of: ",)", with: "")
    }
    
    func isNeedShowQCInfoPage(_ taskId:Int) ->Bool {
        let sql = "SELECT * FROM inspect_task_qc_info WHERE ref_task_id = ?"
        var result = false
        if db.open() {
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
                if rs.next() {
                    result = true
                }
            }
            db.close()
        }
        return result
    }
    
    func isNeedCompleteDefectPoint(_ resultValueId:Int) -> Bool {
        let sql = "SELECT defect_gen_flag FROM result_value_mstr WHERE value_id = ?"
        var result = false
        if db.open() {
            if let rs = db.executeQuery(sql, withArgumentsIn: [resultValueId]) {
                result = rs.next() && Int(rs.int(forColumn: "defect_gen_flag")) > 0
            }
            db.close()
        }
        return result
    }
    
    func isNeedAddPhotoForInspectItem(_ resultValue:String) -> Bool {
        let sql = "SELECT defect_gen_flag FROM result_value_mstr WHERE value_name_fr = ? OR value_name_cn = ? OR value_name_en = ?"
        var result = false
        if db.open() {
            if let rs = db.executeQuery(sql, withArgumentsIn: [resultValue, resultValue, resultValue]) {
                result = rs.next() && Int(rs.int(forColumn: "defect_gen_flag")) > 0
            }
            db.close()
        }
        return result
    }
}
