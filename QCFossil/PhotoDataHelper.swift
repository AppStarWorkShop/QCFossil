//
//  PhotoDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 17/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
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


class PhotoDataHelper:DataHelperMaster {
    
    func getPhotosByTaskId(_ taskId:Int, dataType:Int) ->[Photo]? {
        let sql = "SELECT * FROM task_inspect_photo_file WHERE task_id = ? AND data_type<?"
        var photos = [Photo]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, dataType]) {
            
            while rs.next() {
                
                let photoId = Int(rs.int(forColumn: "photo_id"))
                let taskId = Int(rs.int(forColumn: "task_id"))
                let refPhotoId = Int(rs.int(forColumn: "ref_photo_id"))
                let orgFileName = rs.string(forColumn: "org_filename")
                let photoFile = rs.string(forColumn: "photo_file")
                let thumbFile = rs.string(forColumn: "thumb_file")
                let photoDesc = rs.string(forColumn: "photo_desc")
                let dataRecordId = Int(rs.int(forColumn: "data_record_id"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let dataType = Int(rs.int(forColumn: "data_type"))
                
                let photo = Photo(photo: nil, photoFilename: photoFile!, taskId: taskId, photoFile: photoFile!)
                
                photo?.photoId = photoId
                photo?.refPhotoId = refPhotoId
                photo?.orgFileName = orgFileName
                photo?.thumbFile = thumbFile
                photo?.photoDesc = photoDesc
                photo?.dataRecordId = dataRecordId
                photo?.createUser = createUser
                photo?.createDate = createDate
                photo?.modifyUser = modifyUser
                photo?.modifyDate = modifyDate
                photo?.dataType = dataType
                
                photos.append(photo!)
            }
            }
            
            db.close()
            
            for photo in photos {
                updateInspInfoToPhoto(photo)
            }
            
            return photos
        }
        
        return nil
    }
    
    func savePhoto(_ photo:Photo) ->Photo? {
        let sql = "INSERT OR REPLACE INTO task_inspect_photo_file  ('photo_id','task_id','ref_photo_id','org_filename','photo_file','thumb_file','photo_desc','data_record_id','create_user','create_date','modify_user','modify_date','data_type') VALUES ((SELECT photo_id FROM task_inspect_photo_file WHERE photo_id = ?),?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if db.open() {
            let photoId = photo.photoId ?? 0
            let taskId = photo.taskId
            let refPhotoId = photo.refPhotoId ?? 0
            let photoFile = photo.photoFile
            let thumbFile = photo.thumbFile ?? ""
            let photoDesc = photo.photoDesc ?? ""
            let dataRecordId = photo.dataRecordId ?? 0
            let createUser = photo.createUser ?? ""
            let createDate = photo.createDate ?? ""
            let modifyUser = photo.modifyUser ?? ""
            let modifyDate = photo.modifyDate ?? ""
            let dataType = photo.dataType ?? 0
            
            if db.executeUpdate(sql, withArgumentsIn: [photoId, taskId, refPhotoId, photoFile, photoFile, thumbFile, photoDesc, dataRecordId, createUser, createDate, modifyUser, modifyDate, dataType]){
                photo.photoId = Int(db.lastInsertRowId)
                
                db.close()
                
                updateInspInfoToPhoto(photo)
                
                return photo
            }
            
            db.close()
        }
        
        return nil
    }
    
    /*
    func updateInspInfoToPhoto(photo:Photo) {
        /*
        DataType:
        0: Task
        1: Inspect
        2: Defect
        */
        if photo.dataType < 1{
            return
        }
        
        let sql = "SELECT iem.element_name_en,iem.element_name_cn,ipm.position_name_en,ipm.position_name_cn,ism.section_name_en,ism.section_name_cn  FROM inspect_element_mstr AS iem INNER JOIN inspect_position_mstr AS ipm ON iem.inspect_position_id = ipm.position_id INNER JOIN inspect_section_mstr AS ism INNER JOIN task_inspect_data_record AS tidr ON iem.element_id=tidr.inspect_element_id AND ipm.position_id=tidr.inspect_position_id AND ism.section_id=tidr.inspect_section_id INNER JOIN task_inspect_photo_file AS tipf ON tidr.record_id = tipf.data_record_id WHERE tipf.data_record_id = ?"
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsInArray: [photo.dataRecordId!]) {
                if rs.next() {
                    photo.inspAreaName = _ENGLISH ? rs.stringForColumn("position_name_en") : rs.stringForColumn("position_name_cn")
                    photo.inspCatName = _ENGLISH ? rs.stringForColumn("section_name_en") : rs.stringForColumn("section_name_cn")
                    photo.inspItemName = _ENGLISH ? rs.stringForColumn("element_name_en") : rs.stringForColumn("element_name_cn")
                }
            }
            
            db.close()
        }
    }*/
    
    func updateInspInfoToPhoto(_ photo:Photo) {
        /*
        DataType:
        0: Task
        1: Inspect
        2: Defect
        */
        if photo.dataType < 1{
            return
        }
        
        var sql = "SELECT ism.input_mode_code FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_section_mstr AS ism ON tidr.inspect_section_id = ism.section_id WHERE tipf.photo_id = ? AND ism.rec_status = 0 AND ism.deleted_flag = 0"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [photo.photoId!]) {
                if rs.next() {
                    let inputMode = rs.string(forColumn: "input_mode_code")
                    var inspAreaText:String?
                    var inspCatText:String?
                    var inspItemText:String?
                    
                    switch inputMode ?? "" {
                        case _INPUTMODE01:
                            sql = "SELECT ism.section_name_en,ism.section_name_cn,ism.section_name_fr,iem.element_name_en,iem.element_name_cn,iem.element_name_fr FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_section_mstr AS ism ON tidr.inspect_section_id = ism.section_id INNER JOIN inspect_element_mstr AS iem ON tidr.inspect_element_id = iem.element_id WHERE tipf.photo_id = ? AND ism.rec_status = 0 AND ism.deleted_flag = 0 AND iem.rec_status = 0 AND iem.deleted_flag = 0"
                        
                            if let rs = db.executeQuery(sql, withArgumentsIn: [photo.photoId!]) {
                                if rs.next() {
                                    inspItemText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "element_name_en"), .zh: rs.string(forColumn: "element_name_cn"), .fr: rs.string(forColumn: "element_name_fr")])
                                    inspCatText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "section_name_en"), .zh: rs.string(forColumn: "section_name_cn"), .fr: rs.string(forColumn: "section_name_fr")])
                                }
                            }
                        
                        case _INPUTMODE02:
                            sql = "SELECT ipm.position_name_en,ipm.position_name_cn,ipm.position_name_fr,ism.section_name_en,ism.section_name_cn,ism.section_name_fr FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_position_mstr AS ipm ON tidr.inspect_position_id = ipm.position_id INNER JOIN inspect_section_mstr AS ism ON tidr.inspect_section_id = ism.section_id WHERE tipf.photo_id = ? AND ism.rec_status = 0 AND ism.deleted_flag = 0 AND ipm.rec_status = 0 AND ipm.deleted_flag = 0"
                            
                            if let rs = db.executeQuery(sql, withArgumentsIn: [photo.photoId!]) {
                                if rs.next() {
                                    inspAreaText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "position_name_en"), .zh: rs.string(forColumn: "position_name_cn"), .fr: rs.string(forColumn: "position_name_fr")])
                                    inspCatText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "section_name_en"), .zh: rs.string(forColumn: "section_name_cn"), .fr: rs.string(forColumn: "section_name_fr")])
                                }
                            }
                        
                            sql = "SELECT tidr.record_id FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tipf.data_record_id = tidr.record_id WHERE tipf.photo_id = ?"
                        
                            if let rs = db.executeQuery(sql, withArgumentsIn: [photo.photoId!]) {
                                if rs.next() {
                                    let recordId = Int(rs.int(forColumn: "record_id"))
                                    let dpDataHelper = DPDataHelper()
                                    inspItemText = dpDataHelper.getDefectPositionPointsByRecordId(recordId)
                                }
                            }
                        
                        case _INPUTMODE03:
                            sql = "SELECT ism.section_name_en,ism.section_name_cn,ism.section_name_fr,tidr.request_element_desc FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_section_mstr AS ism ON tidr.request_section_id = ism.section_id WHERE tipf.photo_id = ? AND ism.rec_status = 0 AND ism.deleted_flag = 0"
                        
                            if let rs = db.executeQuery(sql, withArgumentsIn: [photo.photoId!]) {
                                if rs.next() {
                                    inspItemText = rs.string(forColumn: "request_element_desc") ?? ""
                                    inspCatText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "section_name_en"), .zh: rs.string(forColumn: "section_name_cn"), .fr: rs.string(forColumn: "section_name_fr")])
                                }
                            }
                        
                        case _INPUTMODE04:
                            sql = "SELECT iem.element_name_en,iem.element_name_cn,iem.element_name_fr,ipm.position_name_en,ipm.position_name_cn,ipm.position_name_fr,ism.section_name_en,ism.section_name_cn,ism.section_name_fr FROM task_inspect_photo_file tipf INNER JOIN task_inspect_data_record tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_element_mstr iem ON tidr.inspect_element_id = iem.element_id INNER JOIN inspect_position_mstr ipm ON tidr.inspect_position_id = ipm.position_id INNER JOIN inspect_section_mstr ism ON ism.section_id = tidr.inspect_section_id WHERE tipf.photo_id = ? AND ism.rec_status = 0 AND ism.deleted_flag = 0 AND iem.rec_status = 0 AND iem.deleted_flag = 0 AND ipm.rec_status = 0 AND ipm.deleted_flag = 0"
                            
                            if let rs = db.executeQuery(sql, withArgumentsIn: [photo.photoId!]) {
                                if rs.next() {
                                    inspAreaText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "position_name_en"), .zh: rs.string(forColumn: "position_name_cn"), .fr: rs.string(forColumn: "position_name_fr")])
                                    inspCatText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "section_name_en"), .zh: rs.string(forColumn: "section_name_cn"), .fr: rs.string(forColumn: "section_name_fr")])
                                    inspItemText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: rs.string(forColumn: "element_name_en"), .zh: rs.string(forColumn: "element_name_cn"), .fr: rs.string(forColumn: "element_name_fr")])
                                }
                            }
                        
                        default:break
                    }
                    
                    photo.inspAreaName = inspAreaText
                    photo.inspCatName = inspCatText
                    photo.inspItemName = inspItemText
                }
            }
            
            db.close()
        }
    }
    
    func existPhotoByInspItem(_ dataRecordId:Int, dataType:Int) ->Bool {
        let sql = "SELECT * FROM task_inspect_photo_file WHERE data_record_id = ? AND data_type = ?"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [dataRecordId, dataType]) {
            
                if rs.next() {
                    db.close()
                    return true
                }
            }
            
            db.close()
        }
        
        return false
    }
    
    func updatePhotoDatasByPhotoName(_ photoName:String, dataType:Int, dataRecordId:Int) ->Photo? {
        let sql = "UPDATE task_inspect_photo_file SET data_record_id = ?, data_type = ? WHERE photo_file = ?"
        var photo:Photo?
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsIn: [dataRecordId,dataType,photoName]) {
                UIView.init().alertView("Update Photo Data Error")
                db.close()
                
                return photo
            }
            
            let sql = "SELECT * FROM task_inspect_photo_file WHERE photo_file = ?"
            if let rs = db.executeQuery(sql, withArgumentsIn: [photoName]) {
                
                if rs.next() {
                    
                    let photoId = Int(rs.int(forColumn: "photo_id"))
                    let taskId = Int(rs.int(forColumn: "task_id"))
                    let refPhotoId = Int(rs.int(forColumn: "ref_photo_id"))
                    let orgFileName = rs.string(forColumn: "org_filename")
                    let photoFile = rs.string(forColumn: "photo_file")
                    let thumbFile = rs.string(forColumn: "thumb_file")
                    let photoDesc = rs.string(forColumn: "photo_desc")
                    let dataRecordId = Int(rs.int(forColumn: "data_record_id"))
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let dataType = Int(rs.int(forColumn: "data_type"))
                    
                    //Get Image
                    let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoFile!
                    let imageView = UIImageView.init(image: UIImage(contentsOfFile: pathForImage))
                    
                    photo = Photo(photo: imageView, photoFilename: photoFile!, taskId: taskId, photoFile: photoFile!)
                    
                    photo?.photoId = photoId
                    photo?.refPhotoId = refPhotoId
                    photo?.orgFileName = orgFileName
                    photo?.thumbFile = thumbFile
                    photo?.photoDesc = photoDesc
                    photo?.dataRecordId = dataRecordId
                    photo?.createUser = createUser
                    photo?.createDate = createDate
                    photo?.modifyUser = modifyUser
                    photo?.modifyDate = modifyDate
                    photo?.dataType = dataType
                    
                }
            }
            
            db.close()
        }
        
        return photo
    }

    
    func updatePhotoDatas(_ photoId:Int, dataType:Int, dataRecordId:Int) ->Photo? {
        let sql = "UPDATE task_inspect_photo_file SET data_record_id = ?, data_type = ? WHERE photo_id = ?"
        var photo:Photo?
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsIn: [dataRecordId,dataType,photoId]) {
                UIView.init().alertView("Update Photo Data Error")
                return photo
            }
            
            let sql = "SELECT * FROM task_inspect_photo_file WHERE photo_id = ?"
            if let rs = db.executeQuery(sql, withArgumentsIn: [photoId]) {
            
            if rs.next() {
                
                let photoId = Int(rs.int(forColumn: "photo_id"))
                let taskId = Int(rs.int(forColumn: "task_id"))
                let refPhotoId = Int(rs.int(forColumn: "ref_photo_id"))
                let orgFileName = rs.string(forColumn: "org_filename")
                let photoFile = rs.string(forColumn: "photo_file")
                let thumbFile = rs.string(forColumn: "thumb_file")
                let photoDesc = rs.string(forColumn: "photo_desc")
                let dataRecordId = Int(rs.int(forColumn: "data_record_id"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let dataType = Int(rs.int(forColumn: "data_type"))
                
                photo = Photo(photo: nil, photoFilename: photoFile!, taskId: taskId, photoFile: photoFile!)
                
                photo?.photoId = photoId
                photo?.refPhotoId = refPhotoId
                photo?.orgFileName = orgFileName
                photo?.thumbFile = thumbFile
                photo?.photoDesc = photoDesc
                photo?.dataRecordId = dataRecordId
                photo?.createUser = createUser
                photo?.createDate = createDate
                photo?.modifyUser = modifyUser
                photo?.modifyDate = modifyDate
                photo?.dataType = dataType
                
            }
            }
            
            db.close()
        }
        
        return photo
    }
    
    func getDefectPhotoNamesById(_ taskId:Int, dataRecordId:Int, taskPath:String) ->[String]? {
        let sql = "SELECT photo_file FROM task_inspect_photo_file WHERE task_id = ? AND data_record_id = ? AND data_type = 2"
        var photoNames = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, dataRecordId]) {
                
                while rs.next() {
                
                    let photoFile = rs.string(forColumn: "photo_file")
                
                    photoNames.append(photoFile!)
                }
            }
            
            db.close()
            
            return photoNames
        }
        
        return nil
    }
    
    func getDefectPhotosById(_ taskId:Int, dataRecordId:Int, taskPath:String) ->[Photo]? {
        let sql = "SELECT * FROM task_inspect_photo_file WHERE task_id = ? AND data_record_id = ? AND data_type = 2"
        var photos = [Photo]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId, dataRecordId]) {
            
            while rs.next() {
                
                let photoId = Int(rs.int(forColumn: "photo_id"))
                let taskId = Int(rs.int(forColumn: "task_id"))
                let refPhotoId = Int(rs.int(forColumn: "ref_photo_id"))
                let orgFileName = rs.string(forColumn: "org_filename")
                let photoFile = rs.string(forColumn: "photo_file")
                let thumbFile = rs.string(forColumn: "thumb_file")
                let photoDesc = rs.string(forColumn: "photo_desc")
                let dataRecordId = Int(rs.int(forColumn: "data_record_id"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let dataType = Int(rs.int(forColumn: "data_type"))
                
                //Get Image
                let path = taskPath+"/"+photoFile!
                let image = UIImage(contentsOfFile: path)
                
                let photo = Photo(photo: UIImageView(image:image), photoFilename: photoFile!, taskId: taskId, photoFile: photoFile!)
                
                photo?.photoId = photoId
                photo?.refPhotoId = refPhotoId
                photo?.orgFileName = orgFileName
                photo?.thumbFile = thumbFile
                photo?.photoDesc = photoDesc
                photo?.dataRecordId = dataRecordId
                photo?.createUser = createUser
                photo?.createDate = createDate
                photo?.modifyUser = modifyUser
                photo?.modifyDate = modifyDate
                photo?.dataType = dataType
                
                photos.append(photo!)
            }
            }
            
            db.close()
            
            return photos
        }
        
        return nil
    }
    
    func checkPhotoAddedByInspDataRecordId(_ dataRecordId:Int) ->Bool {
        let sql = "SELECT * FROM task_inspect_data_record AS tidr INNER JOIN task_defect_data_record AS tddr ON tidr.record_id = tddr.inspect_record_id INNER JOIN task_inspect_photo_file AS tipf ON tddr.record_id = tipf.data_record_id WHERE tidr.record_id = ? AND tipf.data_type = 2"
        
        if db.open(){
            
            //let rs = db.executeQuery(sql, withArgumentsInArray: [dataRecordId])
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [dataRecordId]) {
                
                if rs.next() {
                    db.close()
                    return true
                }
            }
        
            db.close()
        }
        
        return false
    }
    
    func deletePhotoByPhotoId(_ photoId:Int) ->Bool {
        let sql = "DELETE FROM task_inspect_photo_file WHERE photo_id = ?"
        
        if db.open(){
            
            if !db.executeUpdate(sql, withArgumentsIn: [photoId]) {
                db.close()
                return false
            }
            
            db.close()
        }
        
        return true
    }
    
    func getPhotosByInspElmtId(_ inspElmtId:Int,dataType:Int=1) ->[Photo]? {
        let sql = "SELECT * FROM task_inspect_photo_file WHERE data_record_id = ? AND data_type = ?"
        var photos = [Photo]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [inspElmtId, dataType]) {
            
            while rs.next() {
                
                let photoId = Int(rs.int(forColumn: "photo_id"))
                let taskId = Int(rs.int(forColumn: "task_id"))
                let refPhotoId = Int(rs.int(forColumn: "ref_photo_id"))
                let orgFileName = rs.string(forColumn: "org_filename")
                let photoFile = rs.string(forColumn: "photo_file")
                let thumbFile = rs.string(forColumn: "thumb_file")
                let photoDesc = rs.string(forColumn: "photo_desc")
                let dataRecordId = Int(rs.int(forColumn: "data_record_id"))
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let dataType = Int(rs.int(forColumn: "data_type"))
                
                let photo = Photo(photo: nil, photoFilename: photoFile!, taskId: taskId, photoFile: photoFile!)
                
                photo?.photoId = photoId
                photo?.refPhotoId = refPhotoId
                photo?.orgFileName = orgFileName
                photo?.thumbFile = thumbFile
                photo?.photoDesc = photoDesc
                photo?.dataRecordId = dataRecordId
                photo?.createUser = createUser
                photo?.createDate = createDate
                photo?.modifyUser = modifyUser
                photo?.modifyDate = modifyDate
                photo?.dataType = dataType
                
                photos.append(photo!)
            }
            }
            
            db.close()
            
            return photos
        }
        
        return nil
    }
    
    func getPhotoIdByPhotoName(_ photoName:String) ->Int {
        let sql = "SELECT photo_id FROM task_inspect_photo_file WHERE photo_file = ?"
        var photoId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [photoName]) {
                if rs.next() {
                    photoId = Int(rs.int(forColumn: "photo_id"))
                }
            }
            
            db.close()
        }
        
        return photoId
    }
    
    func getStylePhotoByStyleNo(_ taskId:Int) ->StylePhoto {
        
        let sql = "SELECT sp.ss_photo_name, sp.cb_photo_name FROM style_photo sp INNER JOIN fgpo_line_item fli ON sp.style_no = fli.style_no INNER JOIN inspect_task_item iti ON fli.item_id = iti.po_item_id WHERE iti.task_id = ?"
        var stylePhotos = StylePhoto(ssPhotoName: "", cbPhotoName: "")
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [taskId]) {
                if rs.next() {
                    stylePhotos = StylePhoto(ssPhotoName: rs.string(forColumn: "ss_photo_name") ?? "", cbPhotoName: rs.string(forColumn: "cb_photo_name") ?? "")
                }
            }
            
            db.close()
        }
        
        return stylePhotos
    }
    
    func selectStylePhotosToRemove() ->[String] {
        
        let sql = "SELECT ss_photo_name, cb_photo_name FROM style_photo WHERE deleted_flag = 1"
        var paths = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    
                    let path = Cache_Inspector?.typeCode == TypeCode.WATCH.rawValue ? _WATCHSSPHOTOSPHYSICALPATH : _JEWELRYSSPHOTOSPHYSICALPATH
                    paths.append(path + (rs.string(forColumn: "ss_photo_name") ?? ""))
                    paths.append(_CASEBACKPHOTOSPHYSICALPATH + (rs.string(forColumn: "cb_photo_name") ?? ""))
                }
            }
            
            db.close()
        }
        
        return paths
    }
    
    func removeStylePhotosMarkDeleted() ->Bool {
        
        let sql = "DELETE FROM style_photo WHERE deleted_flag = 1"
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsIn: []) {
                db.close()
                
                return false
            }
            
            db.close()
        }
        
        return true
    }
    
    func getTaskIdByPhotoId(_ photoId: Int) -> String {
        
        let sql = "SELECT task_id FROM task_inspect_photo_file WHERE photo_id = ?"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [photoId]) {
                if rs.next() {
                    return rs.string(forColumn: "task_id") ?? ""
                }
            }
            
            db.close()
        }
        
        return ""
    }
}
