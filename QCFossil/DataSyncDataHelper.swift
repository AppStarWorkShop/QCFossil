//
//  DataSyncDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 3/6/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class DataSyncDataHelper:DataHelperMaster {
    
    @discardableResult
    func cleanDBTableByName(_ tableName:String) ->Bool {
        let sql = "DELETE FROM " + tableName
        var result = false
        
        let noDeleteTables = ["inspect_task_item","inspect_task"]
        
        if noDeleteTables.contains(tableName) || db.executeUpdate(sql, withArgumentsIn: []) {
                result = true
        }
        
        return result
    }
    /*
    func clearDBTables() ->Bool {
        if db.open() {
            db.beginTransaction()
            
            //1. clean table
            for _DS_DL_API_NAME in _DS_DL_API {
                for (key, value) in _DS_DL_API_NAME["ACTIONTABLES"] as! Dictionary<String, String> {
                    if key != "" {
                        
                        if !cleanDBTableByName(value) {
                            db.rollback()
                            db.close()
                            return false
                        }
                    }
                }
            }
        
            db.commit()
            db.close()
        }
        
        return true
    }*/
    
    
    func clearDBTables(_ _DS_TABLES:Dictionary<String, String>) ->Bool {
        if db.open() {
            db.beginTransaction()
            
            //1. clean table
            for (key, value) in _DS_TABLES {
                if key != "" {
                    
                    if !cleanDBTableByName(value) {
                        db.rollback()
                        db.close()
                        return false
                    }
                }
                
            }
            
            db.commit()
            db.close()
        }
        
        return true
    }
    
    func updateTableRecordsByScript(_ vc:DataSyncViewController, apiName:String, sqlScript:[String], handler:(Bool)-> Void) {
        
        if db.open() {
            db.beginTransaction()
            
            if apiName == "_DS_FGPODATA" {
                cleanDBTableByName("fgpo_line_item WHERE item_id NOT IN (SELECT po_item_id FROM inspect_task_item)")
                vc.updateProgressBar(0.7)
            } else if apiName == "_DS_MSTRDATA" {
//                let alterSql = "CREATE TABLE vdr_brand_map2 (data_env varchar(30) not null, vdr_id numeric(10,0) not null, brand_id numeric(10,0) not null, create_user varchar(30) not null, create_date datetime not null, modify_user varchar(30) not null, modify_date datetime not null);INSERT INTO vdr_brand_map2 (data_env, vdr_id, brand_id, create_user, create_date, modify_user, modify_date) SELECT data_env, vdr_id, brand_id, create_user, create_date, modify_user, modify_date FROM vdr_brand_map; DROP TABLE vdr_brand_map; ALTER TABLE vdr_brand_map2 RENAME TO vdr_brand_map;"
//                db.executeStatements(alterSql)
            }
            
            for sql in sqlScript {
            
            // batch update
                if !db.executeUpdate(sql, withArgumentsIn: []) {
    //            if db.executeStatements(sqlScript.joined(separator:";")) {

                    vc.errorMsg += "Error in \(apiName)\n"
                    vc.errorMsg += "Error Sql Script: \(sql)\n"
                    vc.errorMsg += "Sqlite Error: \(db.lastError())\n ErrorCode: \(db.lastErrorCode())\n ErrorMessage: \(db.lastErrorMessage())"
                    
                    db.rollback()
                    db.close()
                        
                    handler(false)
                }
            }
            
            db.commit()
            db.close()
            
            handler(true)
        }
    }
    
    func shouldSkipTaskData(_ objId:Int) ->Bool {
        
        if db.open() {
            let sql = "SELECT 1 FROM inspect_task WHERE ref_task_id = ?"
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [objId]) {
                
                if rs.next() {
                    
                    db.close()
                    return false
                }
            }
            
            db.close()
        }
        
        return true
    }
    
    func selectTaskIdsCanDelete() ->[Int] {
        var taskIds = [Int]()
        
        if db.open() {
            
            let sql = "SELECT task_id FROM inspect_task WHERE task_status <> ? AND app_ready_purge_date <> ? AND app_ready_purge_date IS NOT NULL"
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [GetTaskStatusId(caseId: "Confirmed").rawValue, ""]) {
                
                while rs.next() {
                    let taskId = Int(rs.int(forColumn: "task_id"))
                    taskIds.append(taskId)
                }
            }
            
            db.close()
        }
        
        return taskIds
    }
    
    func getAllInspectTasks(_ tasklist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        var tasklist = tasklist
        let sql = "SELECT * FROM inspect_task WHERE ((task_status = ? AND confirm_upload_date IS NULL) OR task_status = ?) AND report_inspector_id = ?"
        var tasks = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue, (Cache_Inspector?.inspectorId)!]) {
                
                while rs.next() {
                    
                    for (key,_) in tasklist {
                        
                        tasklist[key] = rs.string(forColumn: key)
                        
                    }
                    
                    tasks.append(tasklist)
                }
            }
            
            db.close()
        }
        
        return tasks
    }
    
    func getAllInspectTaskInspectors(_ taskInspectorlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        var taskInspectorlist = taskInspectorlist
        let sql = "SELECT * FROM inspect_task_inspector iti INNER JOIN inspect_task it ON iti.task_id = it.task_id WHERE inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskInspectors = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskInspectorlist {
                        
                        taskInspectorlist[key] = rs.string(forColumn: key)
                        
                    }
                    
                    taskInspectors.append(taskInspectorlist)
                }
            }
            
            db.close()
        }
        
        return taskInspectors
    }
 
    func getAllInspectTaskItems(_ taskItemlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        var taskItemlist = taskItemlist
        //let sql = "SELECT * FROM inspect_task_item"
        let sql = "SELECT iti.* FROM inspect_task_item iti INNER JOIN inspect_task it ON iti.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskItems = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskItemlist {
                        
                        if let value = rs.string(forColumn: key) {
                            taskItemlist[key] = value
                        } else {
                            taskItemlist[key] = ""
                        }
                    }
                    
                    taskItems.append(taskItemlist)
                }
            }
            
            db.close()
        }
        
        return taskItems
    }
    
    func getAllInspectTaskIFVs(_ taskIFVlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        var taskIFVlist = taskIFVlist
        let sql = "SELECT * FROM task_inspect_field_value tifv INNER JOIN inspect_task it ON tifv.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskIFVs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskIFVlist {
                        
                        taskIFVlist[key] = rs.string(forColumn: key)
                        
                    }
                    
                    taskIFVs.append(taskIFVlist)
                }
            }
            
            db.close()
        }
        
        return taskIFVs
    }
    
    func getAllInspectTaskIDRs(_ taskIDRlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        var taskIDRlist = taskIDRlist
        //let sql = "SELECT * FROM task_inspect_data_record"
        let sql = "SELECT tidr.* FROM task_inspect_data_record tidr INNER JOIN inspect_task it ON tidr.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskIDRs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskIDRlist {
                        
                        if let value = rs.string(forColumn: key) {
                            taskIDRlist[key] = value
                        } else {
                            taskIDRlist[key] = ""
                        }
                    }
                    
                    taskIDRs.append(taskIDRlist)
                }
            }
            
            db.close()
        }
        
        return taskIDRs
    }
    
    func getAllInspectTaskIPPs(_ taskIPPlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        var taskIPPlist = taskIPPlist
        let sql = "SELECT tipp.* FROM task_inspect_position_point tipp INNER JOIN task_inspect_data_record tidr ON tipp.inspect_record_id = tidr.record_id INNER JOIN inspect_task it ON tidr.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskIPPs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskIPPlist {
                        
                        taskIPPlist[key] = rs.string(forColumn: key)
                        
                    }
                    
                    taskIPPs.append(taskIPPlist)
                }
            }
            
            db.close()
        }
        
        return taskIPPs
    }
    
    func getAllInspectTaskDDRs(_ taskDDRlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        var taskDDRlist = taskDDRlist
        //let sql = "SELECT * FROM task_defect_data_record"
        let sql = "SELECT tddr.* FROM task_defect_data_record tddr INNER JOIN inspect_task it ON tddr.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskDDRs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskDDRlist {
                        
                        taskDDRlist[key] = rs.string(forColumn: key)
                        
                    }
                    
                    taskDDRs.append(taskDDRlist)
                }
            }
            
            db.close()
        }
        
        return taskDDRs
    }
    
    func getAllInspectTaskIPFs(_ taskIPFlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        var taskIPFlist = taskIPFlist
        //let sql = "SELECT * FROM task_inspect_photo_file"
        let sql = "SELECT tipf.* FROM task_inspect_photo_file tipf INNER JOIN inspect_task it ON tipf.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)";
        var taskIPFs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskIPFlist {
                        
                        taskIPFlist[key] = rs.string(forColumn: key)
                        
                    }
                    
                    taskIPFs.append(taskIPFlist)
                }
            }
            
            db.close()
        }
        
        return taskIPFs
    }
    
    func getAllConfirmedTaskIds() ->[Int] {
        let sql = "SELECT task_id FROM inspect_task WHERE task_status = ? AND confirm_upload_date IS NULL ORDER BY modify_date ASC"
        var taskIds = [Int]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [GetTaskStatusId(caseId: "Confirmed").rawValue/*, GetTaskStatusId(caseId: "Uploaded").rawValue*/]) {
                
                while rs.next() {
                    let taskId = Int(rs.int(forColumn: "task_id"))
                    taskIds.append(taskId)
                }
            }
            
            db.close()
        }
        
        return taskIds
    }
    
    func getAllPhotos() ->[Photo] {
        //Task Status is 2, mean Confirmed Task
        let sql = "SELECT * FROM task_inspect_photo_file tipf INNER JOIN inspect_task it ON it.task_id = tipf.task_id WHERE tipf.upload_date IS NULL AND EXISTS (SELECT 1 FROM inspect_task it WHERE it.task_id = tipf.task_id AND it.confirm_upload_date IS NOT NULL AND it.task_status = 4) ORDER BY tipf.task_id ASC, tipf.create_date ASC"
        var photos = [Photo]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                
                while rs.next() {
                    
                    //Photo Table Data
                    let photoId = Int(rs.int(forColumn: "photo_id"))
                    let taskId = Int(rs.int(forColumn: "task_id"))
                    let refPhotoId = Int(rs.int(forColumn: "ref_photo_id"))
                    let orgFileName = rs.string(forColumn: "org_filename")
                    let photoFile = rs.string(forColumn: "photo_file")
                    let thumbFile = rs.string(forColumn: "thumb_file")
                    let photoDesc = rs.string(forColumn: "photo_desc")
                    let dataRecordId = Int(rs.int(forColumn: "data_record_id"))
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let dataType = Int(rs.int(forColumn: "data_type"))
                    let refTaskId = Int(rs.int(forColumn: "ref_task_id"))
                    
                    //Task Data
                    let taskBookingNo = rs.string(forColumn: "booking_no") != "" ? rs.string(forColumn: "booking_no") : rs.string(forColumn: "inspection_no")
                    
                    let photo = Photo(photo: nil, photoFilename: photoFile!, taskId: taskId, photoFile: photoFile!, refTaskId: refTaskId)
                    
                    photo?.photoId = photoId
                    photo?.refPhotoId = refPhotoId
                    photo?.orgFileName = orgFileName
                    photo?.thumbFile = thumbFile
                    photo?.photoDesc = photoDesc
                    photo?.dataRecordId = dataRecordId
                    photo?.createUser = createUser
                    photo?.createDate = createDate
                    photo?.modifyUser = modifyUser
                    photo?.modifyDate = modifyDate
                    photo?.dataType = dataType
                    photo?.taskBookingNo = taskBookingNo
                    
                    photos.append(photo!)
                }
            }
            
            db.close()
        }
        
        return photos
    }
    
    func updateTaskStatus(_ taskId:Int, status:Int, refuseDesc:String, ref_task_id:Int) ->Int {
        /*
            If status = 5 (Uploaded) from Data Upload WS JSON, run below SQL to check any photo(s) under the task...
                SELECT COUNT(1) FROM task_inspect_photo_file WHERE task_id = ?
                If COUNT > 0, change status = 4 (Confirmed) for below UPDATE SQL
        */
        var taskStatus = status
        if db.open() {
            
            if taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue {
                let updateStatusSql = "SELECT COUNT(1) AS photoExist FROM task_inspect_photo_file WHERE task_id = ?"
                if let rs = db.executeQuery(updateStatusSql, withArgumentsIn: [taskId]) {
                    if rs.next() {
                        if Int(rs.int(forColumn: "photoExist")) > 0 {
                            taskStatus = GetTaskStatusId(caseId: "Confirmed").rawValue
                        }
                    }
                }
            }
            
            let sql = "UPDATE inspect_task SET task_status = ?, data_refuse_desc = ? WHERE task_id = ? AND task_status <> ?"
            let sqlUpdateRefTaskId = "UPDATE inspect_task SET ref_task_id = ? WHERE task_id = ? AND (ref_task_id is NULL OR ref_task_id < 1)"
            
            if db.executeUpdate(sql, withArgumentsIn: [taskStatus, refuseDesc, taskId, taskStatus]) {
                if db.executeUpdate(sqlUpdateRefTaskId, withArgumentsIn: [ref_task_id, taskId]) {
                    
                }
            }
            
            db.close()
        }
        
        return taskStatus
    }
    
    @discardableResult
    func updateTaskStatusAfterPhotoUploaded() -> Bool {
        let sql = "UPDATE inspect_task SET task_status = \(GetTaskStatusId(caseId: "Uploaded").rawValue) WHERE task_id IN (SELECT it.task_id FROM inspect_task it WHERE it.task_status = \(GetTaskStatusId(caseId: "Confirmed").rawValue) AND it.confirm_upload_date IS NOT NULL AND NOT EXISTS (SELECT 1 FROM task_inspect_photo_file tipf WHERE tipf.task_id = it.task_id AND tipf.upload_date IS NULL))"
        var result = false
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []) {
                result = true
            }
            db.close()
        }
        return result
    }
    
    func shouldPhysicalDeleteTask(_ taskId:Int) ->Bool {
        let sql = "SELECT task_status FROM inspect_task WHERE task_id = ? AND (task_status = ? OR task_status = ?)"
        var result = false
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, GetTaskStatusId(caseId: "Pending").rawValue, GetTaskStatusId(caseId: "Draft").rawValue]) {
                
                if rs.next() {
                    result = true
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func existInTaskItemTable(_ poItemId:Int) ->Bool {
        let sql = "SELECT 1 FROM inspect_task_item WHERE po_item_id = ?"
        var result = false
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [poItemId]) {
                
                if rs.next() {
                    result = true
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func updatePhotoUploadDateByPhotoId(_ photoId:Int, taskId:Int) ->Bool {
        let sql = "UPDATE task_inspect_photo_file SET upload_date = datetime('now', 'localtime') WHERE photo_id = ? AND task_id = ?"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: [photoId, taskId]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    @discardableResult
    func updateInspectTaskConfirmUploadDate(_ taskId:Int) ->Bool {
        let sql = "UPDATE inspect_task SET confirm_upload_date = datetime('now', 'localtime') WHERE task_id = ? AND task_status = ?"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: [taskId, GetTaskStatusId(caseId: "Confirmed").rawValue]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
}
