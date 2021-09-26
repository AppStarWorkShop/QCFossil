//
//  DefectListTableViewCellMode2.swift
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


class DefectListTableViewCellMode2: InputModeDFMaster2, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var indexInput: UILabel!
    @IBOutlet weak var dpLabel: UILabel!
    @IBOutlet weak var dpInput: UITextField!
    @IBOutlet weak var dppLabel: UILabel!
    @IBOutlet weak var dppInput: UITextField!
    @IBOutlet weak var dtLabel: UILabel!
    @IBOutlet weak var dtInput: UITextField!
    @IBOutlet weak var dfDescLabel: UILabel!
    @IBOutlet weak var dfDescInput: UITextField!
    @IBOutlet weak var criticalLabel: UILabel!
    @IBOutlet weak var criticalInput: UITextField!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var majorInput: UITextField!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var minorInput: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalInput: UITextField!
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
    @IBOutlet weak var addDefectPhotoButton: CustomControlButton!
    @IBOutlet weak var addDefectPhotoByCamera: CustomControlButton!
    @IBOutlet weak var addDefectPhotoByAlbum: CustomControlButton!
    @IBOutlet weak var sectionName: UILabel!
    
    @IBOutlet weak var defectDesc1Label: UILabel!
    @IBOutlet weak var defectDesc1Input: UITextField!
    @IBOutlet weak var defectDesc2Label: UILabel!
    @IBOutlet weak var defectDesc2Input: UITextField!
    
    @IBOutlet weak var otherRemarkLabel: UILabel!
    @IBOutlet weak var otherRemarkInput: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var pVC:DefectListViewController!

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
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
        
        self.dtInput.delegate = self
        self.criticalInput.delegate = self
        self.minorInput.delegate = self
        self.majorInput.delegate = self
        self.totalInput.delegate = self
        self.dfDescInput.delegate = self
        
        self.dtInput.isUserInteractionEnabled = false
        self.criticalInput.isUserInteractionEnabled = false
        self.minorInput.isUserInteractionEnabled = false
        self.majorInput.isUserInteractionEnabled = false
        self.totalInput.isUserInteractionEnabled = false
        self.dfDescInput.isUserInteractionEnabled = false
        self.defectDesc1Input.isUserInteractionEnabled = false
        self.defectDesc2Input.isUserInteractionEnabled = false
        self.otherRemarkInput.isUserInteractionEnabled = false
        
        self.activityIndicator.isHidden = true
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
    
    func updateLocalizedString(){
        self.dpLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position")
        self.dppLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Point(s)")
        self.dtLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Type")
        self.dfDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Description")
        self.criticalLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Critical")
        self.majorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Major")
        self.minorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Minor")
        self.totalLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Total")
        self.otherRemarkLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Other Remark")
        self.defectDesc1Label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Desc. 1")
        self.defectDesc2Label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Desc. 2")
        
        self.criticalInput.text = "0"
        self.majorInput.text = "0"
        self.minorInput.text = "0"
        self.totalInput.text = "0"
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
                button.addTarget(self, action: #selector(closePreviewLayer), for: UIControl.Event.touchUpInside)
                
                container.addSubview(button)
                
                self.parentVC?.parent!.view.addSubview(container)
                
            }else if imageView.tag-1 >= 0 && imageView.tag-1 < self.photos.count {
                imageView.previewImage(imageView.tag-1,imageName:self.photoNameAtIndex[imageView.tag-1],senderImageView: imageView, parentItem: self)
            }
        }
    }
    
    func updatePhotoAddedStatus(_ newStatus:String) {
        guard let inspeItem = self.inspItem as? InputMode02CellView else {return}
        
        if newStatus == "yes" {
            inspeItem.photoAdded = true
        }else{
            inspeItem.photoAdded = false
        }
            
        inspeItem.updatePhotoAddediConStatus("",photoTakenIcon: inspeItem.photoAddedIcon)
        
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
    
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
        self.parentVC?.dismiss(animated: true, completion: nil)
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
        return UIImage.init().saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileName")
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
        return UIImage.init().getNameBySaveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileName")
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
    
    override func updateDefectPhotoData(_ index:Int, photo:Photo, needSave:Bool=true) ->Photo? {
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
                self.photos[index] = savePhotoToLocal(photo)
                
            }else{
                self.photos[index] =  photo
            }
            
            return self.photos[index]
        }
        
        return nil
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
    
    @IBAction func dismissDfPhotoButton(_ sender: CustomControlButton) {
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
    
    @IBAction func addDefectPhotoButton(_ sender: CustomControlButton) {
        print("add Cell photo")
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if self.defectPhoto1.image != nil && self.defectPhoto2.image != nil && self.defectPhoto3.image != nil && self.defectPhoto4.image != nil && self.defectPhoto5.image != nil {
            
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.dpInput.resignFirstResponder()
        self.dppInput.resignFirstResponder()
        self.dtInput.resignFirstResponder()
        self.dfDescInput.resignFirstResponder()
        self.criticalInput.resignFirstResponder()
        self.majorInput.resignFirstResponder()
        self.minorInput.resignFirstResponder()
        self.totalInput.resignFirstResponder()
        
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
    
    func updateInspItemPhotoStatus(photos: [Photo]) {
        let defectItem = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        
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
    
    
    @IBAction func addDefectPhotoFromCamera(_ sender: CustomControlButton) {
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
    
    @IBAction func addDefectPhotoFromAlbum(_ sender: CustomControlButton) {
        NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.pVC?.currentCell = self
        self.parentVC?.performSegue(withIdentifier: "PhotoAlbumSegueFromDF", sender: self)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.dtInput {
            if self.ifExistingSubviewByViewTag(self.pVC.defectTableView, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.defectTableView)
                return false
            }
            
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
                textField.showListData(textField, parent: self.pVC.defectTableView, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms) as NSArray, height: 500, tag: _TAG1)

            } else {
                
                guard let id = self.taskDefectDataRecordId else {return false}
                let dfElms = defectDataHelper.getDefectTypeByTaskDefectDataRecordId(id)
                textField.showListData(textField, parent: self.pVC.defectTableView, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms) as NSArray, height: 500, tag: _TAG1)

            }
            
            return false
        }
        
        return true
    }
    
    func dropdownHandleFunc(_ textField:UITextField) {
        if textField == self.dtInput {
            
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                let defectDataHelper = DefectDataHelper()
                
                defectItem.inspectElementId = defectDataHelper.getInspElementIdByName(textField.text!)
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        Cache_Task_On?.didModify = true
        
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        
        if textField.keyboardType == UIKeyboardType.numberPad {
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                
                if textField == self.criticalInput {
                    defectItem.defectQtyCritical = 0
                    
                }else if textField == self.majorInput {
                    defectItem.defectQtyMajor = 0
                    
                }else if textField == self.minorInput {
                    defectItem.defectQtyMinor = 0
                    
                }
                
                defectItem.defectQtyTotal = Int(defectItem.defectQtyCritical + defectItem.defectQtyMajor + defectItem.defectQtyMinor)
                self.totalInput.text = String(defectItem.defectQtyTotal)
            }
        }
        
        return true
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
                
                if Int(inputValue) == nil {
                    inputValue = "0"
                }
                //if Int(inputValue) != nil {
                
                if textField == self.criticalInput {
                    defectItem.defectQtyCritical = Int(inputValue)!
                    
                }else if textField == self.majorInput {
                    defectItem.defectQtyMajor = Int(inputValue)!
                    
                }else if textField == self.minorInput {
                    defectItem.defectQtyMinor = Int(inputValue)!
                    
                }
                //}
                
                defectItem.defectQtyTotal = Int(defectItem.defectQtyCritical + defectItem.defectQtyMajor + defectItem.defectQtyMinor)
                self.totalInput.text = String(defectItem.defectQtyTotal)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.pVC.view.clearDropdownviewForSubviews((self.pVC?.view)!)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
