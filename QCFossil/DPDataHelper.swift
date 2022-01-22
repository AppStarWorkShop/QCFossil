//
//  DPDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 21/3/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class DPDataHelper:DataHelperMaster {

    func getDefectPositions(/*prodTypeId:Int=1, inspTypeId:Int=3, currLevel:Int=1, parentPosId:Int=0*/_ sectionId:Int) ->[PositObj] {
        //let sql = "SELECT * FROM inspect_position_mstr WHERE prod_type_id = ? AND inspect_type_id = ? AND current_level = ? AND parent_position_id = ?"
        //let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_task_tmpl_position ittp ON ipm.position_id = ittp.inspect_position_id INNER JOIN inspect_task_tmpl_mstr ittm ON ittp.tmpl_id = ittm.tmpl_id WHERE ittm.prod_type_id = ? AND ittm.inspect_type_id = ? AND ipm.current_level = ? AND ipm.parent_position_id = ?"
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_section_element ise ON ipe.inspect_element_id = ise.inspect_element_id INNER JOIN inspect_element_mstr iem ON ise.inspect_element_id = iem.element_id WHERE ise.inspect_section_id = ? AND iem.element_type = 1 AND ipm.deleted_flag <> 1"
        var defectPosits = [PositObj]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [/*prodTypeId, inspTypeId, currLevel, parentPosId*/sectionId]) {
                while rs.next() {
                    let positionId = Int(rs.int(forColumn: "position_id"))
                    let positionNameEn = rs.string(forColumn: "position_name_en")
                    let positionNameCn = rs.string(forColumn: "position_name_cn")
                    let positionNameFr = rs.string(forColumn: "position_name_fr") ?? ""
                    
                    let positObj = PositObj(positionId:positionId, positionNameEn:positionNameEn!,positionNameCn:positionNameCn!, positionNameFr: positionNameFr)
                    defectPosits.append(positObj)
                }
            }
            
            db.close()
        }
        
        return defectPosits
    }
    
    func getAllDefectPositPoints() ->[PositPointObj] {
        let sql = "SELECT * FROM inspect_position_mstr WHERE current_level = 2 AND deleted_flag <> 1"
        var defectPositPoints = [PositPointObj]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                
                while rs.next() {
                    let positionId = Int(rs.int(forColumn: "position_id"))
                    let parentId = Int(rs.int(forColumn: "parent_position_id"))
                    let positionNameEn = rs.string(forColumn: "position_name_en")
                    let positionNameCn = rs.string(forColumn: "position_name_cn")
                    let positionNameFr = rs.string(forColumn: "position_name_fr") ?? ""
                    
                    let positPointObj = PositPointObj(positionId:positionId, parentId: parentId, positionNameEn:positionNameEn!,positionNameCn:positionNameCn!, positionNameFr: positionNameFr)
                    defectPositPoints.append(positPointObj)
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    func getDefectPositPoints(_ parentPositId:Int=0) ->[PositObj] {
        let sql = "SELECT * FROM inspect_position_mstr WHERE parent_position_id = ?"
        var defectPositPoints = [PositObj]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [parentPositId]) {
            
                while rs.next() {
                    let positionId = Int(rs.int(forColumn: "position_id"))
                    let positionNameEn = rs.string(forColumn: "position_name_en")
                    let positionNameCn = rs.string(forColumn: "position_name_cn")
                    let positionNameFr = rs.string(forColumn: "position_name_fr") ?? ""
                    
                    let positObj = PositObj(positionId:positionId, positionNameEn:positionNameEn!,positionNameCn:positionNameCn!, positionNameFr: positionNameFr)
                    defectPositPoints.append(positObj)
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    func updateDefectPositionPoints(_ recordId:Int, defectPositionPoints:[TaskInspPosinPoint]) ->[TaskInspPosinPoint] {
        let sql = "INSERT OR REPLACE INTO task_inspect_position_point  ('rowid','inspect_record_id','inspect_position_id','create_user','create_date','modify_user','modify_date') VALUES ((SELECT rowid FROM task_inspect_position_point WHERE inspect_record_id = ? AND inspect_position_id = ?),?,?,?,?,?,?)"
        var oldDfPositPoints = getDefectPositionPointsObjByRecordId(recordId)
        
        if db.open() {
            db.beginTransaction()
            
            //Update...
            for defectPositionPoint in defectPositionPoints {
                oldDfPositPoints = oldDfPositPoints.filter({$0.inspPosinId != defectPositionPoint.inspPosinId})
                
                if defectPositionPoint.inspRecordId>0 && defectPositionPoint.inspPosinId>0 {
                    
                    if db.executeUpdate(sql, withArgumentsIn: [defectPositionPoint.inspRecordId,defectPositionPoint.inspPosinId,defectPositionPoint.inspRecordId,defectPositionPoint.inspPosinId,defectPositionPoint.createUser,defectPositionPoint.createDate,defectPositionPoint.modifyUser,defectPositionPoint.modifyDate]) {
                
                        
                    }else{
                        print("Rollback When Updating PP")
                        db.rollback()
                        db.close()
                
                        return defectPositionPoints
                    }
                }
            }
            
            //Remove...
            for oldDfPositPoint in oldDfPositPoints {
                if !deleteDefectPositionPointById(oldDfPositPoint.inspRecordId,inspPositId: oldDfPositPoint.inspPosinId) {
                    print("Rollback When Removing Old PP")
                    db.rollback()
                    db.close()
                    return defectPositionPoints
                }
            }
            
            db.commit()
            db.close()
        }
        
        return defectPositionPoints
    }
    
    func getDefectPositionPointsObjByRecordId(_ recordId:Int) ->[TaskInspPosinPoint] {
        let sql = "SELECT * FROM task_inspect_position_point WHERE inspect_record_id=?"
        var defectPositPoints = [TaskInspPosinPoint]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [recordId]) {
                while rs.next() {
                    let inspRecordId = Int(rs.int(forColumn: "inspect_record_id"))
                    let inspPosinId = Int(rs.int(forColumn: "inspect_position_id"))
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    
                    let defectPositPoint = TaskInspPosinPoint.init(inspRecordId: inspRecordId, inspPosinId: inspPosinId, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!)
                    
                    defectPositPoints.append(defectPositPoint!)
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    func getDefectPositionPointsByRecordId(_ recordId:Int) -> String {
        let sql = "SELECT ipm.position_name_en,ipm.position_name_cn,ipm.position_name_fr FROM task_inspect_position_point AS tipp INNER JOIN inspect_position_mstr AS ipm ON tipp.inspect_position_id = ipm.position_id WHERE tipp.inspect_record_id=?"
        var defectPositPoints = ""
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsIn: [recordId]) {
                while rs.next() {
                    defectPositPoints += MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "position_name_en"), .zh: rs.string(forColumn: "position_name_cn"), .fr: rs.string(forColumn: "position_name_fr")]) + ", "
                }
                
                if defectPositPoints != "" {
                    defectPositPoints += "!@#"
                    defectPositPoints = defectPositPoints.replacingOccurrences(of: ", !@#", with: "")
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    func getDefectPositionPointsByDFRecordId(_ recordId:Int) -> String {
        let sql = "SELECT ipm.position_name_en,ipm.position_name_cn,ipm.position_name_fr FROM task_inspect_position_point AS tipp INNER JOIN inspect_position_mstr AS ipm ON tipp.inspect_position_id = ipm.position_id WHERE tipp.inspect_record_id=?"
        var defectPositPoints = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [recordId]) {
                while rs.next() {
                    defectPositPoints += MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "position_name_en"), .zh: rs.string(forColumn: "position_name_cn"), .fr: rs.string(forColumn: "position_name_fr")]) + ", "
                }
                
                if defectPositPoints != "" {
                    defectPositPoints += "!@#"
                    defectPositPoints = defectPositPoints.replacingOccurrences(of: ", !@#", with: "")
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    
    func deleteDefectPositionPointById(_ inspRecordId:Int, inspPositId:Int) ->Bool {
        let sql = "DELETE FROM task_inspect_position_point WHERE inspect_record_id=? AND inspect_position_id=?"
    
        if !db.executeUpdate(sql, withArgumentsIn: [inspRecordId, inspPositId]) {
            return false
        }
        
        return true
    }
    
    func getElementIdBySectionIdForINPUT02(_ sectionId:Int) ->Int {
        let sql = "SELECT iem.element_id FROM inspect_element_mstr iem INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.element_type = 1"
        var result = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [sectionId]) {
                if rs.next() {
                    result = Int(rs.int(forColumn: "element_id"))
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func getInspElementIdByInspRecordIdForINPUT02(_ recordId:Int) ->Int {
        let sql = "SELECT tidr.inspect_element_id FROM task_inspect_data_record tidr INNER JOIN task_defect_data_record tddr ON tidr.record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"
        var result = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [recordId]) {
                if rs.next() {
                    result = Int(rs.int(forColumn: "inspect_element_id"))
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func getPositionItemByElementId(_ elementId:Int) ->String {
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_element_mstr iem ON ipe.inspect_element_id = iem.element_id WHERE iem.element_id = ? AND ipm.position_type = 3"
        var positionString = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [elementId]) {
                if rs.next() {
                    positionString = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "position_name_en"), .zh: rs.string(forColumn: "position_name_cn"), .fr: rs.string(forColumn: "position_name_fr")])
                }
            }
            
            db.close()
        }
        
        return positionString
    }
    
    func getPositionIdByElementId(_ elementId:Int) ->Int {
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_element_mstr iem ON ipe.inspect_element_id = iem.element_id WHERE iem.element_id = ? AND ipm.position_type = 3"
        var positionId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [elementId]) {
                if rs.next() {
                    positionId = Int(rs.int(forColumn: "position_id"))
                }
            }
            
            db.close()
        }
        
        return positionId
    }
 
    func getQCInfoByRefTaskId(_ id:Int) ->InspectTaskQCInfo? {
        
        let sql = "SELECT * FROM inspect_task_qc_info WHERE ref_task_id = ?"
        var qcInfo:InspectTaskQCInfo? = nil
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [id]) {
                if rs.next() {
                    
                    let refTaskId = Int(rs.string(forColumn: "ref_task_id") ?? "0")
                    let aqlQty = Int(rs.string(forColumn: "aql_qty") ?? "0")
                    let productClass = rs.string(forColumn: "product_class")
                    let qualityStandard = rs.string(forColumn: "quality_standard")
                    let adjustTime = rs.string(forColumn: "adjust_time")
                    let preinspectDetail = rs.string(forColumn: "preinspect_detail")
                    let caForm = rs.string(forColumn: "ca_form")
                    let casebackMarking = rs.string(forColumn: "caseback_marking")
                    let upcOrbidStatus = rs.string(forColumn: "upc_orbid_status")
                    let tsReportNo = rs.string(forColumn: "ts_report_no")
                    let tsSubmitDate = rs.string(forColumn: "ts_submit_date")
                    let tsResult = rs.string(forColumn: "ts_result")
                    let qcBookingRefNo = rs.string(forColumn: "qc_booking_ref_no")
                    let ssCommentReady = rs.string(forColumn: "pre_inspect_remark") == "" ? rs.string(forColumn: "ss_comment_ready") : rs.string(forColumn: "pre_inspect_remark")
                    let ssReady = rs.string(forColumn: "ss_ready")
                    let ssPhotoName = rs.string(forColumn: "ss_photo_name")
                    let batteryProductionCode = rs.string(forColumn: "battery_production_code")
                    let withQuesitonPending = rs.string(forColumn: "with_quesiton_pending")
                    let withSamePoRejectedBef = rs.string(forColumn: "wth_same_po_rejected_bef")
                    let assortment = rs.string(forColumn: "assortment")
                    let consignedStyles = rs.string(forColumn: "consigned_styles")
                    let qcInspectType = rs.string(forColumn: "qc_inspect_type")
                    let netWeight = rs.string(forColumn: "net_weight")
                    let inspectMethod = rs.string(forColumn: "inspect_method")
                    let lengthRequirement = rs.string(forColumn: "length_requirement")
                    let inspectionSampleReady = rs.string(forColumn: "inspection_sample_ready")
                    let ftyPackingInfo = rs.string(forColumn: "fty_packing_info")
                    let ftyDroptestInfo = rs.string(forColumn: "fty_droptest_info")
                    let movtOrigin = rs.string(forColumn: "movt_origin")
                    let batteryType = rs.string(forColumn: "battery_type")
                    let preInspectResult = rs.string(forColumn: "pre_inspect_result")
                    let preInspectRemark = rs.string(forColumn: "pre_inspect_remark")
                    let reliabilityRemark = rs.string(forColumn: "reliability_remark")
                    let jwlMarking = rs.string(forColumn: "jwl_marking")
                    let combineQcRemarks = rs.string(forColumn: "combine_qc_remarks")
                    let linksRemarks = rs.string(forColumn: "links_remarks")
                    let dusttestRemark = rs.string(forColumn: "dusttest_remark")
                    let smartlinkRemark = rs.string(forColumn: "smartlink_remark")
                    let preciseReport = rs.string(forColumn: "precise_report")
                    let smartlinkReport = rs.string(forColumn: "smartlink_report")
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let inspectorNames = rs.string(forColumn: "inspector_names")
                    let substrInspectorNames = rs.string(forColumn: "substr_inspector_names")
                    let substrQualityStandard = rs.string(forColumn: "substr_quality_standard")
                    let substrLengthRequirement = rs.string(forColumn: "substr_length_requirement")
                    let substrMovtOrigin = rs.string(forColumn: "substr_movt_origin")
                    let substrCombineQCRemarks = rs.string(forColumn: "substr_combine_qc_remarks")
                    let substrSSReady = rs.string(forColumn: "substr_ss_ready")
                    let substrPreInspectRemark = rs.string(forColumn: "substr_pre_inspect_remark")
                    let substrSSCommentReady = rs.string(forColumn: "pre_inspect_remark") == "" ? rs.string(forColumn: "substr_ss_comment_ready") : rs.string(forColumn: "substr_pre_inspect_remark")
                    let substrCAForm = rs.string(forColumn: "substr_ca_form")
                    let substrReliabilityRemark = rs.string(forColumn: "substr_reliability_remark")
                    
                    qcInfo = InspectTaskQCInfo(refTaskId: refTaskId, createUser: createUser!, createDate: createDate!, modifyUser: modifyUser!, modifyDate: modifyDate!)
                    qcInfo?.aqlQty = aqlQty
                    qcInfo?.productClass = productClass
                    qcInfo?.qualityStandard = qualityStandard
                    qcInfo?.adjustTime = adjustTime
                    qcInfo?.preinspectDetail = preinspectDetail
                    qcInfo?.caForm = caForm
                    qcInfo?.casebackMarking = casebackMarking
                    qcInfo?.upcOrbidStatus = upcOrbidStatus
                    qcInfo?.tsReportNo = tsReportNo
                    qcInfo?.tsSubmitDate = tsSubmitDate
                    qcInfo?.tsResult = tsResult
                    qcInfo?.qcBookingRefNo = qcBookingRefNo
                    qcInfo?.ssCommentReady = ssCommentReady
                    qcInfo?.ssReady = ssReady
                    qcInfo?.ssPhotoName = ssPhotoName
                    qcInfo?.batteryProductionCode = batteryProductionCode
                    qcInfo?.withQuesitonPending = withQuesitonPending
                    qcInfo?.withSamePoRejectedBef = withSamePoRejectedBef
                    qcInfo?.assortment = assortment
                    qcInfo?.consignedStyles = consignedStyles
                    qcInfo?.qcInspectType = qcInspectType
                    qcInfo?.netWeight = netWeight
                    qcInfo?.inspectMethod = inspectMethod
                    qcInfo?.lengthRequirement = lengthRequirement
                    qcInfo?.inspectionSampleReady = inspectionSampleReady
                    qcInfo?.ftyPackingInfo = ftyPackingInfo
                    qcInfo?.ftyDroptestInfo = ftyDroptestInfo
                    qcInfo?.movtOrigin = movtOrigin
                    qcInfo?.batteryType = batteryType
                    qcInfo?.preInspectResult = preInspectResult
                    qcInfo?.preInspectRemark = preInspectRemark
                    qcInfo?.reliabilityRemark = reliabilityRemark
                    qcInfo?.jwlMarking = jwlMarking
                    qcInfo?.combineQcRemarks = combineQcRemarks
                    qcInfo?.linksRemarks = linksRemarks
                    qcInfo?.dusttestRemark = dusttestRemark
                    qcInfo?.smartlinkRemark = smartlinkRemark
                    qcInfo?.preciseReport = preciseReport
                    qcInfo?.smartlinkReport = smartlinkReport
                    qcInfo?.inspectorNames = inspectorNames
                    qcInfo?.substrInspectorNames = substrInspectorNames
                    qcInfo?.substrQualityStandard = substrQualityStandard
                    qcInfo?.substrLengthRequirement = substrLengthRequirement
                    qcInfo?.substrMovtOrigin = substrMovtOrigin
                    qcInfo?.substrCombineQCRemarks = substrCombineQCRemarks
                    qcInfo?.substrSSReady = substrSSReady
                    qcInfo?.substrPreInspectRemark = substrPreInspectRemark
                    qcInfo?.substrSSCommentReady = substrSSCommentReady
                    qcInfo?.substrCAForm = substrCAForm
                    qcInfo?.substrReliabilityRemark = substrReliabilityRemark
                    
                    /*
                     qcInfo = InspectTaskQCInfo(refTaskId: refTaskId, aqlQty: aqlQty, productClass: productClass, qualityStandard: qualityStandard, adjustTime: adjustTime, preinspectDetail: preinspectDetail, caForm: caForm, casebackMarking: casebackMarking, upcOrbidStatus: upcOrbidStatus, tsReportNo: tsReportNo, tsSubmitDate: tsSubmitDate, tsResult: tsResult, qcBookingRefNo: qcBookingRefNo, ssCommentReady: ssCommentReady, ssReady: ssReady, ssPhotoName: ssPhotoName, batteryProductionCode: batteryProductionCode, withQuesitonPending: withQuesitonPending, withSamePoRejectedBef: withSamePoRejectedBef, assortment: assortment, consignedStyles: consignedStyles, qcInspectType: qcInspectType, netWeight: netWeight, inspectMethod: inspectMethod, lengthRequirement: lengthRequirement, inspectionSampleReady: inspectionSampleReady, ftyPackingInfo: ftyPackingInfo, ftyDroptestInfo: ftyDroptestInfo, movtOrigin: movtOrigin, batteryType: batteryType, preInspectResult: preInspectResult, preInspectRemark: preInspectRemark, reliabilityRemark: reliabilityRemark, jwlMarking: jwlMarking, combineQcRemarks: combineQcRemarks, linksRemarks: linksRemarks, dusttestRemark: dusttestRemark, smartlinkRemark: smartlinkRemark, preciseReport: preciseReport, smartlinkReport: smartlinkReport, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate)
                     */
                    
                }
            }
            
            db.close()
        }
        
        return qcInfo
    }
}
