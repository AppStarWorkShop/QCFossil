//
//  Photo.swift
//  QCFossil
//
//  Created by pacmobile on 23/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class Photo {
    var photo:UIImageView?
    var photoFilename:String
    
    //db
    var photoId:Int?
    var taskId:Int
    var refTaskId:Int?
    var refPhotoId:Int?
    var orgFileName:String?
    var photoFile:String
    var thumbFile:String?
    var photoDesc:String?
    var dataRecordId:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var dataType:Int?
    
    //extension
    var inspCatName:String?=""
    var inspAreaName:String?=""
    var inspItemName:String?=""
    var taskBookingNo:String?=""
    
    //parentInspElmt
    var inspElmt:InputModeICMaster?
    
    init?(photo:UIImageView?, photoFilename:String, taskId:Int, photoFile:String, refTaskId:Int? = nil) {
        self.photo = photo
        self.photoFilename = photoFilename
        self.taskId = taskId
        self.photoFile = photoFile
        self.refTaskId = refTaskId
    }
}
