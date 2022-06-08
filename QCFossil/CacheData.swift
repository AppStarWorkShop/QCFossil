//
//  CacheData.swift
//  QCFossil
//
//  Created by pacmobile on 21/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

//Cache data is used for global
var Cache_Task_On:Task?
var Cache_Task_Path:String?
var Cache_Thumb_Path:String?

//Inspector
var Cache_Inspector:Inspector?

//DropDownObj
var Cache_Dropdown_Instance:DropdownListViewControl?

let Cache_NegativeResultValues: [String] = [
    "Fail",
    "不合格",
    "Reject (Comment)",
    "拒绝 (待评语)",
    "Reject (Document)",
    "拒绝 (欠文件)",
    "Reject (No Reinspect)",
    "不合格 (不需要重验)",
    "Reject (Reinspect)",
    "不合格 (重验)"
]

let Cache_NegativeResultValueIds: [Int] = [3, 6, 7, 10, 11]
