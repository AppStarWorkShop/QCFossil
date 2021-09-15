//
//  DefectListTableViewCell.swift
//  QCFossil
//
//  Created by Yin Huang on 14/10/16.
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


class DefectListTableViewCell: InputModeDFMaster2, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var iaLabel: UILabel!
    @IBOutlet weak var iaInput: UITextField!
    @IBOutlet weak var iiLabel: UILabel!
    @IBOutlet weak var iiInput: UITextField!
    @IBOutlet weak var dfDescLabel: UILabel!
    @IBOutlet weak var dfDescInput: UITextField!
    @IBOutlet weak var dfQtyLabel: UILabel!
    @IBOutlet weak var dfQtyInput: UITextField!
    @IBOutlet weak var addDescButton: UIButton!
    @IBOutlet weak var dismissDescButton: UIButton!
    @IBOutlet weak var defectPhoto1: UIImageView!
    @IBOutlet weak var defectPhoto2: UIImageView!
    @IBOutlet weak var defectPhoto3: UIImageView!
    @IBOutlet weak var defectPhoto4: UIImageView!
    @IBOutlet weak var defectPhoto5: UIImageView!
    @IBOutlet weak var dismissPhotoButton1: CustomControlButton!
    @IBOutlet weak var dismissPhotoButton2: CustomControlButton!
    @IBOutlet weak var dismissPhotoButton3: CustomControlButton!
    @IBOutlet weak var dismissPhotoButton4: CustomControlButton!
    @IBOutlet weak var dismissPhotoButton5: CustomControlButton!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var addDefectPhotoButton: CustomControlButton!
    @IBOutlet weak var addDefectPhotoByCamera: CustomControlButton!
    @IBOutlet weak var addDefectPhotoByAlbum: CustomControlButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var pVC:DefectListViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        defectPhoto1.image = nil
        defectPhoto2.image = nil
        defectPhoto3.image = nil
        defectPhoto4.image = nil
        defectPhoto5.image = nil
        
        dismissPhotoButton1.isHidden = true
        dismissPhotoButton2.isHidden = true
        dismissPhotoButton3.isHidden = true
        dismissPhotoButton4.isHidden = true
        dismissPhotoButton5.isHidden = true
        
        self.dfQtyInput.delegate = self
        self.dfDescInput.delegate = self
        
        self.activityIndicator.isHidden = true
        //imagePicker.delegate = self
        
        updateLocalizedString()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewTapOnClick))
        defectPhoto1.addGestureRecognizer(tap)
        defectPhoto1.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(previewTapOnClick))
        defectPhoto2.addGestureRecognizer(tap2)
        defectPhoto2.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(previewTapOnClick))
        defectPhoto3.addGestureRecognizer(tap3)
        defectPhoto3.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(previewTapOnClick))
        defectPhoto4.addGestureRecognizer(tap4)
        defectPhoto4.isUserInteractionEnabled = true
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(previewTapOnClick))
        defectPhoto5.addGestureRecognizer(tap5)
        defectPhoto5.isUserInteractionEnabled = true
        
    }
    
    override func didMoveToSuperview() {
        
    }
    
    func updateLocalizedString(){
        self.iaLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Area")
        self.iiLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Item")
        self.dfDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Description")
        self.dfQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Qty")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /**
     * Called with the picker the images were selected from, as well as an array of dictionary's
     * containing keys for ALAssetPropertyLocation, ALAssetPropertyType,
     * UIImagePickerControllerOriginalImage, and UIImagePickerControllerReferenceURL.
     * @param picker
     * @param info An NSArray containing dictionary's with the key UIImagePickerControllerOriginalImage, which is a rotated, and sized for the screen 'default representation' of the image selected. If you want to get the original image, use the UIImagePickerControllerReferenceURL key.
     */
    func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
        let defectItem = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
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
        
        //Update InspItem PhotoAdded Status
        self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "yes"))
        self.updatePhotoAddedStatus("yes")
        
        self.parentVC?.dismiss(animated: true, completion: {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let photoNames = self.getNamesBySaveDefectPhotos(photos)
                
                DispatchQueue.main.async(execute: {
                    
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
            }
        })
    }
    
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
        self.parentVC?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDefectPhotoButton(_ sender: CustomButton) {
        print("add Cell photo")
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if self.defectPhoto1.image != nil && self.defectPhoto2.image != nil && self.defectPhoto3.image != nil && self.defectPhoto4.image != nil && self.defectPhoto5.image != nil {
            
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.dfDescInput.resignFirstResponder()
        self.dfQtyInput.resignFirstResponder()
        
        let availableCount = self.photoNameAtIndex.filter({$0 == ""})
        
        let imagePicker = ELCImagePickerController(imagePicker: ())
        imagePicker?.maximumImagesCount = availableCount.count
        imagePicker?.returnsOriginalImage = true
        imagePicker?.returnsImage = true
        imagePicker?.onOrder = true
//        imagePicker.title1 = MylocalizedString.sharedLocalizeManager.getLocalizedString("Only x photos please!")
//        imagePicker.detailTitle = MylocalizedString.sharedLocalizeManager.getLocalizedString("You can only send 5 photos at a time.")
//        imagePicker.okButtonTittle = MylocalizedString.sharedLocalizeManager.getLocalizedString("Okay")
//        imagePicker.title2 = MylocalizedString.sharedLocalizeManager.getLocalizedString("Select an Album")
//        imagePicker.title3 = MylocalizedString.sharedLocalizeManager.getLocalizedString("Pick Photos")
        
        imagePicker?.imagePickerDelegate = self
        self.parentVC?.present(imagePicker!, animated: true, completion: nil)
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
            self.pVC?.present(imagePicker, animated: true, completion: nil)
            
        }else{
            let availableCount = self.photoNameAtIndex.filter({$0 == ""})
            
            let imagePicker = ELCImagePickerController(imagePicker: ())
            imagePicker?.maximumImagesCount = availableCount.count
            imagePicker?.returnsOriginalImage = true
            imagePicker?.returnsImage = true
            imagePicker?.onOrder = true
            
            imagePicker?.imagePickerDelegate = self
            self.pVC?.present(imagePicker!, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func addDefectPhotoFromAlbum(_ sender: UIButton) {
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.pVC?.currentCell = self
        self.parentVC?.performSegue(withIdentifier: "PhotoAlbumSegueFromDF", sender: self)
    }
    
    @IBAction func dismissDfPhotoButton(_ sender: CustomButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Photo?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            let defectsByItemId = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            
            if defectsByItemId?.count>0 {
                let defectCell = defectsByItemId![0]
                
                self.clearDefectPhotoDataByPhotoName(defectCell.photoNames![sender.tag-1])
                defectCell.photoNames?.remove(at: sender.tag-1)
                self.photoNameAtIndex[sender.tag-1] = ""
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
    
    @IBAction func addDefectCellButton(_ sender: UIButton) {
        print("add cell")
        
        if self.iaInput.text == "" || self.iiInput.text == "" {
            self.alertView("Please select the Inspect Area & Inspect Item!")
            return
        }
        
        let defectsByItemId = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId})
        self.pVC!.addDefectCellWithSection(_INPUTMODE04, idxLabel: "\(self.itemId).\((defectsByItemId?.count)!)",iaLabel: iaInput.text!,iiLabel: iiInput.text!,sectionId: sectionId, itemId: itemId, inspItem: inspItem!, cellIdx: (defectsByItemId?.count)!)
    }
    
    @IBAction func dismissDefectCellButton(_ sender: UIButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Defect Item?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "no"))
            
            let defectsByItemIdFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && self.cellIdx>=0})
            let ifPhotoAdded = defectsByItemIdFilter!.filter({$0.photoNames?.count > 0})
            
            if ifPhotoAdded.count<1 {
                self.updatePhotoAddedStatus("no")
            }
            
            self.removeDefectCell()
            
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pVC!.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        NSLog("Image Pick")
        
        picker.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
                
                self.pVC!.updateContentView()
            }
        })
    }
    
    override func setSelectedPhoto(_ photo:Photo, needSave:Bool=true) {
        
        if defectPhoto1.image == nil {
            let resizePhoto = updateDefectPhotoData(0, photo: photo, needSave: needSave)
            defectPhoto1.image = resizePhoto!.photo?.image
            dismissPhotoButton1.isHidden = false
            
        }else if defectPhoto2.image == nil {
            let resizePhoto = updateDefectPhotoData(1, photo: photo, needSave: needSave)
            defectPhoto2.image = resizePhoto!.photo?.image
            dismissPhotoButton2.isHidden = false
            
        }else if defectPhoto3.image == nil {
            let resizePhoto = updateDefectPhotoData(2, photo: photo, needSave: needSave)
            defectPhoto3.image = resizePhoto!.photo?.image
            dismissPhotoButton3.isHidden = false
            
        }else if defectPhoto4.image == nil {
            let resizePhoto = updateDefectPhotoData(3, photo: photo, needSave: needSave)
            defectPhoto4.image = resizePhoto!.photo?.image
            dismissPhotoButton4.isHidden = false
            
        }else if defectPhoto5.image == nil {
            let resizePhoto = updateDefectPhotoData(4, photo: photo, needSave: needSave)
            defectPhoto5.image = resizePhoto!.photo?.image
            dismissPhotoButton5.isHidden = false
            
        }
        
        //Update InspItem PhotoAdded Status
        self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "yes"))
        updatePhotoAddedStatus("yes")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadPhotos"), object: nil, userInfo: ["photoSelected":photo])
        
        //
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
        return UIImage.init().saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "test")
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
        return UIImage.init().getNameBySaveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "test")
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
        return UIImage.init().getNamesBySaveImageToLocal(photos, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode1")
    }
    
    override func updateDefectPhotoData(_ index:Int, photo:Photo, needSave:Bool=true) ->Photo? {
            
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
            return savePhotoToLocal(photo)
                
        }else{
            return photo
                
        }
    }
    
    func updatePhotoAddedStatus(_ newStatus:String) {
        if self.inspItem != nil {
            if newStatus == "yes" {
                (self.inspItem as! InputMode04CellView).photoAdded = true
            }else{
                (self.inspItem as! InputMode04CellView).photoAdded = false
            }
        
            (self.inspItem as! InputMode04CellView).updatePhotoAddediConStatus("",photoTakenIcon: (self.inspItem as! InputMode04CellView).photoAddedIcon)
        }
    }
    
    @objc func closePreviewLayer() {
        let maskView = self.parentVC?.parent!.view.viewWithTag(_MASKVIEWTAG)
        maskView?.removeFromSuperview()
    }
    
    @objc func previewTapOnClick(_ sender: UITapGestureRecognizer) {
        if (sender.view as! UIImageView).image != nil {
            let imageView = sender.view as! UIImageView
            
            if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue) {
                let container:UIView = UIView()
                container.tag = _MASKVIEWTAG
                container.isHidden = false
                container.frame = (self.parentVC?.parent!.view.frame)!
                container.center = (self.parentVC?.parent!.view.center)!
                container.backgroundColor = UIColor.clear
                
                let layer = UIView()
                layer.frame = (self.parentVC?.parent!.view.frame)!
                layer.center = (self.parentVC?.parent!.view.center)!
                layer.backgroundColor = UIColor.black
                layer.alpha = 0.7
                container.addSubview(layer)
                
                let image = UIImage(contentsOfFile: Cache_Task_Path!+"/"+self.photoNameAtIndex[imageView.tag-1])
                let imageView = UIImageView(image:image)
                
                imageView.frame = CGRect(x: 0,y: 0,width: 600,height: 800)
                imageView.center = (self.parentVC?.parent!.view.center)!
                
                container.addSubview(imageView)
                
                let button = UIButton(type: UIButton.ButtonType.system) as UIButton
                button.frame = (self.parentVC?.parent!.view.frame)!
                button.backgroundColor = UIColor.clear
                button.titleLabel!.font = UIFont(name: "", size: 20)
                button.setTitleColor(UIColor.white, for: UIControl.State())
                button.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Tap Anywhere To Close"), for: UIControl.State())
                button.contentEdgeInsets = UIEdgeInsets.init(top: 400 + (self.parentVC?.parent!.view.center.y)!-30, left: 0, bottom: 0, right: 0);
                button.addTarget(self, action: #selector(DefectListTableViewCell.closePreviewLayer), for: UIControl.Event.touchUpInside)
                
                container.addSubview(button)
                
                self.parentVC?.parent!.view.addSubview(container)
            
            }else if imageView.tag-1 >= 0 && imageView.tag-1 < self.photos.count {
                imageView.previewImage(imageView.tag-1,imageName:self.photoNameAtIndex[imageView.tag-1],senderImageView: imageView, parentItem: self)
            }
        }
    }
    
    func saveDefectPhotos() {
        if defectPhoto1.image != nil {
            savePhotoToLocal(self.photos[0]!)
        }
        
        if defectPhoto2.image != nil {
            savePhotoToLocal(self.photos[1]!)
        }
        
        if defectPhoto3.image != nil {
            savePhotoToLocal(self.photos[2]!)
        }
        
        if defectPhoto4.image != nil {
            savePhotoToLocal(self.photos[3]!)
        }
        
        if defectPhoto5.image != nil {
            savePhotoToLocal(self.photos[4]!)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
