//
//  Inspector.swift
//  QCFossil
//
//  Created by Yin Huang on 4/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class Inspector {
    
    var inspectorId:Int?
    var inspectorName:String?
    var prodTypeId:Int?
    var appUserName:String?
    var appPassword:String?
    var serviceToken:String?
    var reportPrefix:String?
    var reportRunningNo:String?
    var phoneNo:String?
    var emailAddr:String?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var recStatus:Int?
    var deleteFlag:Int?
    var deleteUser:String?
    var deleteDate:String?
    var chgPwdReqDate:String?
    var typeCode:String?
    
    //Last Login Date, For UI Display Only
    var lastLoginDate:String = ""
    var selectedInspType:String = ""
    
    init(inspectorId:Int?, inspectorName:String?, prodTypeId:Int?, appUserName:String?, appPassword:String?, serviceToken:String?, reportPrefix:String?, reportRunningNo:String?, phoneNo:String?, emailAddr:String?, typeCode:String?) {
        
        self.inspectorId = inspectorId
        self.inspectorName = inspectorName
        self.prodTypeId = prodTypeId
        self.appUserName = appUserName
        self.appPassword = appPassword
        self.serviceToken = serviceToken
        self.reportPrefix = reportPrefix
        self.reportRunningNo = reportRunningNo
        self.phoneNo = phoneNo
        self.emailAddr = emailAddr
        self.typeCode = typeCode
    }
    
}