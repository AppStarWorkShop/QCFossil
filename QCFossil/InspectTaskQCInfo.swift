//
//  InspectTaskQCInfo.swift
//  QCFossil
//
//  Created by pacmobile on 28/7/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import Foundation

class InspectTaskQCInfo {
    var refTaskId:Int
    var aqlQty:Int?
    var productClass:String?
    var qualityStandard:String?
    var adjustTime:String?
    var preinspectDetail:String?
    var caForm:String?
    var casebackMarking:String?
    var upcOrbidStatus:String?
    var tsReportNo:String?
    var tsSubmitDate:String?
    var tsResult:String?
    var qcBookingRefNo:String?
    var ssCommentReady:String?
    var ssReady:String?
    var ssPhotoName:String?
    var batteryProductionCode:String?
    var withQuesitonPending:String?
    var withSamePoRejectedBef:String?
    var assortment:String?
    var consignedStyles:String?
    var qcInspectType:String?
    var netWeight:String?
    var inspectMethod:String?
    var lengthRequirement:String?
    var inspectionSampleReady:String?
    var ftyPackingInfo:String?
    var ftyDroptestInfo:String?
    var movtOrigin:String?
    var batteryType:String?
    var preInspectResult:String?
    var preInspectRemark:String?
    var reliabilityRemark:String?
    var jwlMarking:String?
    var combineQcRemarks:String?
    var linksRemarks:String?
    var dusttestRemark:String?
    var smartlinkRemark:String?
    var preciseReport:String?
    var smartlinkReport:String?
    var inspectorNames:String?
    var createUser:String
    var createDate:String
    var modifyUser:String
    var modifyDate:String
    var substrInspectorNames:String?
    var substrQualityStandard:String?
    var substrLengthRequirement:String?
    var substrMovtOrigin:String?
    var substrCombineQCRemarks:String?
    var substrSSReady:String?
    var substrPreInspectRemark:String?
    var substrSSCommentReady:String?
    var substrCAForm:String?
    var substrReliabilityRemark:String?
    
    init?(refTaskId:Int?, createUser:String,  createDate:String, modifyUser:String, modifyDate:String) {
        self.refTaskId = refTaskId ?? 0
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
    }
    
    /*
    init?(refTaskId:Int?, aqlQty:Int?, productClass:String?, qualityStandard:String?, adjustTime:String?, preinspectDetail:String?, caForm:String?, casebackMarking:String?, upcOrbidStatus:String?, tsReportNo:String?, tsSubmitDate:String?, tsResult:String?, qcBookingRefNo:String?, ssCommentReady:String?, ssReady:String?, ssPhotoName:String?, batteryProductionCode:String?, withQuesitonPending:String?, withSamePoRejectedBef:String?, assortment:String?, consignedStyles:String?, qcInspectType:String?, netWeight:String?, inspectMethod:String?, lengthRequirement:String?, inspectionSampleReady:String?, ftyPackingInfo:String?, ftyDroptestInfo:String?, movtOrigin:String?, batteryType:String?, preInspectResult:String?, preInspectRemark:String?, reliabilityRemark:String?, jwlMarking:String?, combineQcRemarks:String?, linksRemarks:String?, dusttestRemark:String?, smartlinkRemark:String?, preciseReport:String?, smartlinkReport:String?, createUser:String,  createDate:String, modifyUser:String, modifyDate:String) {
        
        self.refTaskId = refTaskId ?? 0
        self.aqlQty = aqlQty
        self.productClass = productClass
        self.qualityStandard = qualityStandard
        self.adjustTime = adjustTime
        self.preinspectDetail = preinspectDetail
        self.caForm = caForm
        self.casebackMarking = casebackMarking
        self.upcOrbidStatus = upcOrbidStatus
        self.tsReportNo = tsReportNo
        self.tsSubmitDate = tsSubmitDate
        self.tsResult = tsResult
        self.qcBookingRefNo = qcBookingRefNo
        self.ssCommentReady = ssCommentReady
        self.ssReady = ssReady
        self.ssPhotoName = ssPhotoName
        self.batteryProductionCode = batteryProductionCode
        self.withQuesitonPending = withQuesitonPending
        self.withSamePoRejectedBef = withSamePoRejectedBef
        self.assortment = assortment
        self.consignedStyles = consignedStyles
        self.qcInspectType = qcInspectType
        self.netWeight = netWeight
        self.inspectMethod = inspectMethod
        self.lengthRequirement = lengthRequirement
        self.inspectionSampleReady = inspectionSampleReady
        self.ftyPackingInfo = ftyPackingInfo
        self.ftyDroptestInfo = ftyDroptestInfo
        self.movtOrigin = movtOrigin
        self.batteryType = batteryType
        self.preInspectResult = preInspectResult
        self.preInspectRemark = preInspectRemark
        self.reliabilityRemark = reliabilityRemark
        self.jwlMarking = jwlMarking
        self.combineQcRemarks = combineQcRemarks
        self.linksRemarks = linksRemarks
        self.dusttestRemark = dusttestRemark
        self.smartlinkRemark = smartlinkRemark
        self.preciseReport = preciseReport
        self.smartlinkReport = smartlinkReport
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
    }*/
}