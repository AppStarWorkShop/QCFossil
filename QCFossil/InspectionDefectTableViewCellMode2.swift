//
//  InspectionDefectTableViewCellMode2.swift
//  QCFossil
//
//  Created by pacmobile on 19/1/2017.
//  Copyright © 2017 kira. All rights reserved.
//


import UIKit
import BSImagePicker
import Photos
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


class InspectionDefectTableViewCellMode2: InputModeDFMaster2, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var defectDescLabel: UILabel!
    //@IBOutlet weak var defectDescInput: UITextField!
    @IBOutlet weak var defectCriticalQtyLabel: UILabel!
    @IBOutlet weak var defectCriticalQtyInput: NoActionTextField!
    @IBOutlet weak var defectMajorQtyLabel: UILabel!
    @IBOutlet weak var defectMajorQtyInput: NoActionTextField!
    @IBOutlet weak var defectMinorQtyLabel: UILabel!
    @IBOutlet weak var defectMinorQtyInput: NoActionTextField!
    @IBOutlet weak var defectTotalQtyLabel: UILabel!
    @IBOutlet weak var defectTotalQtyInput: UITextField!
    @IBOutlet weak var defectTypeLabel: UILabel!
    @IBOutlet weak var defectTypeInput: UITextField!
    @IBOutlet weak var defectDesc1Label: UILabel!
    @IBOutlet weak var defectDesc1Input: UITextField!
    @IBOutlet weak var defectDesc2Label: UILabel!
    @IBOutlet weak var defectDesc2Input: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var defectDesc1ListIcon: UIButton!
    @IBOutlet weak var defectDesc2ListIcon: UIButton!
    @IBOutlet weak var othersRemarkLabel: UILabel!
    @IBOutlet weak var othersRemarkInput: UITextField!
    @IBOutlet weak var defectRemarkOptionList: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var pVC:InspectionDefectList!
    
    var defectValues:[DropdownValue]?
    var caseValues:[DropdownValue]?
    var remarkKeyValue = [String:Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.defectDescInput.delegate = self
        self.defectRemarkOptionList.delegate = self
        self.defectCriticalQtyInput.delegate = self
        self.defectMajorQtyInput.delegate = self
        self.defectMinorQtyInput.delegate = self
        self.defectTotalQtyInput.delegate = self
        self.defectTypeInput.delegate = self
        self.defectDesc1Input.delegate = self
        self.defectDesc2Input.delegate = self
        self.othersRemarkInput.delegate = self
        self.defectTotalQtyInput.isUserInteractionEnabled = false
        
        self.defectDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Description")
        self.defectTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Type")
        self.defectCriticalQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Critical")
        self.defectMajorQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Major")
        self.defectMinorQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Minor")
        self.defectTotalQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Total")
        self.defectDesc1Label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Desc. 1")
        self.defectDesc2Label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Desc. 2")
        self.errorMessageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter defect quantity")
        self.othersRemarkLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Other Remark")
        
        self.activityIndicator.isHidden = true
    }
    
    @IBAction func addDefectPhoto(_ sender: UIButton) {
        print("add Cell photo")
        
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        //self.defectDescInput.resignFirstResponder()
        self.othersRemarkInput.resignFirstResponder()
        self.defectRemarkOptionList.resignFirstResponder()
        self.defectCriticalQtyInput.resignFirstResponder()
        self.defectMajorQtyInput.resignFirstResponder()
        self.defectMinorQtyInput.resignFirstResponder()
        self.defectTotalQtyInput.resignFirstResponder()
        
        let availableCount = self.photoNameAtIndex.filter({$0 == ""})
        
//        let imagePicker = ELCImagePickerController(imagePicker: ())
//        imagePicker?.maximumImagesCount = availableCount.count
//        imagePicker?.returnsOriginalImage = true
//        imagePicker?.returnsImage = true
//        imagePicker?.onOrder = true
//        
//        imagePicker?.imagePickerDelegate = self
//        self.parentVC?.present(imagePicker!, animated: true, completion: nil)
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = availableCount.count
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true

        self.parentVC?.presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
            self.setAllImages(selectedAssets: assets)
        }, completion: nil)
    }
    
    @IBAction func addDefectPhotoFromCamera(_ sender: UIButton) {
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .camera
            self.parentVC!.present(imagePicker, animated: true, completion: nil)
            
        }else{
            let availableCount = self.photoNameAtIndex.filter({$0 == ""})
            
            let imagePicker = ELCImagePickerController(imagePicker: ())
            imagePicker?.maximumImagesCount = availableCount.count
            imagePicker?.returnsOriginalImage = true
            imagePicker?.returnsImage = true
            imagePicker?.onOrder = true
            
            imagePicker?.imagePickerDelegate = self
            self.parentVC?.present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func setAllImages(selectedAssets: [PHAsset]) -> Void {
        if selectedAssets.count != 0{
            var photos = [Photo]()
            for i in 0..<selectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var image = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: _RESIZEIMAGEWIDTH, height: _RESIZEIMAGEHEIGHT), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    image = result!
                })
                
                let imageView = UIImageView.init(image: image)
                if let photo = Photo(photo: imageView, photoFilename: "", taskId: (Cache_Task_On?.taskId)!, photoFile: "") {
                    photos.append(photo)
                }
            }
            
            updateInspItemPhotoStatus(photos: photos)
        }
    }
    
    /**
     * Called with the picker the images were selected from, as well as an array of dictionary's
     * containing keys for ALAssetPropertyLocation, ALAssetPropertyType,
     * UIImagePickerControllerOriginalImage, and UIImagePickerControllerReferenceURL.
     * @param picker
     * @param info An NSArray containing dictionary's with the key UIImagePickerControllerOriginalImage, which is a rotated, and sized for the screen 'default representation' of the image selected. If you want to get the original image, use the UIImagePickerControllerReferenceURL key.
     */
    func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
        var photos = [Photo]()
        for object in info {
            
            if let dictionary = object as? NSDictionary {
                
                if let image = dictionary.object(forKey: convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)) as? UIImage {
                    
                    let imageView = UIImageView.init(image: image)
                    
                    if let photo = Photo(photo: imageView, photoFilename: "", taskId: (Cache_Task_On?.taskId)!, photoFile: "") {
                        
                        photos.append(photo)
                        
                    }
                }
            }
        }
        
        updateInspItemPhotoStatus(photos: photos)
    }
    
    func updateInspItemPhotoStatus(photos: [Photo]) {
        let defectItem = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        
        //Update InspItem PhotoAdded Status
        self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "yes"))
        self.updatePhotoAddedStatus("yes")
        
        self.parentVC?.dismiss(animated: true, completion: {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            DispatchQueue.main.async(execute: {
                let photoNames = self.getNamesBySaveDefectPhotos(photos)
                if defectItem?.count > 0 {
                    let defectCell = (defectItem![0] as TaskInspDefectDataRecord)
                    
                    if defectCell.photoNames == nil {
                        defectCell.photoNames = [String]()
                    }
                    
                    photoNames.forEach({
                        defectCell.photoNames?.append(String($0))
                    })
                    
                }
                
                photos.forEach({
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadPhotos"), object: nil, userInfo: ["photoSelected":$0])
                })
                
                self.pVC?.updateContentView()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        })
    }
    
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
        self.parentVC?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDefectPhotoFromAlbum(_ sender: UIButton) {
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.pVC?.currentCell = self
        self.parentVC?.performSegue(withIdentifier: "PhotoAlbumSegueFromIDF", sender: self)
    }
    
    func refreshImageviews() {
        self.subviews.forEach({ if $0.tag>0 {$0.removeFromSuperview()} })
        self.photoNameAtIndex = ["","","","",""]
    }
    
    func showDefectPhotoByName(_ photoNames:[String]) {
        var idx = 0
        for photoName in photoNames {
            
            if idx < 5 && photoName != "" {
                
                let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName
                let imageView = UIImageView.init(image: UIImage(contentsOfFile: pathForImage))
                
                imageView.frame = CGRect(x: xPos[idx], y: 265, width: 40, height: 40)
                imageView.tag = idx + 1
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(previewTapOnClick))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGestureRecognizer)
                
                photoNameAtIndex[idx] = photoName
                
                self.addSubview(imageView)
                
                let cBtn = CustomControlButton()
                cBtn.frame = CGRect.init(x: xPosBtn[idx], y: 255, width: 20, height: 20)
                cBtn.addTarget(self, action: #selector(removeDefectPhotoOnIndex), for: UIControl.Event.touchUpInside)
                cBtn.tag = idx + 1
                cBtn.setTitle("-", for: UIControl.State())
                cBtn.backgroundColor = UIColor.red
                cBtn.layer.cornerRadius = _CORNERRADIUS
                
                self.addSubview(cBtn)
                
                idx += 1
            }
        }
    }
    
    func showDefectPhoto(_ photos:[Photo]){
        
        var idx = 0
        for photo in photos {
            
            if idx < 5 {
                
                let imageView = photo.photo
                
                imageView?.frame = CGRect(x: xPos[idx], y: 35, width: 40, height: 40)
                imageView?.tag = idx + 1
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(previewTapOnClick))
                imageView?.isUserInteractionEnabled = true
                imageView?.addGestureRecognizer(tapGestureRecognizer)
                
                photoNameAtIndex[idx] = photo.photoFile
                
                self.addSubview(imageView!)
                
                let cBtn = CustomButton()
                cBtn.frame = CGRect.init(x: xPosBtn[idx], y: 27, width: 15, height: 15)
                cBtn.addTarget(self, action: #selector(removeDefectPhotoOnIndex), for: UIControl.Event.touchUpInside)
                cBtn.tag = idx + 1
                cBtn.setTitle("-", for: UIControl.State())
                cBtn.backgroundColor = UIColor.red
                cBtn.layer.cornerRadius = _CORNERRADIUS
                
                self.addSubview(cBtn)
                
                idx += 1
            }
        }
    }
    
    @objc func removeDefectPhotoOnIndex(_ sender: CustomButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Photo?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            let defectsByItemId = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            if defectsByItemId?.count>0 {
                let defectCell = defectsByItemId![0]
                
                self.clearDefectPhotoDataByPhotoName(defectCell.photoNames![sender.tag-1])
                defectCell.photoNames?.remove(at: sender.tag-1)
                self.photoNameAtIndex.remove(at: sender.tag-1)
            }
            
            let selfPhotoAdded = defectsByItemId!.filter({$0.photoNames?.count > 0})
            
            if selfPhotoAdded.count<1 {
                self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "no"))
            }
            
            let defectsByItemIdFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && self.cellIdx>=0})
            let ifPhotoAdded = defectsByItemIdFilter!.filter({$0.photoNames?.count > 0})
            
            if ifPhotoAdded.count<1 {
                self.updatePhotoAddedStatus("no")
            }
            
            self.pVC?.updateContentView()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        NSLog("Image Pick")
        
        picker.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if !self.photoNameAtIndex.contains("") {
                    self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
                    return
                }
                
                let imageView = UIImageView.init(image: image)
                
                let photo = Photo(photo: imageView, photoFilename: "", taskId: (Cache_Task_On?.taskId)!, photoFile: "")
                
                let photoName = self.getNameBySaveDefectPhotoData(0, photo: photo!)
                
                let defectItem = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
                if defectItem?.count > 0 {
                    let defectCell = (defectItem![0] as TaskInspDefectDataRecord)
                    
                    if defectCell.photoNames == nil {
                        defectCell.photoNames = [String]()
                    }
                    
                    if defectCell.photoNames!.count<=5 {
                        defectCell.photoNames!.append(photoName)
                    }
                }
                
                //Update InspItem PhotoAdded Status
                self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "yes"))
                self.updatePhotoAddedStatus("yes")
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadPhotos"), object: nil, userInfo: ["photoSelected":photo!])
                
                self.pVC?.updateContentView()
            }
        })
    }
    
    func saveDefectPhotoData(_ index:Int, photo:Photo, needSave:Bool=true) ->Photo {
        
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
        
        //Save Photo to Local
        return UIImage.init().saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode2")
    }
    
    func getNameBySaveDefectPhotoData(_ index:Int, photo:Photo, needSave:Bool=true) ->String {
        
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
        
        //Save Photo to Local
        return UIImage.init().getNameBySaveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode2")
    }
    
    func getNamesBySaveDefectPhotos(_ photos:[Photo], needSave:Bool=true) ->[String] {
        
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
        
        //Save Photo to Local
        return UIImage.init().getNamesBySaveImageToLocal(photos, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode2")
    }
    
    func updatePhotoAddedStatus(_ newStatus:String) {
        if newStatus == "yes" {
            (self.inspItem as! InputMode02CellView).photoAdded = true
        }else{
            (self.inspItem as! InputMode02CellView).photoAdded = false
        }
        
        (self.inspItem as! InputMode02CellView).updatePhotoAddediConStatus("",photoTakenIcon: (self.inspItem as! InputMode02CellView).photoAddedIcon)
    }
    
    @objc func previewTapOnClick(_ sender: UITapGestureRecognizer) {
        if (sender.view as! UIImageView).image != nil {
            let imageView = sender.view as! UIImageView
            
            if imageView.tag-1 >= 0 && imageView.tag-1 < self.photos.count {
                imageView.previewImage(imageView.tag-1,imageName:self.photoNameAtIndex[imageView.tag-1],senderImageView: imageView, parentItem: self)
            }
        }
    }
    
    @IBAction func removeDefectCell(_ sender: UIButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Defect Item?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "no"))
            self.removeDefectCell()
            
            let defectsByItemIdFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && self.cellIdx>=0})
            let ifPhotoAdded = defectsByItemIdFilter!.filter({$0.photoNames?.count > 0})
            
            if ifPhotoAdded.count<1 {
                self.updatePhotoAddedStatus("no")
            }
        })
    }
    
    override func removeDefectCell() {
        
        let defectCellFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        if defectCellFilter?.count > 0 {
            let defectCell = defectCellFilter![0] as TaskInspDefectDataRecord
            
            if defectCell.photoNames != nil && defectCell.photoNames?.count>0 {
                for idx in 0...(defectCell.photoNames?.count)!-1 {
                    clearDefectPhotoDataAtIndex(idx)
                }
            }
            
            let index = Cache_Task_On?.defectItems.index(where: {$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            Cache_Task_On?.defectItems.remove(at: index!)
            
            //Delete Record From DB
            if self.taskDefectDataRecordId > 0 {
                self.deleteTaskInspDefectDataRecord(self.taskDefectDataRecordId!)
            }
            
            self.pVC?.updateContentView()
            
            //Update Photo Album
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.defectTypeInput {
            let defectDataHelper = DefectDataHelper()
            /*
             Element Type
             1: Inspect Item
             2: Defect Item
             */
            
            if let parentCellView = self.inspItem as? InputMode02CellView {
                let positionIds = parentCellView.myDefectPositPoints
                let positionIdArray = positionIds.map({ position in
                    return "\(position.positionId)"
                })
                
                let dfElms = defectDataHelper.getDefectTypeElms(positionIdArray)
                if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                    clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
                } else {
                    textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms) as NSArray, height:_DROPDOWNLISTHEIGHT, tag: _TAG1)
                }
                
            } else {
                
                guard let id = self.taskDefectDataRecordId else {return false}
                let dfElms = defectDataHelper.getDefectTypeByTaskDefectDataRecordId(id)
                
                if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                    clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
                } else {
                    textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms) as NSArray, height:_DROPDOWNLISTHEIGHT, tag: _TAG1)
                }
                
            }
            
            return false
        } else if textField == self.defectDesc1Input {
            
            //self.defectValues = ZoneDataHelper.sharedInstance.getDefectValuesByElementId(self.inspectElementId ?? 0)
            var listData = [String]()
            
            self.defectValues?.forEach({ value in
                listData.append(MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: value.valueNameEn, .zh: value.valueNameCn, .fr: value.valueNameFr]))
            })
            
            if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
            } else {
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData) as NSArray, height:_DROPDOWNLISTHEIGHT, tag: _TAG1)
            }
            

            return false
        } else if textField == self.defectDesc2Input {
            
            //self.caseValues = ZoneDataHelper.sharedInstance.getCaseValuesByElementId(self.inspectElementId ?? 0)
            var listData = [String]()
            
            self.caseValues?.forEach({ value in
                listData.append(MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: value.valueNameEn, .zh: value.valueNameCn, .fr: value.valueNameFr]))
            })
            
            if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
            } else {
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData) as NSArray, height:_DROPDOWNLISTHEIGHT, tag: _TAG1)
            }
            

            return false
        } else if textField == self.defectMajorQtyInput || textField == self.defectMinorQtyInput || textField == self.defectCriticalQtyInput {
            
            if textField.text == "0" {
                textField.text = ""
            }
            
        } else if textField == self.defectRemarkOptionList {
            var listData = [String]()
            for key in self.remarkKeyValue.keys {
                listData.append(key)
            }
            
            if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
            } else {
                
                var intArray = [Int]()
                if let items = self.defectRemarksOptionList {
                    let selectedValues = items.characters.split{$0 == ","}.map(String.init)
                    selectedValues.forEach({
                        if let v = Int($0) {
                            intArray.append(v)
                        }
                    })
                }
                
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData) as NSArray, height:_DROPDOWNLISTHEIGHT, allowMulpSel: true, tag: _TAG1, keyValues: self.remarkKeyValue, selectedValues: intArray ?? [])
            }
            
            return false
        }
        
        return true
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.defectMajorQtyInput || textField == self.defectMinorQtyInput || textField == self.defectCriticalQtyInput {
            if textField.text == "" {
                textField.text = "0"
            }
            
            if var inputValue = textField.text {
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            
            if textField.keyboardType == UIKeyboardType.numberPad {
                if defectItemFilter?.count>0 {
                    let defectItem = defectItemFilter![0]
                    
                    if Int(inputValue) == nil {
                        inputValue = "0"
                    }
                    
                    if textField == self.defectCriticalQtyInput {
                        defectItem.defectQtyCritical = Int(inputValue)!
                        
                    }else if textField == self.defectMajorQtyInput {
                        defectItem.defectQtyMajor = Int(inputValue)!
                        
                    }else if textField == self.defectMinorQtyInput {
                        defectItem.defectQtyMinor = Int(inputValue)!
                        
                    }
                    
                    defectItem.defectQtyTotal = Int(defectItem.defectQtyCritical + defectItem.defectQtyMajor + defectItem.defectQtyMinor)
                    self.defectTotalQtyInput.text = String(defectItem.defectQtyTotal)
                }
            }
            }
            
            
        } else if textField === self.othersRemarkInput {
            
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx}).first
            guard let defectItem = defectItemFilter else {return}
            
            defectItem.othersRemark = textField.text
            
        }
    }
    
    func dropdownHandleFunc(_ textField:UITextField) {
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx}).first
        guard let defectItem = defectItemFilter else {return}
        
        if textField == self.defectTypeInput {
            
            let defectDataHelper = DefectDataHelper()
            let inspectElementId = defectDataHelper.getInspElementIdByName(textField.text ?? "")
            defectItem.inspectElementId = inspectElementId
            self.inspectElementId = inspectElementId
            defectItem.defectType = textField.text ?? ""
            
            self.defectDesc1Input.text = ""
            self.defectDesc2Input.text = ""
            defectItem.inspectElementDefectValueId = 0
            defectItem.inspectElementCaseValueId = 0
            
            let zoneDataHelper = ZoneDataHelper()
            self.defectValues = zoneDataHelper.getDefectValuesByElementId(defectItem.inspectElementId ?? 0)
            self.caseValues = zoneDataHelper.getCaseValuesByElementId(defectItem.inspectElementId ?? 0)
            
            if defectValues?.count < 1 {
                self.defectDesc1Input.backgroundColor = _GREY_BACKGROUD
                self.defectDesc1ListIcon.isHidden = true

            } else {
                self.defectDesc1Input.backgroundColor = UIColor.white
                self.defectDesc1ListIcon.isHidden = false

            }
            
            if caseValues?.count < 1 {
                self.defectDesc2Input.backgroundColor = _GREY_BACKGROUD
                self.defectDesc2ListIcon.isHidden = true
            } else {
                self.defectDesc2Input.backgroundColor = UIColor.white
                self.defectDesc2ListIcon.isHidden = false
            }
            
        } else if textField == self.defectDesc1Input {
            
            guard let defectValueName = self.defectDesc1Input.text else {return}
            guard let defectValues = self.defectValues else {return}
            
            defectValues.forEach({ selectedObject in
                if selectedObject.valueNameEn == defectValueName || selectedObject.valueNameCn == defectValueName {
                    self.inspectElementDefectValueId = selectedObject.valueId
                    defectItem.inspectElementDefectValueId = selectedObject.valueId
                }
            })
            
        } else if textField == self.defectDesc2Input {
            
            guard let caseValueName = self.defectDesc2Input.text else {return}
            guard let caseValues = self.caseValues else {return}
            
            caseValues.forEach({ selectedObject in
                if selectedObject.valueNameEn == caseValueName || selectedObject.valueNameCn == caseValueName {
                    self.inspectElementCaseValueId = selectedObject.valueId
                    defectItem.inspectElementCaseValueId = selectedObject.valueId
                }
            })
            
        } else if textField == self.defectRemarkOptionList {
//            defectItem.defectRemarksOptionList = self.defectRemarkOptionList.text
            
            defectItem.defectRemarksOptionList = textField.showMultiDropdownValues(self.defectRemarksOptionList ?? "", textField: textField, keyValues: self.remarkKeyValue)
            self.defectRemarksOptionList = defectItem.defectRemarksOptionList
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        Cache_Task_On?.didModify = true
        
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        
        if textField.keyboardType == UIKeyboardType.numberPad {
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                
                if textField == self.defectCriticalQtyInput {
                    defectItem.defectQtyCritical = 0
                    
                }else if textField == self.defectMajorQtyInput {
                    defectItem.defectQtyMajor = 0
                    
                }else if textField == self.defectMinorQtyInput {
                    defectItem.defectQtyMinor = 0
                    
                }
                
                defectItem.defectQtyTotal = Int(defectItem.defectQtyCritical + defectItem.defectQtyMajor + defectItem.defectQtyMinor)
                self.defectTotalQtyInput.text = String(defectItem.defectQtyTotal)
            }
        }
        
        return true
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Cache_Task_On?.didModify = true
        
        if textField == self.defectMinorQtyInput || textField == self.defectCriticalQtyInput || textField == self.defectMajorQtyInput {
            return textField.numberOnlyCheck(textField, sourceText: string)
        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        self.pVC.view.clearDropdownviewForSubviews((self.pVC?.view)!)
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
