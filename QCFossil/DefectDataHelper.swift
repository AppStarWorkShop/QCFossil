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

    func getDefectTypeElms(prodType:Int, inspType:Int, elemtType:Int, inspSecId:Int) ->[String] {
        //let sql = "SELECT * FROM inspect_element_mstr WHERE prod_type_id = ? AND inspect_type_id = ? AND element_type = ? AND inspect_section_id = ?"
        let sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id INNER JOIN inspect_task_tmpl_section itts ON ise.inspect_section_id = itts.inspect_section_id INNER JOIN inspect_task_tmpl_mstr ittm ON ittm.tmpl_id = itts.tmpl_id WHERE ittm.prod_type_id = ? AND ittm.inspect_type_id = ? AND iem.element_type = ? AND ise.inspect_section_id = ?"
        var defectTypeElms = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [prodType, inspType, elemtType, inspSecId]) {
                while rs.next() {
                    //let elementId = Int(rs.intForColumn("element_id"))
                    let elementNameEn = rs.stringForColumn("element_name_en")
                    let elementNameCn = rs.stringForColumn("element_name_cn")
                    
                    //let elemtObj = ElmtObj(elementId:elementId, elementNameEn: elementNameEn,elementNameCn: elementNameCn,reqElmtFlag: 0)
                    defectTypeElms.append( _ENGLISH ? elementNameEn:elementNameCn)
                }
            }
            
            db.close()
        }
        
        return defectTypeElms
    }
    
    func deleteDefectItemById(recordId:Int) ->Bool {
        let sql = "DELETE FROM task_defect_data_record WHERE record_id = ?"
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsInArray: [recordId]) {
                db.close()
                
                return false
            }
            
            db.close()
        }
        
        return true
    }
    
    func getInspElementIdByName(name:String) ->Int {
        let sql = "SELECT element_id FROM inspect_element_mstr WHERE (element_name_en = ? OR element_name_cn = ?) AND element_type = 2"
        var id = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [name, name]) {
                if rs.next() {
                    id = Int(rs.intForColumn("element_id"))
                }
            }
            
            db.close()
        }
        
        return id
    }
    
    func getInspElementNameById(id:Int) ->String {
        let sql = "SELECT element_name_en, element_name_cn FROM inspect_element_mstr WHERE element_id = ? AND element_type = 2"
        var name = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [id]) {
                if rs.next() {
                    name = _ENGLISH ? rs.stringForColumn("element_name_en") : rs.stringForColumn("element_name_cn")
                }
            }
            
            db.close()
        }
        
        return name
    }
}
