//
//  DefectDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 1/4/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class DefectDataHelper:DataHelperMaster {

    func getDefectTypeByTaskDefectDataRecordId(_ Id:Int) ->[String] {
        let sql = "SELECT distinct iem.element_name_en, iem.element_name_cn, iem.element_name_fr FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON iem.element_id = ipe.inspect_element_id INNER JOIN task_inspect_position_point tipp ON ipe.inspect_position_id = tipp.inspect_position_id INNER JOIN task_defect_data_record tddr ON tipp.inspect_record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"
        var defectTypeElms = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [Id]) {
                while rs.next() {
                    
                    let elementNameEn = rs.string(forColumn: "element_name_en")
                    let elementNameCn = rs.string(forColumn: "element_name_cn")
                    let elementNameFr = rs.string(forColumn: "element_name_fr")

                    defectTypeElms.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: elementNameEn, .zh: elementNameCn, .fr: elementNameFr]) )
                }
            }
            
            db.close()
        }
        
        return defectTypeElms
    }
    
    func getDefectTypeByTaskInspectDataRecordId(_ Id:Int) ->[PositPointObj] {
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN task_inspect_position_point tipp ON ipm.position_id = tipp.inspect_position_id WHERE tipp.inspect_record_id = ?"
        var defectTypeElms = [PositPointObj]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [Id]) {
                while rs.next() {
                    let positionId = Int(rs.int(forColumn: "position_id"))
                    let parentId = Int(rs.int(forColumn: "parent_position_id"))
                    let elementNameEn = rs.string(forColumn: "position_name_en")
                    let elementNameCn = rs.string(forColumn: "position_name_cn")
                    let elementNameFr = rs.string(forColumn: "position_name_fr") ?? ""
                    
                    let positionObject = PositPointObj(positionId: positionId, parentId: parentId, positionNameEn: elementNameEn!, positionNameCn: elementNameCn!, positionNameFr: elementNameFr)
                    
                    defectTypeElms.append(positionObject)
                }
            }
            
            db.close()
        }
        
        return defectTypeElms
    }
    
    func getDefectTypeElms(_ positionIds:[String]) ->[String] {
        var sql = "SELECT distinct iem.element_name_en, iem.element_name_cn, iem.element_name_fr FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON iem.element_id = ipe.inspect_element_id WHERE iem.element_type = 2 AND ipe.inspect_position_id IN "
        var defectTypeElms = [String]()
        
        let positions = positionIds.joined(separator: ",")
        sql += "(\(positions))"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    //let elementId = Int(rs.intForColumn("element_id"))
                    let elementNameEn = rs.string(forColumn: "element_name_en")
                    let elementNameCn = rs.string(forColumn: "element_name_cn")
                    let elementNameFr = rs.string(forColumn: "element_name_fr")
                    
                    //let elemtObj = ElmtObj(elementId:elementId, elementNameEn: elementNameEn,elementNameCn: elementNameCn,reqElmtFlag: 0)
                    defectTypeElms.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: elementNameEn, .zh: elementNameCn, .fr: elementNameFr]) )
                }
            }
            
            db.close()
        }
        
        return defectTypeElms
    }

    func deleteDefectItemById(_ recordId:Int) ->Bool {
        let sql = "DELETE FROM task_defect_data_record WHERE record_id = ?"
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsIn: [recordId]) {
                db.close()
                
                return false
            }
            
            db.close()
        }
        
        return true
    }
    
    func getInspElementIdByName(_ name:String, elementType:Int = 2) ->Int {
        let sql = "SELECT element_id FROM inspect_element_mstr WHERE (element_name_fr = ? OR element_name_en = ? OR element_name_cn = ?) AND element_type = ?"
        var id = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [name, name, name, elementType]) {
                if rs.next() {
                    id = Int(rs.int(forColumn: "element_id"))
                }
            }
            
            db.close()
        }
        
        return id
    }
    
    func getInspElementNameById(_ id:Int) ->String {
        let sql = "SELECT element_name_en, element_name_cn, element_name_fr FROM inspect_element_mstr WHERE element_id = ? AND element_type = 2"
        var name = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [id]) {
                if rs.next() {
                    name = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "element_name_en"), .zh: rs.string(forColumn: "element_name_Cn"), .fr: rs.string(forColumn: "element_name_fr")])
                }
            }
            
            db.close()
        }
        
        return name
    }
    
    func getInspElementValueById(_ id:Int) ->DropdownValue {
        let sql = "SELECT element_id, element_name_en, element_name_cn, element_name_fr FROM inspect_element_mstr WHERE element_id = ? AND element_type = 2"
        var value = DropdownValue(valueId: 0, valueNameEn: "", valueNameCn: "", valueNameFr: "")
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [id]) {
                if rs.next() {
                    
                    let id = Int(rs.int(forColumn: "element_id"))
                    let nameEn = rs.string(forColumn: "element_name_en")
                    let nameCn = rs.string(forColumn: "element_name_cn")
                    let nameFr = rs.string(forColumn: "element_name_fr")
                    value = DropdownValue(valueId: id, valueNameEn: nameEn, valueNameCn: nameCn, valueNameFr: nameFr)
                }
            }
            
            db.close()
        }
        
        return value
    }
    
    func getInspPositionNameById(_ id:Int) ->String {
        let sql = "SELECT * FROM inspect_position_mstr WHERE position_id = ? AND position_type = 1"
        var name = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [id]) {
                if rs.next() {
                    name = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "position_name_en"), .zh: rs.string(forColumn: "position_name_cn"), .fr: rs.string(forColumn: "position_name_fr")])
                }
            }
            
            db.close()
        }
        
        return name
    }
    
    
    func getDefectTypesByPositionId(_ positionId:Int) ->[String] {
        let sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON ipe.inspect_element_id = iem.element_id WHERE ipe.inspect_position_id = ? AND iem.element_type = 2"
        var defectTypes = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [positionId]) {
                while rs.next() {
                    defectTypes.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "element_name_en"), .zh: rs.string(forColumn: "element_name_cn"), .fr: rs.string(forColumn: "element_name_fr")]) )
                }
            }
            
            db.close()
        }
        
        return defectTypes
    }

    func getDefectObjectsByPositionId(_ positionId:Int) ->[DropdownValue] {
        let sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON ipe.inspect_element_id = iem.element_id WHERE ipe.inspect_position_id = ? AND iem.element_type = 2"
        var defectTypes = [DropdownValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [positionId]) {
                while rs.next() {
                    let valueId = Int(rs.int(forColumn: "element_id"))
                    let valueNameEn = rs.string(forColumn: "element_name_en")
                    let valueNameCn = rs.string(forColumn: "element_name_cn")
                    let valueNameFr = rs.string(forColumn: "element_name_fr")
                    let defectType = DropdownValue(valueId: valueId, valueNameEn: valueNameEn, valueNameCn: valueNameCn, valueNameFr: valueNameFr)
                    
                    defectTypes.append(defectType)
                }
            }
            
            db.close()
        }
        
        return defectTypes
    }
    
    func getTaskInspDataRcordNameById(_ recordId:Int) ->TaskInspDataRecord? {
        let sql = "SELECT * FROM task_inspect_data_record WHERE record_id = ?"
        var taskInspDataRecord:TaskInspDataRecord?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [recordId]) {
                if rs.next() {
                    
                    let taskId = Int(rs.int(forColumn: "task_id"))
                    let refRecordId = Int(rs.int(forColumn: "ref_record_id"))
                    let inspectSectionId = Int(rs.int(forColumn: "inspect_section_id"))
                    let inspectElementId = Int(rs.int(forColumn: "inspect_element_id"))
                    let inspectPositionId = Int(rs.int(forColumn: "inspect_position_id"))
                    let inspectPositionDesc = rs.string(forColumn: "inspect_position_desc")
                    let inspectDetail = rs.string(forColumn: "inspect_detail")
                    let inspectRemarks = rs.string(forColumn: "inspect_remarks")
                    let resultValueId = Int(rs.int(forColumn: "result_value_id"))
                    let requestSectionId = Int(rs.int(forColumn: "request_section_id"))
                    let requestElementDesc = rs.string(forColumn: "request_element_desc")
                    
                    taskInspDataRecord = TaskInspDataRecord.init(taskId: taskId, refRecordId: refRecordId, inspectSectionId: inspectSectionId, inspectElementId: inspectElementId, inspectPositionId: inspectPositionId, inspectPositionDesc: inspectPositionDesc, inspectDetail: inspectDetail, inspectRemarks: inspectRemarks, resultValueId: resultValueId, requestSectionId: requestSectionId, requestElementDesc: requestElementDesc!)
                }
            }
            
            db.close()
        }
        
        return taskInspDataRecord
    }
    
    func getPositionIdByElementId(_ elementId:Int) ->Int {
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_element_mstr iem ON ipe.inspect_element_id = iem.element_id where iem.element_id = ? AND ipm.position_type = 3"
        var id = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [elementId]) {
                if rs.next() {
                    id = Int(rs.int(forColumn: "position_id"))
                }
            }
            
            db.close()
        }
        
        return id
    }
    
    func deletePreSavedItemsFromInspectDataRecords(_ taskId: Int) {
        if db.open() {
            let sql = "SELECT * FROM task_inspect_data_record WHERE task_id = ? AND is_pre_save = ?"
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, "1"]) {
                while rs.next() {
                    let recordId = Int(rs.int(forColumn: "record_id"))
                    resetDefectPhotoToPhotoAlbumById(taskId, dataRecordId: recordId)
                    deleteTaskInspDataRecordById(recordId)
                }
            }
            db.close()
        }
    }
    
    @discardableResult
    func deletePreSavedItemsFromDefectDataRecords(_ taskId: Int) {
        if db.open() {
            let sql = "SELECT * FROM task_defect_data_record WHERE task_id = ? AND is_pre_save = ?"
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, "1"]) {
                while rs.next() {
                    let recordId = Int(rs.int(forColumn: "record_id"))
                    resetDefectPhotoToPhotoAlbumById(taskId, dataRecordId: recordId)
                    deleteDefectItemById(recordId)
                }
            }
            db.close()
        }
    }
    
    @discardableResult
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
    
    @discardableResult
    func resetDefectPhotoToPhotoAlbumById(_ taskId:Int, dataRecordId:Int) -> Bool {
        let sql = "UPDATE task_inspect_photo_file SET data_record_id =0, data_type = 0 WHERE task_id = ? AND data_record_id = ?"
        var result = true
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsIn: [taskId, dataRecordId]) {
                result = false
            }
            
            db.close()
        }
        
        return result
    }

}
