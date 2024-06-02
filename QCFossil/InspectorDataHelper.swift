//
//  InspectorDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 4/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
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


class InspectorDataHelper:DataHelperMaster {
    
    func getInspectorById(_ Id:Int) ->Inspector? {
        let sql = "SELECT * FROM inspector_mstr im INNER JOIN prod_type_mstr ptm ON im.prod_type_id = ptm.type_id WHERE inspector_id = ?"
        var inspector:Inspector?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [Id]) {
                
                if rs.next() {
                    
                    let inspectorId = Int(rs.int(forColumn: "inspector_id"))
                    let inspectorName = rs.string(forColumn: "inspector_name")
                    let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                    let appUserName = rs.string(forColumn: "app_username")
                    let appPassword = rs.string(forColumn: "app_password")
                    let serviceToken = rs.string(forColumn: "service_token")
                    let reportPrefix = rs.string(forColumn: "report_prefix")
                    let reportRunningNo = rs.string(forColumn: "report_running_no")
                    let phoneNo = rs.string(forColumn: "phone_no")
                    let emailAddr = rs.string(forColumn: "email_addr")
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let recStatus = Int(rs.int(forColumn: "rec_status"))
                    let deleteFlag = Int(rs.int(forColumn: "deleted_flag"))
                    let deleteUser = rs.string(forColumn: "delete_user")
                    let deleteDate = rs.string(forColumn: "delete_date")
                    let chgPwdReqDate = rs.string(forColumn: "chg_pwd_req_date")
                    let typeCode = rs.string(forColumn: "type_code")
                    
                    inspector = Inspector(inspectorId: inspectorId, inspectorName: inspectorName, prodTypeId: prodTypeId, appUserName: appUserName, appPassword: appPassword, serviceToken: serviceToken, reportPrefix: reportPrefix, reportRunningNo: reportRunningNo, phoneNo: phoneNo, emailAddr: emailAddr, typeCode: typeCode)
                    
                    inspector?.createUser = createUser
                    inspector?.createDate = createDate
                    inspector?.modifyUser = modifyUser
                    inspector?.modifyDate = modifyDate
                    inspector?.recStatus = recStatus
                    inspector?.deleteFlag = deleteFlag
                    inspector?.deleteUser = deleteUser
                    inspector?.deleteDate = deleteDate
                    inspector?.chgPwdReqDate = chgPwdReqDate
                    
                }
            }
            
            db.close()
            
