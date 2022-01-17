//
//  InspSectionElement.swift
//  QCFossil
//
//  Created by pacmobile on 27/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class InspSectionElement {
    
    var elementId:Int?
    var inspectSetupId:Int?
    var elementNameEn:String?
    var elementNameCn:String?
    var elementNameFr:String?
    var prodTypeId:Int?
    var inspectTypeId:Int?
    var elementType:Int?
    var inspectSectionId:Int?
    var inspectPositionId:Int?
    var displayOrder:Int?
    var resultSetId:Int?
    var requiredElementFlag:Int?
    var detailDefaultValue:String?
    var detailRequiredResultList:String?
    var detailSuggestFlag:Int?
    var recStatus:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var deletedFlag:Int?
    var deleteUser:String?
    var deleteDate:String?
    var resultValueId:Int = 0
    var taskInspDataRecordId:Int?
    var requestSectionId:Int?
    var requestElementDesc:String?
    
    init(elementId:Int, inspectSetupId:Int, elementNameEn:String, elementNameCn:String, elementNameFr:String, prodTypeId:Int, inspectTypeId:Int, elementType:Int, inspectSectionId:Int, inspectPositionId:Int, displayOrder:Int, resultSetId:Int, requiredElementFlag:Int, detailDefaultValue:String, detailRequiredResultList:String, detailSuggestFlag:Int, recStatus:Int, createUser:String, createDate:String, modifyUser:String, modifyDate:String, deletedFlag:Int, deleteUser:String?, deleteDate:String?) {
        
        self.elementId = elementId
        self.inspectSetupId = inspectSetupId
        self.elementNameEn = elementNameEn
        self.elementNameCn = elementNameCn
        self.elementNameFr = elementNameFr
        self.prodTypeId = prodTypeId
        self.inspectTypeId = inspectTypeId
        self.elementType = elementType
        self.inspectSectionId = inspectSectionId
        self.inspectPositionId = inspectPositionId
        self.displayOrder = displayOrder
        self.resultSetId = resultSetId
        self.requiredElementFlag = requiredElementFlag
        self.detailDefaultValue = detailDefaultValue
        self.detailRequiredResultList = detailRequiredResultList
        self.detailSuggestFlag = detailSuggestFlag
        self.recStatus = recStatus
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.deletedFlag = deletedFlag
        self.deleteUser = deleteUser
        self.deleteDate = deleteDate
    }
}
