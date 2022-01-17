//
//  ZoneDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 26/5/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import Foundation

class ZoneDataHelper:DataHelperMaster {

    func getZoneValuesByPositionId(_ Id:Int) ->[DropdownValue] {
        let sql = "SELECT distinct zvm.value_id, zvm.value_name_en, zvm.value_name_cn, zvm.value_name_fr from inspect_position_mstr ipm INNER JOIN zone_set_mstr zem ON ipm.position_zone_set_id = zem.set_id INNER JOIN zone_set_value zsv ON zem.set_id = zsv.set_id INNER JOIN zone_value_mstr zvm ON zsv.value_id = zvm.value_id WHERE ipm.position_id = \(Id)"
        var zoneValues = [DropdownValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    
                    let zoneValueId = Int(rs.int(forColumn: "value_id"))
                    let zoneValueNameEn = rs.string(forColumn: "value_name_en")
                    let zoneValueNameCn = rs.string(forColumn: "value_name_cn")
                    let zoneValueNameFr = rs.string(forColumn: "value_name_fr")
                    let inspectZoneValue = DropdownValue(valueId: zoneValueId, valueNameEn: zoneValueNameEn, valueNameCn: zoneValueNameCn, valueNameFr: zoneValueNameFr)
                    
                    zoneValues.append(inspectZoneValue)
                }
            }
            
            db.close()
        }
        
        return zoneValues
    }
    
    func getZoneValueNameById(_ Id:Int) -> String {
        let sql = "SELECT value_name_en, value_name_cn, value_name_fr value_name_fr FROM zone_value_mstr WHERE value_id = \(Id)"
        var zoneValueName: String?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                if rs.next() {
                    
                    zoneValueName = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")])
                }
            }
            
            db.close()
        }
        
        return zoneValueName ?? ""
    }
    
    func getDefectValuesByElementId(_ Id:Int) ->[DropdownValue] {
        let sql = "SELECT distinct dvm.value_id, dvm.value_name_en, dvm.value_name_cn  FROM defect_set_mstr dsm INNER JOIN inspect_element_mstr iem ON dsm.set_id = iem.inspect_defect_set_id INNER JOIN defect_set_value dsv ON dsm.set_id = dsv.set_id INNER JOIN defect_value_mstr dvm ON dsv.value_id = dvm.value_id WHERE iem.element_id = \(Id)"
        var defectValues = [DropdownValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    
                    let zoneValueId = Int(rs.int(forColumn: "value_id"))
                    let zoneValueNameEn = rs.string(forColumn: "value_name_en")
                    let zoneValueNameCn = rs.string(forColumn: "value_name_cn")
                    let zoneValueNameFr = rs.string(forColumn: "value_name_fr")
                    let defectValue = DropdownValue(valueId: zoneValueId, valueNameEn: zoneValueNameEn, valueNameCn: zoneValueNameCn, valueNameFr: zoneValueNameFr)
                    
                    defectValues.append(defectValue)
                }
            }
            
            db.close()
        }
        
        return defectValues
    }
    
    func getCaseValuesByElementId(_ Id:Int) ->[DropdownValue] {
        let sql = "SELECT distinct cvm.value_id, cvm.value_name_en, cvm.value_name_cn, cvm.value_name_fr FROM case_set_mstr csm INNER JOIN inspect_element_mstr iem ON csm.set_id = iem.inspect_case_set_id INNER JOIN case_set_value csv ON csm.set_id = csv.set_id INNER JOIN case_value_mstr cvm ON csv.value_id = cvm.value_id WHERE element_id = \(Id)"
        var values = [DropdownValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    
                    let zoneValueId = Int(rs.int(forColumn: "value_id"))
                    let zoneValueNameEn = rs.string(forColumn: "value_name_en")
                    let zoneValueNameCn = rs.string(forColumn: "value_name_cn")
                    let zoneValueNameFr = rs.string(forColumn: "value_name_fr")
                    let value = DropdownValue(valueId: zoneValueId, valueNameEn: zoneValueNameEn, valueNameCn: zoneValueNameCn, valueNameFr: zoneValueNameFr)
                    
                    values.append(value)
                }
            }
            
            db.close()
        }
        
        return values
    }
    
    func getDefectDescValueNameById(_ Id:Int) -> String {
        let sql = "SELECT value_name_en, value_name_cn, value_name_fr FROM defect_value_mstr WHERE value_id = \(Id)"
        var valueName: String?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                if rs.next() {
                    
                    valueName = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")])
                }
            }
            
            db.close()
        }
        
        return valueName ?? ""
    }
    
    func getCaseValueNameById(_ Id:Int) -> String {
        let sql = "SELECT value_name_en, value_name_cn, value_name_fr FROM case_value_mstr WHERE value_id = \(Id)"
        var valueName: String?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                if rs.next() {
                    
                    valueName = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "value_name_en"), .zh: rs.string(forColumn: "value_name_cn"), .fr: rs.string(forColumn: "value_name_fr")])
                }
            }
            
            db.close()
        }
        
        return valueName ?? ""
    }
}
