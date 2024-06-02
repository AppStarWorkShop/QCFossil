//
//  InputModeDFMaster2.swift
//  QCFossil
//
//  Created by pacmobile on 17/10/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class InputModeDFMaster2: UITableViewCell, UITextFieldDelegate {
    
    var cellIdx = 0
    var sectionId = 0
    var itemId = 0
    var photoAdded = PhotoAddedStatus.init(caseId: "no").rawValue
    var inputMode:String?
    var photos = [Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: ""),Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: ""),Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: ""),Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: ""),Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: "")]
    
    //var xPos = [79, 158, 238, 318, 398]
    //var xPosBtn = [109, 188, 268, 348, 428]
    var xPos = [190, 260, 330, 400, 470]
    var xPosBtn = [220, 290, 360, 430, 500]
    var photoNameAtIndex = ["","","","",""]
    
    //DB
    var defectDBId = 0
    weak var inspItem:InputModeICMaster?
    var taskDefectDataRecordId:Int?
    var inspectElementId:Int?
    var inspectElementDefectValueId:Int?
    var inspectElementCaseValueId:Int?
    var defectRemarksOptionList:String? 
    
    //UI
    var dfCatText = ""
    var dfItemText = ""
    var dfDescText = ""
    var dfRemarkText = ""
    var dfQty = ""
    
    func textFieldDidEndEditing(_ textField: UITextField) {
                
        if textField.keyboardType == UIKeyboardType.numberPad {
            if textField.text == "" {
                textField.text = ""
            }
        }else{
        
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
            
                defectItem.defectDesc = textField.text
            }
        }
        
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Cache_Task_On?.didModify = true
        var inputValue = ""
        if textField.text!.characters.count < 2 && string == "" {
            inputValue = ""
        }else if string == ""{
            inputValue = String(textField.text!.characters.dropLast())
        }else {
            inputValue = textField.text! + string
        }
        
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        
        if textField.keyboardType == UIKeyboardType.numberPad {
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                
                if Int(inputValue) != nil {
                    defectItem.defectQtyTotal = Int(inputValue)!
                }
                
            }
            
            return textField.numberOnlyCheck(textField, sourceText: string)
        }else{
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                
                defectItem.defectDesc = inputValue
            }
        }
        
        return true
    }
    
    func savePhotoToLocal_bak(_ photo:Photo) ->Photo? {
        if photo.photo?.image != nil {
            
            let originName = String(describing: photo.photo!.image!.imageAsset)
            
            //If record has been saved
            if self.taskDefectDataRecordId > 0 {
                return photo.photo?.image!.saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: originName)
                
            }else{//If record has no recordId
                return photo.photo?.image!.saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: 0, dataType: PhotoDataType(caseId: "TASK").rawValue, currentDate: self.getCurrentDateTime(), originFileName: originName)
                
            }
        }
        
        return nil
    }
    
    func savePhotoToLocal(_ photo:Photo) ->Photo? {
        if photo.photo?.image != nil {
            
            let originName = "originName"//String(photo.photo!.image!.imageAsset)
            
            //If record has been saved
            if self.taskDefectDataRecordId > 0 {
                return photo.photo?.image!.saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: originName)
                
            }else{//If record has no recordId
                return photo.photo?.image!.saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: 0, dataType: PhotoDataType(caseId: "TASK").rawValue, currentDate: self.getCurrentDateTime(), originFileName: originName)
                
            }
        }
        
        return nil
    }

    func clearDefectPhotoDataByPhotoName(_ photoName:String) {
        
        //Remove defect photo to Photo Album
        let photoDataHelper = PhotoDataHelper()
        let photo = photoDataHelper.updatePhotoDatasByPhotoName(photoName, dataType:PhotoDataType(caseId: "TASK").rawValue, dataRecordId:0)
            
        //Update Photo Album
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAddPhotos"), object: nil, userInfo: ["photoSelected":photo!])
    }
    
    func clearDefectPhotoData(_ photo:Photo) {
        
        if photo.photoId > 0 {
            //Remove defect photo to Photo Album
            let photoDataHelper = PhotoDataHelper()
            photoDataHelper.updatePhotoDatas((photo.photoId)!, dataType:PhotoDataType(caseId: "TASK").rawValue, dataRecordId:0)
                
            //Update Photo Album
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAddPhotos"), object: nil, userInfo: ["photoSelected":photo])
        }
    }
    
    func clearDefectPhotoDataAtIndex(_ index:Int) {
        
        let photoName = photoNameAtIndex[index]
        
        //Remove defect photo to Photo Album
        let photoDataHelper = PhotoDataHelper()
        photoDataHelper.updatePhotoDatasByPhotoName(photoName, dataType:PhotoDataType(caseId: "TASK").rawValue, dataRecordId:0)
        
        //Clear Photos
        photoNameAtIndex[index] = ""
    }
    
    func refreshPhotos() ->[Photo?] {
        var photosTmp = [Photo]()
        
        if self.photos.count > 0 {
            for photo in self.photos {
                if photo!.photo != nil {
                    photosTmp.append(photo!)
                }
            }
            
            self.photos = [Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: ""),Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: ""),Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: ""),Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: ""),Photo(photo: nil, photoFilename: "", taskId: 0, photoFile: "")]
            
            if photosTmp.count > 0 {
                for idx in 0...photosTmp.count-1 {
                    self.photos[idx] = photosTmp[idx]
                }
            }
        }
        
        return self.photos
    }
    
    func updateDefectPhotoData(_ index:Int, photo:Photo, needSave:Bool=true) ->Photo? {
        if index < photos.count {
            
            //Save self to DB for TaskInspDefectRecordId
            if self.taskDefectDataRecordId<1 {
                let taskDataHelper = TaskDataHelper()
                let defectItem = TaskInspDefectDataRecord(recordId: self.taskDefectDataRecordId,taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.inspItem?.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.inspItem?.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime())
                self.taskDefectDataRecordId = taskDataHelper.updateInspDefectDataRecord(defectItem!)
                
                let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
                
                if defectItemFilter?.count > 0 {
                    let defectItem = defectItemFilter![0]
                    defectItem.recordId = self.taskDefectDataRecordId
                }
            }
            
            //Update Task Photo DB
            if self.taskDefectDataRecordId > 0 && photo.photoId > 0 {
                let photoDataHelper = PhotoDataHelper()
                photoDataHelper.updatePhotoDatas(photo.photoId!, dataType:PhotoDataType(caseId: "DEFECT").rawValue, dataRecordId:self.taskDefectDataRecordId!)
            }
            
            //Save Photo to Local
            if needSave {
                photos[index] = savePhotoToLocal(photo)
                
            }else{
                photos[index] = photo
            }
            
            return photos[index]!
        }
 
        return nil
    }
    
    func getNameByUpdateDefectPhotoData(_ index:Int, photo:Photo, needSave:Bool=true) ->String {
        
        //Save self to DB for TaskInspDefectRecordId
        if self.taskDefectDataRecordId<1 {
            let taskDataHelper = TaskDataHelper()
            let defectItem = TaskInspDefectDataRecord(recordId: self.taskDefectDataRecordId,taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.inspItem?.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.inspItem?.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime())
            self.taskDefectDataRecordId = taskDataHelper.updateInspDefectDataRecord(defectItem!)
            
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            
            if defectItemFilter?.count > 0 {
                let defectItem = defectItemFilter![0]
                defectItem.recordId = self.taskDefectDataRecordId
            }
        }
            
        //Update Task Photo DB
        if self.taskDefectDataRecordId > 0 && photo.photoId > 0 {
            let photoDataHelper = PhotoDataHelper()
            photoDataHelper.updatePhotoDatas(photo.photoId!, dataType:PhotoDataType(caseId: "DEFECT").rawValue, dataRecordId:self.taskDefectDataRecordId!)
        }
            
        return photo.photoFile
    }
    
    func deleteTaskInspDefectDataRecord(_ id:Int) {
        let taskDataHelper = TaskDataHelper()
        taskDataHelper.deleteTaskInspDefectDataRecordById(id)
    }
    
    //For override
    func removeDefectCell() {
        
    }
    
    func setSelectedPhoto(_ photo:Photo, needSave:Bool=true) {
        
    }
}
