//
//  PoItem.swift
//  QCFossil
//
//  Created by Yin Huang on 3/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class PoItem {
    
    var itemId:Int?
    var dataEnv:String?
    var refHeadId:Int?
    var poNo:String?
    var refVdrId:Int?
    var vdrCode:String?
    var vdrName:String?
    var vdrDisplayName:String?
    var refLineId:Int?
    var poLineNo:String?
    var refPordId:Int?
    var skuNo:String?
    var prodTypeCode:String?
    var styleNo:String?
    var dimen1:String?
    var dimen2:String?
    var dimen3:String?
    var refVdrLocationId:Int?
    var vdrLocationCode:String?
    var vdrLocationName:String?
    var refOrderNo:String?
    var refOrderLine:String?
    var refBrandId:Int?
    var brandCode:String?
    var brandName:String?
    var reqDelivDate:String
    var shipWin:String
    var orderQty:Int
    var lineQtyUom:String?
    var lineStatus:Int?
    var createDate:String?
    var modifyDate:String?
    var deletedFlag:Int?
    var deleteDate:String?
    var refBuyerId:Int? //add 12/20
    var buyerCode:String? //add 12/20
    var buyerName:String? //add 12/20
    var buyerDisplayName:String? //add 12/20
    var refBuyerLocationId:String? //add 12/20
    var buyerLocationCode:String
    var buyerLocationName:String
    var promisedShipDateStart:String? //add 12/20
    var promisedShipDateEnd:String? //add 12/20
    var schedShipDateStart:String? //add 12/20
    var schedShipDateEnd:String? //add 12/20
    var shipTo:String?
    var opdRsd:String
    var qcBookedQty:Int
    var outStandQty:Int? //add 12/20
    var lineSchedDateStart:String? //add 12/20
    var lineSchedText:String? //add 12/20
    var lineSchedDateEnd:String? //add 12/20
    var appReadyPrugeDate:String? //add 12/20
    var reportInspectorId:Int? //add 12/20
    var samplingQty:Int
    var prodDesc:String?
    var market:String?
    var materialCategory:String?
    var shipModeName:String?
    var itemBarCode:String?
    var retailPrice:String?
    var targetInspectQty:String?
    var currency:String?
    var styleSize:String?
    var substrStyleSize:String?
    
    //UI
    var availableQty:Int
    var isEnable:Int
    var taskSched:String = ""
    //, buyerCode:String?, buyerName:String?, buyerDisplayName:String?, refBuyerLocationId:String?, promisedShipDateStart:String?, promisedShipDateEnd:String?, schedShipDateStart:String?, schedShipDateEnd:String?,  lineSchedDateStart:String?, lineSchedText:String?, lineSchedDateEnd:String?, appReadyPrugeDate:String?
    init?(itemId:Int, dataEnv:String, refHeadId:Int, poNo:String, refVdrId:Int, vdrCode:String, vdrName:String, vdrDisplayName:String, refLineId:Int, poLineNo:String, refPordId:Int, skuNo:String, prodTypeCode:String, styleNo:String, dimen1:String?, dimen2:String?, dimen3:String?, refVdrLocationId:Int, vdrLocationCode:String, vdrLocationName:String, refBuyerLocationId:String?, buyerLocationCode:String, buyerLocationName:String, refOrderNo:String, refOrderLine:String, refBrandId:Int, brandCode:String, brandName:String, reqDelivDate:String, shipWin:String, orderQty:Int, lineQtyUom:String, lineStatus:Int, createDate:String?, modifyDate:String?, deletedFlag:Int, deleteDate:String?, shipTo:String?, opdRsd:String, qcBookedQty:Int, availableQty:Int=0, isEnable:Int=1, samplingQty:Int=0, prodDesc:String="" /*,outStandQty:Int, refBuyerId:Int, reportInspectorId:Int*/) {
        
        self.itemId = itemId
        self.dataEnv = dataEnv
        self.refHeadId = refHeadId
        self.poNo = poNo
        self.refVdrId = refVdrId
        self.vdrCode = vdrCode
        self.vdrName = vdrName
        self.vdrDisplayName = vdrDisplayName
        self.refLineId = refLineId
        self.poLineNo = poLineNo
        self.refPordId = refPordId
        self.skuNo = skuNo
        self.prodTypeCode = prodTypeCode
        self.styleNo = styleNo
        self.dimen1 = dimen1
        self.dimen2 = dimen2
        self.dimen3 = dimen3
        self.refVdrLocationId = refVdrLocationId
        self.vdrLocationCode = vdrLocationCode
        self.vdrLocationName = vdrLocationName
        self.refBuyerLocationId = refBuyerLocationId
        self.buyerLocationCode = buyerLocationCode
        self.buyerLocationName = buyerLocationName
        self.refOrderNo = refOrderNo
        self.refOrderLine = refOrderLine
        self.refBrandId = refBrandId
        self.brandCode = brandCode
        self.brandName = brandName
        self.reqDelivDate = reqDelivDate
        self.shipWin = shipWin
        self.orderQty = orderQty
        self.lineQtyUom = lineQtyUom
        self.lineStatus = lineStatus
        self.createDate = createDate
        self.modifyDate = modifyDate
        self.deletedFlag = deletedFlag
        self.deleteDate = deleteDate
        self.shipTo = shipTo
        self.opdRsd = opdRsd
        self.qcBookedQty = qcBookedQty
        self.availableQty = availableQty
        self.isEnable = isEnable
        self.samplingQty = samplingQty
        self.prodDesc = prodDesc
        
        //self.refBuyerId = refBuyerId
        //self.outStandQty = outStandQty
        //self.reportInspectorId = reportInspectorId
        /*
         self.refBuyerId = refBuyerId
         self.buyerCode = buyerCode
         self.buyerName = buyerName
         self.buyerDisplayName = buyerDisplayName
         self.refBuyerLocationId = refBuyerLocationId
         self.promisedShipDateStart = promisedShipDateStart
         self.promisedShipDateEnd = promisedShipDateEnd
         self.schedShipDateStart = schedShipDateStart
         self.schedShipDateEnd = schedShipDateEnd
         
         self.lineSchedDateStart = lineSchedDateStart
         self.lineSchedText = lineSchedText
         self.lineSchedDateEnd = lineSchedDateEnd
         self.appReadyPrugeDate = appReadyPrugeDate
         
         */
    }
    
    
}