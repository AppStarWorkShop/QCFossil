//
//  SummaryResultValue.swift
//  QCFossil
//
//  Created by Yin Huang on 24/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class SummaryResultValue{
    var sectionId:Int
    var sectionName:String
    var valueId:Int
    var valueName:String
    var resultCount:Int
    
    init(sectionId:Int, sectionName:String, valueId:Int, valueName:String, resultCount:Int) {
        self.sectionId = sectionId
        self.sectionName = sectionName
        self.valueId = valueId
        self.valueName = valueName
        self.resultCount = resultCount
    }
    
    func clear() {
        self.resultCount = 0
    }
}