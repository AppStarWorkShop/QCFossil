//
//  PoDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 26/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class PoDataHelper:DataHelperMaster {
    
    func getPoStyleByPoId(_ poId:Int) ->String {
        let sql = "SELECT style_no FROM fgpo_line_item WHERE item_id = ?"
        var styleDesc:String = "null"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [poId]) {
                if rs.next() {
                    styleDesc = rs.string(forColumnIndex: 0) ?? ""
                }
            }
            
            db.close()
        }
        
        return styleDesc
    }
    
    func getPoNoByPoId(_ poId:Int) ->String {
        let sql = "SELECT po_no FROM fgpo_line_item WHERE item_id = ?"
        var poNo:String = "null"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [poId]) {
            
                if rs.next() {
                    poNo = rs.string(forColumnIndex: 0) ?? ""
                }
            }
            
            db.close()
        }
        
        return poNo
    }
    
    func getPoByTaskId(_ taskId:Int) ->[PoItem] {
        let sql = "SELECT * FROM inspect_task_item AS iti INNER JOIN fgpo_line_item AS fli ON iti.po_item_id = fli.item_id WHERE iti.task_id = ?"
        var poItems = [PoItem]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
            
            while rs.next() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = _DATEFORMATTER
                
                let itemId = Int(rs.int(forColumn: "item_id"))
                let dataEnv = rs.string(forColumn: "data_env")
                let refHeadId = Int(rs.int(forColumn: "ref_head_id"))
                let poNo = rs.string(forColumn: "po_no") ?? "0"
                let refVdrId = Int(rs.int(forColumn: "ref_vdr_id"))
                let vdrCode = rs.string(forColumn: "vdr_code")
                let vdrName = rs.string(forColumn: "vdr_name")
                let vdrDisplayName = rs.string(forColumn: "vdr_display_name")
                let refLineId = Int(rs.int(forColumn: "ref_line_id"))
                let poLineNo = rs.string(forColumn: "po_line_no") ?? "0"
                let refPordId = Int(rs.int(forColumn: "ref_prod_id"))
                let skuNo = rs.string(forColumn: "sku_no")
                let prodTypeCode = rs.string(forColumn: "prod_type_code")
                let styleNo = rs.string(forColumn: "style_no")
                let dimen1 = rs.string(forColumn: "dimen_1")
                let dimen2 = rs.string(forColumn: "dimen_2")
                let dimen3 = rs.string(forColumn: "dimen_3")
                let refVdrLocationId = Int(rs.int(forColumn: "ref_vdr_location_id"))
                let vdrLocationCode = rs.string(forColumn: "vdr_location_code")
                let vdrLocationName = rs.string(forColumn: "vdr_location_name")
                let refBuyerLocationId = rs.string(forColumn: "ref_buyer_location_id")
                let buyerLocationCode = rs.string(forColumn: "buyer_location_code")
                let buyerLocationName = rs.string(forColumn: "buyer_location_name")
                let refOrderNo = rs.string(forColumn: "ref_order_no")
                let refOrderLine = rs.string(forColumn: "ref_order_line")
                let refBrandId = Int(rs.int(forColumn: "ref_brand_id"))
                let brandCode = rs.string(forColumn: "brand_code")
                let brandName = rs.string(forColumn: "brand_name")
                let reqDelivDate = rs.string(forColumn: "req_deliv_date")
                var shipWin = rs.string(forColumn: "ship_win")// dateFormatter.stringFromDate(rs.dateForColumn("ship_win")) //
                let orderQty = Int(rs.int(forColumn: "order_qty"))
                let lineQtyUom = rs.string(forColumn: "line_qty_uom")
                let lineStatus = Int(rs.int(forColumn: "line_status"))
                let createDate = rs.string(forColumn: "create_date")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteDate = rs.string(forColumn: "delete_date")
                let availQty = Int(rs.int(forColumn: "avail_inspect_qty"))
                let inspEnableFlag = Int(rs.int(forColumn: "inspect_enable_flag"))
                var shipTo = rs.string(forColumn: "buyer_location_code")//rs.stringForColumn("ship_to")
                var opdRsd = rs.string(forColumn: "line_sched_text")
                let qcBookedQty = Int(rs.int(forColumn: "qc_booked_qty"))
                let samplingQty = Int(rs.int(forColumn: "sampling_qty"))
                var prodDesc = rs.string(forColumn: "prod_desc")
                let market = rs.string(forColumn: "market")
                let materialCategory = rs.string(forColumn: "material_category")
                let shipModeName = rs.string(forColumn: "ship_mode_name")
                let itemBarcode = rs.string(forColumn: "item_barcode")
                let retailPrice = rs.string(forColumn: "retail_price")
                let targetInspectQty = rs.string(forColumn: "target_inspect_qty")
                let currency = rs.string(forColumn: "currency")
                let styleSize = rs.string(forColumn: "style_size")
                let substrStyleSize = rs.string(forColumn: "substr_style_size")
                
                if (prodDesc == nil) {
                    prodDesc = ""
                }
                
                if (shipTo == nil) {
                    shipTo = ""
                }
                
                if shipWin != nil {
                    let shipWinTmp = shipWin
                    let shipWinTmpArray = shipWinTmp?.characters.split{$0 == " "}.map(String.init)
                    
                    if (shipWinTmpArray?.count)!>0 {
                        shipWin = shipWinTmpArray?[0]
                        
                        shipWin = dateFormatter.string(from: dateFormatter.date(from: shipWin!)!)
                    }
                }else{
                    shipWin = ""
                }
                
                if opdRsd != nil {
                    let opdRsdTmp = opdRsd
                    let opdRsdTmpArray = opdRsdTmp?.characters.split{$0 == " "}.map(String.init)
                    
                    if (opdRsdTmpArray?.count)! > 0 {
                        opdRsd = opdRsdTmpArray?[0]
                        opdRsd = opdRsd?.replacingOccurrences(of: ":", with: "")
                        
                        opdRsd = dateFormatter.string(from: dateFormatter.date(from: opdRsd!)!)
                    }
                }else{
                    opdRsd = ""
                }
                
                let poItem = PoItem(itemId: itemId, dataEnv: dataEnv!, refHeadId: refHeadId, poNo: poNo, refVdrId: refVdrId, vdrCode: vdrCode!, vdrName: vdrName!, vdrDisplayName: vdrDisplayName!, refLineId: refLineId, poLineNo: poLineNo, refPordId: refPordId, skuNo: skuNo!, prodTypeCode: prodTypeCode!, styleNo: styleNo!, dimen1: dimen1, dimen2: dimen2, dimen3: dimen3, refVdrLocationId: refVdrLocationId, vdrLocationCode: vdrLocationCode!, vdrLocationName: vdrLocationName!, refBuyerLocationId: refBuyerLocationId, buyerLocationCode: buyerLocationCode!, buyerLocationName: buyerLocationName!, refOrderNo: refOrderNo!, refOrderLine: refOrderLine!, refBrandId: refBrandId, brandCode: brandCode!, brandName: brandName!, reqDelivDate: reqDelivDate!, shipWin: shipWin!, orderQty: orderQty, lineQtyUom: lineQtyUom!, lineStatus: lineStatus, createDate: createDate, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteDate: deleteDate, shipTo: shipTo, opdRsd: opdRsd!, qcBookedQty: qcBookedQty, availableQty: availQty, isEnable: inspEnableFlag, samplingQty: samplingQty, prodDesc: prodDesc!)
            
                poItem?.market = market
                poItem?.materialCategory = materialCategory
                poItem?.shipModeName = shipModeName
                poItem?.itemBarCode = itemBarcode
                poItem?.retailPrice = retailPrice
                poItem?.targetInspectQty = targetInspectQty
                poItem?.currency = currency
                poItem?.styleSize = styleSize
                poItem?.substrStyleSize = substrStyleSize
                
                poItems.append(poItem!)
            }
            }
            
            db.close()
        }
        
        return poItems
    }
    
    func getAllPoItems(vendorId: String? = nil) ->[PoItem]? {
        var sql = "SELECT * FROM fgpo_line_item WHERE item_id IN (SELECT po_item_id FROM inspect_task_item) AND outstand_qty > 0 AND line_status <> 5 AND deleted_flag = 0"
        if let vId = vendorId {
            sql.append(" AND ref_vdr_id = \(vId)")
        }
        
        var poItems = [PoItem]()
        
        if db.open() {
            
            //Sched Po Items
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
            
                while rs.next() {
                
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = _DATEFORMATTER
                
                    let itemId = Int(rs.int(forColumn: "item_id"))
                    let dataEnv = rs.string(forColumn: "data_env")
                    let refHeadId = Int(rs.int(forColumn: "ref_head_id"))
                    let poNo = rs.string(forColumn: "po_no")
                    let refVdrId = Int(rs.int(forColumn: "ref_vdr_id"))
                    let vdrCode = rs.string(forColumn: "vdr_code")
                    let vdrName = rs.string(forColumn: "vdr_name")
                    let vdrDisplayName = rs.string(forColumn: "vdr_display_name")
                    let refLineId = Int(rs.int(forColumn: "ref_line_id"))
                    let poLineNo = rs.string(forColumn: "po_line_no")
                    let refPordId = Int(rs.int(forColumn: "ref_prod_id"))
                    let skuNo = rs.string(forColumn: "sku_no")
                    let prodTypeCode = rs.string(forColumn: "prod_type_code")
                    let styleNo = rs.string(forColumn: "style_no")
                    let dimen1 = rs.string(forColumn: "dimen_1")
                    let dimen2 = rs.string(forColumn: "dimen_2")
                    let dimen3 = rs.string(forColumn: "dimen_3")
                    let refVdrLocationId = Int(rs.int(forColumn: "ref_vdr_location_id"))
                    let vdrLocationCode = rs.string(forColumn: "vdr_location_code")
                    let vdrLocationName = rs.string(forColumn: "vdr_location_name")
                    let refBuyerLocationId = rs.string(forColumn: "ref_buyer_location_id")
                    let buyerLocationCode = rs.string(forColumn: "buyer_location_code")
                    let buyerLocationName = rs.string(forColumn: "buyer_location_name")
                    let refOrderNo = rs.string(forColumn: "ref_order_no")
                    let refOrderLine = rs.string(forColumn: "ref_order_line")
                    let refBrandId = Int(rs.int(forColumn: "ref_brand_id"))
                    let brandCode = rs.string(forColumn: "brand_code")
                    let brandName = rs.string(forColumn: "brand_name")
                    let reqDelivDate = rs.string(forColumn: "req_deliv_date")
                    var shipWin = rs.string(forColumn: "ship_win")
                    let orderQty = Int(rs.int(forColumn: "order_qty"))
                    let lineQtyUom = rs.string(forColumn: "line_qty_uom")
                    let lineStatus = Int(rs.int(forColumn: "line_status"))
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                    let deleteDate = rs.string(forColumn: "delete_date")
                    var shipTo = rs.string(forColumn: "buyer_location_code")
                    var opdRsd = rs.string(forColumn: "line_sched_text")
                    let qcBookedQty = Int(rs.int(forColumn: "qc_booked_qty"))
                    var prodDesc = rs.string(forColumn: "prod_desc")
                    let outStandQty = Int(rs.int(forColumn: "outstand_qty"))
                    
                    if (prodDesc == nil) {
                        prodDesc = ""
                    }
                    
                    if (shipTo == nil) {
                        shipTo = ""
                    }
                    
                    if shipWin != nil {
                        let shipWinTmp = shipWin
                        let shipWinTmpArray = shipWinTmp?.characters.split{$0 == " "}.map(String.init)
                        
                        if (shipWinTmpArray?.count)!>0 {
                            shipWin = shipWinTmpArray?[0]
                            
                            shipWin = dateFormatter.string(from: dateFormatter.date(from: shipWin!)!)
                        }
                    }else{
                        shipWin = ""
                    }
                    
                    
                    
                    if opdRsd != nil {
                        let opdRsdTmp = opdRsd
                        let opdRsdTmpArray = opdRsdTmp?.characters.split{$0 == " "}.map(String.init)
                        
                        if (opdRsdTmpArray?.count)! > 0 {
                            opdRsd = opdRsdTmpArray?[0]
                            opdRsd = opdRsd?.replacingOccurrences(of: ":", with: "")
                            
                            opdRsd = dateFormatter.string(from: dateFormatter.date(from: opdRsd!)!)
                        }
                    }else{
                        opdRsd = ""
                    }
                    
                    
                    let poItem = PoItem(itemId: itemId, dataEnv: dataEnv!, refHeadId: refHeadId, poNo: poNo!, refVdrId: refVdrId, vdrCode: vdrCode!, vdrName: vdrName!, vdrDisplayName: vdrDisplayName!, refLineId: refLineId, poLineNo: poLineNo!, refPordId: refPordId, skuNo: skuNo!, prodTypeCode: prodTypeCode!, styleNo: styleNo!, dimen1: dimen1, dimen2: dimen2, dimen3: dimen3, refVdrLocationId: refVdrLocationId, vdrLocationCode: vdrLocationCode!, vdrLocationName: vdrLocationName!, refBuyerLocationId: refBuyerLocationId, buyerLocationCode: buyerLocationCode!, buyerLocationName: buyerLocationName!, refOrderNo: refOrderNo!, refOrderLine: refOrderLine!, refBrandId: refBrandId, brandCode: brandCode!, brandName: brandName!, reqDelivDate: reqDelivDate!, shipWin: shipWin!, orderQty: orderQty, lineQtyUom: lineQtyUom!, lineStatus: lineStatus, createDate: createDate, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteDate: deleteDate, shipTo: shipTo, opdRsd: opdRsd!, qcBookedQty: qcBookedQty, prodDesc: prodDesc!)
                
                    poItem?.taskSched = MylocalizedString.sharedLocalizeManager.getLocalizedString("YES")
                    poItem?.outStandQty = outStandQty
                    poItems.append(poItem!)
                }
            }
            
            //Not Sched Po Items
            sql = "SELECT * FROM fgpo_line_item WHERE item_id NOT IN (SELECT po_item_id FROM inspect_task_item) AND outstand_qty > 0 AND line_status <> 5 AND deleted_flag = 0"
            if let vId = vendorId {
                sql.append(" AND ref_vdr_id = \(vId)")
            }
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                
                while rs.next() {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = _DATEFORMATTER
                    
                    let itemId = Int(rs.int(forColumn: "item_id"))
                    let dataEnv = rs.string(forColumn: "data_env")
                    let refHeadId = Int(rs.int(forColumn: "ref_head_id"))
                    let poNo = rs.string(forColumn: "po_no")
                    let refVdrId = Int(rs.int(forColumn: "ref_vdr_id"))
                    let vdrCode = rs.string(forColumn: "vdr_code")
                    let vdrName = rs.string(forColumn: "vdr_name")
                    let vdrDisplayName = rs.string(forColumn: "vdr_display_name")
                    let refLineId = Int(rs.int(forColumn: "ref_line_id"))
                    let poLineNo = rs.string(forColumn: "po_line_no")
                    let refPordId = Int(rs.int(forColumn: "ref_prod_id"))
                    let skuNo = rs.string(forColumn: "sku_no")
                    let prodTypeCode = rs.string(forColumn: "prod_type_code")
                    let styleNo = rs.string(forColumn: "style_no")
                    let dimen1 = rs.string(forColumn: "dimen_1")
                    let dimen2 = rs.string(forColumn: "dimen_2")
                    let dimen3 = rs.string(forColumn: "dimen_3")
                    let refVdrLocationId = Int(rs.int(forColumn: "ref_vdr_location_id"))
                    let vdrLocationCode = rs.string(forColumn: "vdr_location_code")
                    let vdrLocationName = rs.string(forColumn: "vdr_location_name")
                    let refBuyerLocationId = rs.string(forColumn: "ref_buyer_location_id")
                    let buyerLocationCode = rs.string(forColumn: "buyer_location_code")
                    let buyerLocationName = rs.string(forColumn: "buyer_location_name")
                    let refOrderNo = rs.string(forColumn: "ref_order_no")
                    let refOrderLine = rs.string(forColumn: "ref_order_line")
                    let refBrandId = Int(rs.int(forColumn: "ref_brand_id"))
                    let brandCode = rs.string(forColumn: "brand_code")
                    let brandName = rs.string(forColumn: "brand_name")
                    let reqDelivDate = rs.string(forColumn: "req_deliv_date")
                    var shipWin = rs.string(forColumn: "ship_win")
                    let orderQty = Int(rs.int(forColumn: "order_qty"))
                    let lineQtyUom = rs.string(forColumn: "line_qty_uom")
                    let lineStatus = Int(rs.int(forColumn: "line_status"))
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                    let deleteDate = rs.string(forColumn: "delete_date")
                    var shipTo = rs.string(forColumn: "buyer_location_code")
                    var opdRsd = rs.string(forColumn: "line_sched_text")
                    let qcBookedQty = Int(rs.int(forColumn: "qc_booked_qty"))
                    var prodDesc = rs.string(forColumn: "prod_desc")
                    let outStandQty = Int(rs.int(forColumn: "outstand_qty"))
                    
                    if (prodDesc == nil) {
                        prodDesc = ""
                    }
                    
                    if (shipTo == nil) {
                        shipTo = ""
                    }
                    
                    if shipWin != nil {
                        let shipWinTmp = shipWin
                        let shipWinTmpArray = shipWinTmp?.characters.split{$0 == " "}.map(String.init)
                        
                        if (shipWinTmpArray?.count)!>0 {
                            shipWin = shipWinTmpArray?[0]
                            
                            shipWin = dateFormatter.string(from: dateFormatter.date(from: shipWin!)!)
                        }
                    }else{
                        shipWin = ""
                    }
                    
                    if opdRsd != nil {
                        let opdRsdTmp = opdRsd
                        let opdRsdTmpArray = opdRsdTmp?.characters.split{$0 == " "}.map(String.init)
                        
                        if (opdRsdTmpArray?.count)! > 0 {
                            opdRsd = opdRsdTmpArray?[0]
                            opdRsd = opdRsd?.replacingOccurrences(of: ":", with: "")
                            
                            opdRsd = dateFormatter.string(from: dateFormatter.date(from: opdRsd!)!)
                        }
                    }else{
                        opdRsd = ""
                    }
                    
                    
                    let poItem = PoItem(itemId: itemId, dataEnv: dataEnv!, refHeadId: refHeadId, poNo: poNo!, refVdrId: refVdrId, vdrCode: vdrCode!, vdrName: vdrName!, vdrDisplayName: vdrDisplayName!, refLineId: refLineId, poLineNo: poLineNo!, refPordId: refPordId, skuNo: skuNo!, prodTypeCode: prodTypeCode!, styleNo: styleNo!, dimen1: dimen1, dimen2: dimen2, dimen3: dimen3, refVdrLocationId: refVdrLocationId, vdrLocationCode: vdrLocationCode!, vdrLocationName: vdrLocationName!, refBuyerLocationId: refBuyerLocationId, buyerLocationCode: buyerLocationCode!, buyerLocationName: buyerLocationName!, refOrderNo: refOrderNo!, refOrderLine: refOrderLine!, refBrandId: refBrandId, brandCode: brandCode!, brandName: brandName!, reqDelivDate: reqDelivDate!, shipWin: shipWin!, orderQty: orderQty, lineQtyUom: lineQtyUom!, lineStatus: lineStatus, createDate: createDate, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteDate: deleteDate, shipTo: shipTo, opdRsd: opdRsd!, qcBookedQty: qcBookedQty, prodDesc: prodDesc!)
                    
                    poItem?.taskSched = MylocalizedString.sharedLocalizeManager.getLocalizedString("NO")
                    poItem?.outStandQty = outStandQty
                    poItems.append(poItem!)
                }
            }
            
            db.close()
        
            return poItems
        }
        
        return nil
    }
    
    func getAllPoItems(_ vdrDisName:String, vdrLocName:String) ->[PoItem]? {
        //let sql = "SELECT * FROM fgpo_line_item WHERE item_id NOT IN (SELECT po_item_id FROM inspect_task_item) AND vdr_display_name = ? AND vdr_location_name = ? AND order_qty > qc_booked_qty"
        let sql = "SELECT * FROM fgpo_line_item WHERE item_id NOT IN (SELECT po_item_id FROM inspect_task_item) AND vdr_display_name = ? AND vdr_location_name = ? AND outstand_qty > 0 AND line_status <> 5 AND deleted_flag = 0"
        
        var poItems = [PoItem]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [vdrDisName,vdrLocName]) {
            
            while rs.next() {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = _DATEFORMATTER
                
                let itemId = Int(rs.int(forColumn: "item_id"))
                let dataEnv = rs.string(forColumn: "data_env")
                let refHeadId = Int(rs.int(forColumn: "ref_head_id"))
                let poNo = rs.string(forColumn: "po_no")
                let refVdrId = Int(rs.int(forColumn: "ref_vdr_id"))
                let vdrCode = rs.string(forColumn: "vdr_code")
                let vdrName = rs.string(forColumn: "vdr_name")
                let vdrDisplayName = rs.string(forColumn: "vdr_display_name")
                let refLineId = Int(rs.int(forColumn: "ref_line_id"))
                let poLineNo = rs.string(forColumn: "po_line_no")
                let refPordId = Int(rs.int(forColumn: "ref_prod_id"))
                let skuNo = rs.string(forColumn: "sku_no")
                let prodTypeCode = rs.string(forColumn: "prod_type_code")
                let styleNo = rs.string(forColumn: "style_no")
                let dimen1 = rs.string(forColumn: "dimen_1")
                let dimen2 = rs.string(forColumn: "dimen_2")
                let dimen3 = rs.string(forColumn: "dimen_3")
                let refVdrLocationId = Int(rs.int(forColumn: "ref_vdr_location_id"))
                let vdrLocationCode = rs.string(forColumn: "vdr_location_code")
                let vdrLocationName = rs.string(forColumn: "vdr_location_name")
                let refBuyerLocationId = rs.string(forColumn: "ref_buyer_location_id")
                let buyerLocationCode = rs.string(forColumn: "buyer_location_code")
                let buyerLocationName = rs.string(forColumn: "buyer_location_name")
                let refOrderNo = rs.string(forColumn: "ref_order_no")
                let refOrderLine = rs.string(forColumn: "ref_order_line")
                let refBrandId = Int(rs.int(forColumn: "ref_brand_id"))
                let brandCode = rs.string(forColumn: "brand_code")
                let brandName = rs.string(forColumn: "brand_name")
                let reqDelivDate = rs.string(forColumn: "req_deliv_date")
                var shipWin = rs.string(forColumn: "ship_win")
                let orderQty = Int(rs.int(forColumn: "order_qty"))
                let lineQtyUom = rs.string(forColumn: "line_qty_uom")
                let lineStatus = Int(rs.int(forColumn: "line_status"))
                let createDate = rs.string(forColumn: "create_date")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = Int(rs.int(forColumn: "deleted_flag"))
                let deleteDate = rs.string(forColumn: "delete_date")
                var shipTo = rs.string(forColumn: "buyer_location_code")
                var opdRsd = rs.string(forColumn: "line_sched_text")
                let qcBookedQty = Int(rs.int(forColumn: "qc_booked_qty"))
                var prodDesc = rs.string(forColumn: "prod_desc")
                let outStandQty = Int(rs.int(forColumn: "outstand_qty"))
                
                if (prodDesc == nil) {
                    prodDesc = ""
                }
                
                if (shipTo == nil) {
                    shipTo = ""
                }
                
                if shipWin != nil {
                    let shipWinTmp = shipWin
                    let shipWinTmpArray = shipWinTmp?.characters.split{$0 == " "}.map(String.init)
                    
                    if (shipWinTmpArray?.count)!>0 {
                        shipWin = shipWinTmpArray?[0]
                        
                        shipWin = dateFormatter.string(from: dateFormatter.date(from: shipWin!)!)
                    }
                }else{
                    shipWin = ""
                }
                
                
                if opdRsd != nil {
                    let opdRsdTmp = opdRsd
                    let opdRsdTmpArray = opdRsdTmp?.characters.split{$0 == " "}.map(String.init)
                    
                    if (opdRsdTmpArray?.count)! > 0 {
                        opdRsd = opdRsdTmpArray?[0]
                        opdRsd = opdRsd?.replacingOccurrences(of: ":", with: "")
                        
                        opdRsd = dateFormatter.string(from: dateFormatter.date(from: opdRsd!)!)
                    }
                }else{
                    opdRsd = ""
                }
                
                
                let poItem = PoItem(itemId: itemId, dataEnv: dataEnv!, refHeadId: refHeadId, poNo: poNo!, refVdrId: refVdrId, vdrCode: vdrCode!, vdrName: vdrName!, vdrDisplayName: vdrDisplayName!, refLineId: refLineId, poLineNo: poLineNo!, refPordId: refPordId, skuNo: skuNo!, prodTypeCode: prodTypeCode!, styleNo: styleNo!, dimen1: dimen1, dimen2: dimen2, dimen3: dimen3, refVdrLocationId: refVdrLocationId, vdrLocationCode: vdrLocationCode!, vdrLocationName: vdrLocationName!, refBuyerLocationId: refBuyerLocationId, buyerLocationCode: buyerLocationCode!, buyerLocationName: buyerLocationName!, refOrderNo: refOrderNo!, refOrderLine: refOrderLine!, refBrandId: refBrandId, brandCode: brandCode!, brandName: brandName!, reqDelivDate: reqDelivDate!, shipWin: shipWin!, orderQty: orderQty, lineQtyUom: lineQtyUom!, lineStatus: lineStatus, createDate: createDate, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteDate: deleteDate, shipTo: shipTo, opdRsd: opdRsd!, qcBookedQty: qcBookedQty, prodDesc: prodDesc!)
                
                poItem?.outStandQty = outStandQty
                poItems.append(poItem!)
            }
            }
            
            db.close()
            
            return poItems
        }
        
        return nil
    }
    
    func insertTask(_ task:Task) ->Int {
        let sql = "INSERT INTO inspect_Task  ('task_id','prod_type_id','inspect_type_id','booking_no','booking_date','vdr_location_id','report_inspector_id','report_prefix','inspection_no','inspection_date','task_remarks','vdr_notes','inspect_result_value_id','inspector_sign_image_file','vdr_sign_name','vdr_sign_image_file','task_status','upload_inspector_id','upload_device_id','ref_task_id','rec_status','create_user','create_date','modify_user','modify_date','deleted_flag','delete_user','delete_date','inspect_setup_id','tmpl_id','report_running_no') VALUES ((SELECT task_id FROM inspect_task WHERE task_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        var lastId=0
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: [task.taskId!,task.prodTypeId!,task.inspectionTypeId!,task.bookingNo!,task.bookingDate!,task.vdrLocationId!,task.reportInspectorId!,task.reportPrefix!,task.inspectionNo!,task.inspectionDate!,task.taskRemarks!,task.vdrNotes!,task.inspectionResultValueId!,task.inspectionSignImageFile!,task.vdrSignName!,task.vdrSignImageFile!,task.taskStatus!,task.uploadInspectorId!,task.uploadDeviceId!,task.refTaskId!,task.recStatus!,task.createUser!,task.createDate!,task.modifyUser!,task.modifyDate!,task.deleteFlag!,task.deleteUser!,task.deleteDate!,task.inspectSetupId!,task.tmplId!,task.reportRunningNo!]) {
                
                lastId = Int(db.lastInsertRowId)
            }
            
            db.close()
        }
        
        return lastId
    }
    
    func updateTask(_ task:Task) ->Int {
        let sql = "INSERT OR REPLACE INTO inspect_Task  ('task_id','prod_type_id','inspect_type_id','booking_no','booking_date','vdr_location_id','report_inspector_id','report_prefix','inspection_no','inspection_date','task_remarks','vdr_notes','inspect_result_value_id','inspector_sign_image_file','vdr_sign_name','vdr_sign_image_file','task_status','upload_inspector_id','upload_device_id','ref_task_id','rec_status','create_user','create_date','modify_user','modify_date','deleted_flag','delete_user','delete_date','inspect_setup_id','tmpl_id','report_running_no') VALUES ((SELECT task_id FROM inspect_task WHERE task_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        
        var lastId=0
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: [task.taskId!,task.prodTypeId!,task.inspectionTypeId!,task.bookingNo!,task.bookingDate!,task.vdrLocationId!,task.reportInspectorId!,task.reportPrefix!,task.inspectionNo!,task.inspectionDate!,task.taskRemarks!,task.vdrNotes!,task.inspectionResultValueId!,task.inspectionSignImageFile!,task.vdrSignName!,task.vdrSignImageFile!,task.taskStatus!,task.uploadInspectorId!,task.uploadDeviceId!,task.refTaskId!,task.recStatus!,task.createUser!,task.createDate!,task.modifyUser!,task.modifyDate!,task.deleteFlag!,task.deleteUser!,task.deleteDate!,task.inspectSetupId!,task.tmplId!,task.reportRunningNo!]) {
                
                lastId = Int(db.lastInsertRowId)
            }
            
            db.close()
        }
        
        return lastId
    }
    
    func InsertTaskItem(_ taskItem:TaskItem) -> Int {
        let sql = "INSERT INTO inspect_task_item ('task_id','po_item_id','target_inspect_qty','avail_inspect_qty','inspect_enable_flag','create_user','create_date','modify_user','modify_date','sampling_qty') VALUES (?,?,?,?,?,?,?,?,?,?)"
        var lastId=0
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: [taskItem.taskId!,taskItem.poItemId!,taskItem.targetInspectQty!,taskItem.availInspectQty!,taskItem.inspectEnableFlag!,taskItem.createUser!,taskItem.createDate!,taskItem.modifyUser!,taskItem.modifyDate!,taskItem.samplingQty!]) {
                lastId = Int(db.lastInsertRowId)
            }
    
            db.close()
        }
        return lastId
    }
    
    func updateTaskItem(_ taskItem:TaskItem) -> Int {
        let sql = "INSERT OR REPLACE INTO inspect_task_item ('task_id','po_item_id','target_inspect_qty','avail_inspect_qty','inspect_enable_flag','create_user','create_date','modify_user','modify_date','sampling_qty') VALUES (?,?,?,?,?,?,?,?,?,?)"
        var lastId=0
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: [taskItem.taskId!,taskItem.poItemId!,taskItem.targetInspectQty!,taskItem.availInspectQty!,taskItem.inspectEnableFlag!,taskItem.createUser!,taskItem.createDate!,taskItem.modifyUser!,taskItem.modifyDate!,taskItem.samplingQty!]) {
                lastId = Int(db.lastInsertRowId)
            }
            
            db.close()
        }
        return lastId
    }
    
    
    
    func insertTaskInspector(_ taskInspector:TaskInspector) -> Bool {
        let sql = "INSERT INTO inspect_task_inspector ('inspector_id','create_user','create_date','modify_user','modify_date','inspect_enable_flag', 'task_id') VALUES (?,?,?,?,?,?,?)"
        var result = false
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: [taskInspector.inspectorId!,taskInspector.createUser!,taskInspector.createDate!,taskInspector.modifyUser!,taskInspector.modifyDate!,taskInspector.inspectEnableFlag!, taskInspector.taskId!]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func updateTaskInspector(_ taskInspector:TaskInspector) -> Bool {
        let sql = "INSERT OR REPLACE INTO inspect_task_inspector ('inspector_id','create_user','create_date','modify_user','modify_date','inspect_enable_flag', 'task_id') VALUES (?,?,?,?,?,?,?)"
        var result = false
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: [taskInspector.inspectorId!,taskInspector.createUser!,taskInspector.createDate!,taskInspector.modifyUser!,taskInspector.modifyDate!,taskInspector.inspectEnableFlag!, taskInspector.taskId!]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func updateTaskPoItemStatus(_ taskId:Int, poItemId:Int) {
        let sql = "UPDATE inspect_task_item SET inspect_enable_flag = 0 WHERE task_id = ? AND po_item_id = ?"
        
        if db.open() {
            if taskId>0 && poItemId>0 {
                db.executeUpdate(sql, withArgumentsIn: [taskId, poItemId])
            }
            db.close()
        }
    }
    
    func getAllStyleNoByValue(_ inputValue:String, vendorName:String="", vendorLocationCode:String="") ->[String] {
        var sql = "SELECT DISTINCT style_no FROM fgpo_line_item WHERE style_no LIKE ? AND vdr_display_name = ? AND vdr_location_code = ? AND outstand_qty > 0 AND line_status <> 5"
        //let sql = "SELECT DISTINCT(style_no) FROM fgpo_line_item fli INNER JOIN inspect_task_item iti ON fli.item_id = iti.po_item_id WHERE style_no LIKE ?"
        var styleNoList = [String]()
        if vendorName == "" && vendorLocationCode == "" {
            sql = "SELECT DISTINCT style_no FROM fgpo_line_item WHERE style_no LIKE ? AND outstand_qty > 0 AND line_status <> 5"
        }
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["%"+inputValue+"%", vendorName, vendorLocationCode]) {
                while rs.next() {
                    styleNoList.append(rs.string(forColumn: "style_no") ?? "")
                }
            }
            
            db.close()
        }
        
        return styleNoList
    }
    
    func getAllTaskPoNo(_ inputValue:String) ->[String] {
        
        let sql = "SELECT DISTINCT po_no FROM fgpo_line_item fli INNER JOIN inspect_task_item iti ON fli.item_id = iti.po_item_id WHERE po_no LIKE ?"
        
        var poNoList = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["%"+inputValue+"%"]) {
                while rs.next() {
                    poNoList.append(rs.string(forColumn: "po_no") ?? "")
                }
            }
            
            db.close()
        }
        
        return poNoList
    }
    
    func getAllPoNo(_ inputValue:String, vendorName:String="", vendorLocationCode:String="") ->[String] {
        var sql = "SELECT DISTINCT po_no FROM fgpo_line_item fli WHERE po_no LIKE ? AND vdr_display_name = ? AND vdr_location_code = ? AND outstand_qty > 0 AND line_status <> 5"
        var poNoList = [String]()
        if vendorName == "" && vendorLocationCode == "" {
            sql = "SELECT DISTINCT po_no FROM fgpo_line_item fli WHERE po_no LIKE ? AND outstand_qty > 0 AND line_status <> 5"
        }
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["%"+inputValue+"%", vendorName, vendorLocationCode]) {
                while rs.next() {
                    poNoList.append(rs.string(forColumn: "po_no") ?? "")
                }
            }
            
            db.close()
        }
        
        return poNoList
    }
}