            return inspector
        }
        
        return nil
    }
    
    func getInspector(_ userName:String, password:String) ->Inspector? {
        let sql = "SELECT * FROM inspector_mstr im INNER JOIN prod_type_mstr ptm ON im.prod_type_id = ptm.type_id WHERE (lower(app_username) = ? OR app_username = ?) AND app_password = ?"
        var inspector:Inspector?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [userName.lowercased(), userName, password]) {
            
            if rs.next() {
                
                let inspectorId = Int(rs.int(forColumn: "inspector_id"))
                let inspectorName = rs.string(forColumn: "inspector_name")
                let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                let appUserName = rs.string(forColumn: "app_username")
                let appPassword = rs.string(forColumn: "app_password")
                let serviceToken = rs.string(forColumn: "service_token")
                let reportPrefix = rs.string(forColumn: "report_prefix")
                let reportRunningNo = rs.string(forColumn: "report_running_no")
                let phoneNo = rs.string(forColumn: "phone_no")
                let emailAddr = rs.string(forColumn: "email_addr")
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let recStatus = Int(rs.int(forColumn: "rec_status"))
                let deleteFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                let chgPwdReqDate = rs.string(forColumn: "chg_pwd_req_date")
                let typeCode = rs.string(forColumn: "type_code")
                
                inspector = Inspector(inspectorId: inspectorId, inspectorName: inspectorName, prodTypeId: prodTypeId, appUserName: appUserName, appPassword: appPassword, serviceToken: serviceToken, reportPrefix: reportPrefix, reportRunningNo: reportRunningNo, phoneNo: phoneNo, emailAddr: emailAddr, typeCode: typeCode)
                
                inspector?.createUser = createUser
                inspector?.createDate = createDate
                inspector?.modifyUser = modifyUser
                inspector?.modifyDate = modifyDate
                inspector?.recStatus = recStatus
                inspector?.deleteFlag = deleteFlag
                inspector?.deleteUser = deleteUser
                inspector?.deleteDate = deleteDate
                inspector?.chgPwdReqDate = chgPwdReqDate
                
            }
            }
            
            db.close()
        
            return inspector
        }
        
        return nil
    }
    
    func getTaskCountByInspectorId(_ inspectorId:Int) ->Int {
        let sql = "SELECT COUNT(task_id) AS task_cnt FROM inspect_task WHERE inspection_no = ?"
        var taskCount = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspectorId]) {
                
                if rs.next() {
                    taskCount = Int(rs.int(forColumn: "task_cnt"))
                }
            }
            
            db.close()
        }
        
        return taskCount
    }
    
    func updateRunningNo(_ rpRunningNo:Int,inspectorId:Int) ->Bool {
        let sql = "UPDATE inspector_mstr SET report_running_no = ? WHERE inspector_id = ?"
        var result = true
        
        if db.open() {
         
            if !db.executeUpdate(sql, withArgumentsIn: [rpRunningNo, inspectorId]) {
                result = false
            }
            
            db.close()
        }
        
        return result
    }
    
    func getAllInspectors() ->[Inspector] {
        let sql = "SELECT * FROM inspector_mstr im INNER JOIN prod_type_mstr ptm ON im.prod_type_id = ptm.type_id"
        var inspectors = [Inspector]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                
                while rs.next() {
                    
                    let inspectorId = Int(rs.int(forColumn: "inspector_id"))
                    let inspectorName = rs.string(forColumn: "inspector_name")
                    let prodTypeId = Int(rs.int(forColumn: "prod_type_id"))
                    let appUserName = rs.string(forColumn: "app_username")
                    let appPassword = rs.string(forColumn: "app_password")
                    let serviceToken = rs.string(forColumn: "service_token")
                    let reportPrefix = rs.string(forColumn: "report_prefix")
                    let reportRunningNo = rs.string(forColumn: "report_running_no")
                    let phoneNo = rs.string(forColumn: "phone_no")
                    let emailAddr = rs.string(forColumn: "email_addr")
                    let typeCode = rs.string(forColumn: "type_code")
                    
                    inspectors.append(Inspector(inspectorId: inspectorId, inspectorName: inspectorName, prodTypeId: prodTypeId, appUserName: appUserName, appPassword: appPassword, serviceToken: serviceToken, reportPrefix: reportPrefix, reportRunningNo: reportRunningNo, phoneNo: phoneNo, emailAddr: emailAddr, typeCode: typeCode))
                }
            }
            
            db.close()
        }
        
        return inspectors
    }
    
    func updateInspector(_ inspector:Inspector) ->Int {
        
        if db.open() {
            var sql = "SELECT report_running_no FROM inspector_mstr WHERE inspector_id = ?"
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspector.inspectorId!]) {
                
                if rs.next() {
                    let rptRunningNo = Int(rs.int(forColumn: "report_running_no"))
                    inspector.reportRunningNo = rptRunningNo > Int(inspector.reportRunningNo!) ? String(rptRunningNo) : inspector.reportRunningNo
                }
            }
            
            sql = "INSERT OR REPLACE INTO inspector_mstr  ('inspector_id','inspector_name','prod_type_id','app_username','app_password','service_token','report_prefix','report_running_no','phone_no','email_addr','rec_status','create_user','create_date','modify_user','modify_date','deleted_flag','delete_user','delete_date') VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
            if db.executeUpdate(sql, withArgumentsIn:[notNilObject(inspector.inspectorId as AnyObject)!,inspector.inspectorName!,inspector.prodTypeId!,inspector.appUserName!,inspector.appPassword!,inspector.serviceToken!,inspector.reportPrefix!,inspector.reportRunningNo!,inspector.phoneNo!,inspector.emailAddr!,1,inspector.createUser!,inspector.createDate!,inspector.modifyUser!,inspector.modifyDate!,0,"",""]){
                
            }
            
            db.close()
            
            return 1
        }
        
        return 0
    }
    
    func updateProdType(_ prodType:ProdType) ->Bool {
        
        if db.open() {
            let sql = "INSERT OR REPLACE INTO prod_type_mstr('type_id', 'type_code', 'type_name_en', 'type_name_cn', 'data_env', 'rec_status', 'create_date', 'create_user', 'modify_date', 'modify_user', 'deleted_flag', 'delete_date', 'delete_user', 'type_name_fr') VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
            let typeId = prodType.typeId ?? ""
            let typeCode = prodType.typeCode ?? ""
            let typeNameEn = prodType.typeNameEn ?? ""
            let typeNameCn = prodType.typeNameCn ?? ""
            let typeNameFr = prodType.typeNameFr ?? ""
            let dataEnv = prodType.dataEnv ?? ""
            let recStatus = prodType.recStatus ?? ""
            let createDate = prodType.createDate ?? ""
            let createUser = prodType.createUser ?? ""
            let modifyDate = prodType.modifyDate ?? ""
            let modifyUser = prodType.modifyUser ?? ""
            let deletedFlag = prodType.deletedFlag ?? ""
            let deleteDate = prodType.deleteDate ?? ""
            let deleteUser = prodType.deleteUser ?? ""
            
            if !db.executeUpdate(sql, withArgumentsIn: [typeId, typeCode, typeNameEn, typeNameCn, dataEnv, recStatus, createDate, createUser, modifyDate, modifyUser, deletedFlag, deleteDate, deleteUser, typeNameFr]) {
                
                db.close()
                return false
            }
            
            db.close()
        }
        
        return true
    }
}
