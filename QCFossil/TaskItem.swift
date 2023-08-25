//
//  TaskItem.swift
//  QCFossil
//
//  Created by pacmobile on 26/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class TaskItem {
    var taskId:Int?
    var poItemId:Int?
    var targetInspectQty:Int?
    var availInspectQty:Int?
    var inspectEnableFlag:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var samplingQty:Int?
    var ref_qc_plan_line_id:Int?
    var sampling_qty:Int?
    var item_barcode:String?
    var retail_price:String?
    var currency:String?
    var style_size:String?
    var substr_style_size:String?
    
    init(taskId:Int, poItemId:Int, targetInspectQty:Int, availInspectQty:Int, inspectEnableFlag:Int, createUser:String?, createDate:String?, modifyUser:String?, modifyDate:String?, samplingQty:Int?) {
        
        self.taskId = taskId
        self.poItemId = poItemId
        self.targetInspectQty = targetInspectQty
        self.availInspectQty = availInspectQty
        self.inspectEnableFlag = inspectEnableFlag
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.samplingQty = samplingQty
    }
}