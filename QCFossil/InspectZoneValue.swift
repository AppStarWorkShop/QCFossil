//
//  InspectZoneValue.swift
//  QCFossil
//
//  Created by pacmobile on 26/5/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import Foundation

class DropdownValue {
    var valueId:Int?
    var valueNameEn:String?
    var valueNameCn:String?
    var valueNameFr:String?
    
    init(valueId:Int?, valueNameEn:String?, valueNameCn:String?, valueNameFr:String?) {
        self.valueId = valueId
        self.valueNameEn = valueNameEn
        self.valueNameCn = valueNameCn
        self.valueNameFr = valueNameFr
    }
}
