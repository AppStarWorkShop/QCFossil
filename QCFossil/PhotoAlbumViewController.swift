//
//  PhotoAlbumViewController.swift
//  QCFossil
//
//  Created by pacmobile on 23/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit
import AVFoundation
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class PhotoAlbumViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, AVCaptureMetadataOutputObjectsDelegate {

    var photosSelected = [Photo]()
    var editable = false
    var dataType = PhotoDataType(caseId: "TASK").rawValue // task:0, inspetion:1, defect:2
    var dataRecordId = 0
    weak var pVC:InputModeDFMaster2?//InputModeDFMaster?
    weak var inspElmt:InputModeICMaster?
    var keyboardHeight:CGFloat = 0
    
    @IBOutlet weak var photoTableView: UITableView!
    @IBOutlet weak var sortingBar: UISegmentedControl!
    @IBOutlet weak var addPhotoBtn: CustomButton!//UIButton!
    @IBOutlet weak var addPhotoFromCamera: CustomButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let parentVC = self.parent as? TabBarViewController {
            parentVC.photoAlbumViewController = self
        }
                
        self.navigationItem.leftBarButtonItem = editButtonItem
        self.editButtonItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Edit")
        
        photoTableView.delegate = self
        photoTableView.dataSource = self

        if pVC != nil {
            self.addPhotoBtn.isHidden = true
            self.addPhotoFromCamera.isHidden = true
        }
        
        updateLocalizeString()
    }
    
    func updateLocalizeString() {
        self.addPhotoBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Add Photo"), for: UIControl.State())
        self.addPhotoFromCamera.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("From Camera"), for: UIControl.State())
        
        let segmentTitles = [MylocalizedString.sharedLocalizeManager.getLocalizedString("Filename"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Category"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Area"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Item")]
        
        for idx in 0...self.sortingBar.numberOfSegments-1 {
            self.sortingBar.setTitle(segmentTitles[idx], forSegmentAt: idx)
        }
    }
    
    func loadPhotos() {
        DispatchQueue.main.async(execute: {
            self.view.showActivityIndicator()
            
            if self.pVC != nil {
                Cache_Task_On?.myPhotos = self.getImageNamesFromLocal(PhotoDataType(caseId: "INSPECT").rawValue)
                //self.photos = self.getImageNamesFromLocal(PhotoDataType(caseId: "INSPECT").rawValue)
            }else{
                Cache_Task_On?.myPhotos = self.getImageNamesFromLocal()
                //self.photos = self.getImageNamesFromLocal()
            }
            
            self.photoTableView.reloadData()
            
            self.view.removeActivityIndicator()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.disableAllFunsForView(self.view)
        
        DispatchQueue.main.async(execute: {
            self.loadPhotos()
            self.parent?.view.removeActivityIndicator()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoAlbumViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoAlbumViewController.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if pVC != nil {
            Cache_Task_On?.myPhotos = self.getImageNamesFromLocal()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.editable == true {
            DispatchQueue.main.async(execute: {
                self.view.showActivityIndicator()
                
                DispatchQueue.main.async(execute: {
                    self.setEditing(false,animated: false)
                    self.view.removeActivityIndicator()
                })
            })
        }
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: self.view.window)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.photoTableView.frame.origin.y =  66
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            //adjustTableViewPosition(66 - (keyboardSize.height - 45))
        }
    }
    
    func adjustTableViewPosition(_ offset:CGFloat = 0) {
        self.photoTableView.frame.origin.y =  66
        self.photoTableView.frame.origin.y -= ((offset < 1 ? keyboardHeight : offset) - 45)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let myParentTabVC = self.parent as? TabBarViewController {
            if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue) {
                if let mVC = myParentTabVC as? TabBarViewController {
                    mVC.setLeftBarItem(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form"),actionName: "backToTaskDetailFromPADF")
                }
            }else{
                myParentTabVC.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem
            }
            
            myParentTabVC.navigationItem.rightBarButtonItem = nil
            myParentTabVC.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo Album")
        
            self.view.setButtonCornerRadius(self.addPhotoBtn)
            self.view.setButtonCornerRadius(self.addPhotoFromCamera)
            
            if self.pVC != nil {
                self.photosSelected = [Photo]()
                
                let leftButton = UIBarButtonItem()
                leftButton.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel")
                leftButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
                leftButton.style = UIBarButtonItem.Style.plain
                leftButton.target = self
                leftButton.action = #selector(PhotoAlbumViewController.cancelSelectedPhotos)
                myParentTabVC.navigationItem.leftBarButtonItem = leftButton
                
                let rightButton = UIBarButtonItem()
                rightButton.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
                rightButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
                rightButton.style = UIBarButtonItem.Style.plain
                rightButton.target = self
                rightButton.action = #selector(PhotoAlbumViewController.didSelectedPhotos)
                myParentTabVC.navigationItem.rightBarButtonItem = rightButton

                self.photoTableView.allowsMultipleSelection = true
            }else{
                self.photoTableView.allowsSelection = false
            }

            NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
            
        } else if let _ = self.pVC {
            self.photosSelected = [Photo]()
            
            let leftButton = UIBarButtonItem()
            leftButton.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel")
            leftButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
            leftButton.style = UIBarButtonItem.Style.plain
            leftButton.target = self
            leftButton.action = #selector(PhotoAlbumViewController.cancelSelectedPhotos)
            self.navigationItem.leftBarButtonItem = leftButton
            
            let rightButton = UIBarButtonItem()
            rightButton.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
            rightButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
            rightButton.style = UIBarButtonItem.Style.plain
            rightButton.target = self
            rightButton.action = #selector(PhotoAlbumViewController.didSelectedPhotos)
            self.navigationItem.rightBarButtonItem = rightButton

            self.photoTableView.allowsMultipleSelection = true
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
        }
    }
    
    @objc func cancelSelectedPhotos() {
        print("Cancel Select Photos")
        weak var maskView = self.parent?.view.viewWithTag(_MASKVIEWTAG)
        maskView?.removeFromSuperview()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didSelectedPhotos() {
        print("Did Selected Photos")
        
        if self.photosSelected.count < 1{
            self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("No Photo Selected, OK?"), parentVC:self, handlerFun: { (action:UIAlertAction!) in
                weak var maskView = self.parent?.view.viewWithTag(_MASKVIEWTAG)
                maskView?.removeFromSuperview()
                
                self.navigationController?.popViewController(animated: true)
            })
        }else{
        
            let defectItem = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == pVC?.sectionId && $0.inspElmt.cellIdx == pVC?.itemId && $0.cellIdx == pVC?.cellIdx})
            
            if defectItem?.count > 0 {
                let defectCell = (defectItem![0] as TaskInspDefectDataRecord)
                
                if defectCell.photoNames == nil {
                    defectCell.photoNames = [String]()
                }
                
                for photo in photosSelected {
                    
                    if defectCell.photoNames?.count<=5 {
                        let photoFileName = pVC!.getNameByUpdateDefectPhotoData(0, photo: photo, needSave: false)
                        defectCell.photoNames?.append(photoFileName)
                    }
                }
            }
            
            if photosSelected.count > 0 {
                pVC!.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "yes"))
                if pVC?.inputMode == _INPUTMODE04 {
                    
                    if pVC?.classForCoder == DefectListTableViewCell.classForCoder() {
                        
                        (pVC as! DefectListTableViewCell).updatePhotoAddedStatus("yes")
                    }else{
                        
                        (pVC as! InspectionDefectTableViewCellMode4).updatePhotoAddedStatus("yes")
                    }
                    
                } else if pVC?.inputMode == _INPUTMODE03 {
                    
                    if pVC?.classForCoder == DefectListTableViewCellMode3.classForCoder() {
                        
                        (pVC as! DefectListTableViewCellMode3).updatePhotoAddedStatus("yes")
                    }else{
                        
                        (pVC as! InspectionDefectTableViewCellMode3).updatePhotoAddedStatus("yes")
                    }
                } else if pVC?.inputMode == _INPUTMODE02 {
                    
                    if pVC?.classForCoder == DefectListTableViewCellMode2.classForCoder() {
                        
                        (pVC as! DefectListTableViewCellMode2).updatePhotoAddedStatus("yes")
                    }else{
                        
                        (pVC as! InspectionDefectTableViewCellMode2).updatePhotoAddedStatus("yes")
                    }
                } else if pVC?.inputMode == _INPUTMODE01 {
                    
                    if pVC?.classForCoder == DefectListTableViewCellMode1.classForCoder() {
                        
                        (pVC as! DefectListTableViewCellMode1).updatePhotoAddedStatus("yes")
                    }else{
                        
                        (pVC as! InspectionDefectTableViewCellMode1).updatePhotoAddedStatus("yes")
                    }
                }
            }
            
            let maskView = self.parent?.view.viewWithTag(_MASKVIEWTAG)
            maskView?.removeFromSuperview()
        
            //Update Photo Album
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil)
                       
            self.navigationController?.popViewController(animated: true)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableview"), object: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addPhoto(_ sender: CustomButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .popover
        
        let ppc = imagePicker.popoverPresentationController
        ppc?.sourceView = sender
        ppc?.sourceRect = sender.bounds
        ppc?.permittedArrowDirections = .any
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addPhotoFromCamera(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
            
        }else{
            imagePicker.modalPresentationStyle = .popover
            imagePicker.sourceType = .photoLibrary
            
            let ppc = imagePicker.popoverPresentationController
            ppc?.sourceView = sender
            ppc?.sourceRect = sender.bounds
            ppc?.permittedArrowDirections = .any
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func initPhotoTakerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoAlbumViewController.takePhotoFromICCell(_:)), name: NSNotification.Name(rawValue: "takePhotoFromICCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoAlbumViewController.reloadPhotos(_:)), name: NSNotification.Name(rawValue: "reloadPhotos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoAlbumViewController.reloadAddPhotos(_:)), name: NSNotification.Name(rawValue: "reloadAddPhotos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoAlbumViewController.reloadAllPhotosFromDB(_:)), name: NSNotification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoAlbumViewController.updatePhotoInfo(_:)), name: NSNotification.Name(rawValue: "updatePhotoInfo"), object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "takePhotoFromICCell"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "takePhotoFromICCell"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadAddPhotos"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updatePhotoInfo"), object: nil)
    }
    
    @objc func reloadPhotos(_ notification:Notification) {
        let photoObj:Dictionary<String,Photo> = notification.userInfo as! Dictionary<String,Photo>
        Cache_Task_On!.myPhotos = Cache_Task_On!.myPhotos.filter({$0.photoId != photoObj["photoSelected"]?.photoId})
        
        self.photoTableView?.reloadData()
    }
    
    @objc func reloadAddPhotos(_ notification:Notification) {
        let photoObj:Dictionary<String,Photo> = notification.userInfo as! Dictionary<String,Photo>
        Cache_Task_On!.myPhotos.append(photoObj["photoSelected"]!)
        
        self.photoTableView?.reloadData()
    }
    
    @objc func reloadAllPhotosFromDB(_ notification:Notification) {
        loadPhotos()
    }
    
    @objc func takePhotoFromICCell(_ notification:Notification) {
        let inspElmt:Dictionary<String,InputModeICMaster> = notification.userInfo as! Dictionary<String,InputModeICMaster>
        self.inspElmt = inspElmt["inspElmt"]
        
        if self.inspElmt?.taskInspDataRecordId>0 {
            dataRecordId = (self.inspElmt?.taskInspDataRecordId)!
        }
        dataType = PhotoDataType(caseId: "INSPECT").rawValue
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func updatePhotoInfo(_ notification:Notification) {
        let inspElmt:Dictionary<String,InputModeICMaster> = notification.userInfo as! Dictionary<String,InputModeICMaster>
        
        for photo in (Cache_Task_On?.myPhotos)! /*self.photos*/ {
            if photo.dataRecordId == inspElmt["inspElmt"]?.taskInspDataRecordId {
                photo.inspItemName = inspElmt["inspElmt"]?.inspItemText
                
                if inspElmt["inspElmt"]?.inspCatText == "" {
                    photo.inspAreaName = inspElmt["inspElmt"]?.inspAreaText
                }else{
                    photo.inspAreaName = ""
                }
                
                photo.inspCatName = inspElmt["inspElmt"]?.inspReqCatText
            }
        }
        
        self.photoTableView?.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //UIImagePickerControllerOriginalImage  原始影象
        //UIImagePickerControllerEditedImage    編輯後的圖片(開啟編輯該物件才存在)
        picker.dismiss(animated: true) {
        
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                var photo:Photo?
                if self.dataType == PhotoDataType(caseId: "INSPECT").rawValue {
                    
                    if self.inspElmt == nil {
                        print("InspElmt is Nil, Return")
                        return
                    }
                    
                    photo = image.saveImageToLocal(image, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.dataRecordId, dataType: self.dataType, currentDate: self.view.getCurrentDateTime(), originFileName: "originFileName")
                    
                    photo?.inspCatName = self.inspElmt?.inspReqCatText
                    photo?.inspAreaName = self.inspElmt?.inspAreaText
                    photo?.inspItemName = self.inspElmt?.inspItemText
                    photo?.inspElmt = self.inspElmt
                    
                    if let _photo = photo {
                        self.inspElmt?.inspPhotos.append(_photo)
                    }
                    
                    if let vc = self.inspElmt?.parentVC as? TaskDetailsViewController {
                        vc.refreshCameraIcon()
                    }
                    
                } else {
                    photo = image.saveImageToLocal(image, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: nil, dataType: self.dataType, currentDate: self.view.getCurrentDateTime(),originFileName: "originFileName")
                }
                
                self.dataType = Int(PhotoDataType(caseId: "TASK").rawValue)
            

                if let _photo = photo {
                    Cache_Task_On!.myPhotos.append(_photo)
                }
            
                DispatchQueue.main.async(execute: {
                    self.photoTableView.reloadData()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.photoTableView.reloadData()
//                    }
                })
            }
        }
    }
    
    func getImageNamesFromLocal(_ dataType:Int=2) ->[Photo] {
        
        if (Cache_Task_Path == nil) {
            return [Photo]()
        }
        
        let photoDataHelper = PhotoDataHelper()
        let photoDBDatas = photoDataHelper.getPhotosByTaskId((Cache_Task_On?.taskId)!, dataType: dataType)
        
        return photoDBDatas!
    }
    
    func getImagesFromLocal(_ dataType:Int=2) ->[Photo] {
        let fileManager :FileManager = FileManager.default
        
        if (Cache_Task_Path == nil) {
            return [Photo]()
        }
        
        let imageFileArray = fileManager.subpaths(atPath: Cache_Task_Path!)
        
        let photoDataHelper = PhotoDataHelper()
        let photoDBDatas = photoDataHelper.getPhotosByTaskId((Cache_Task_On?.taskId)!, dataType: dataType)
        var photoList = [Photo]()
        
        for imageFile in imageFileArray! {
            if imageFile.contains(".jpg") {
                let photoDBFilter = photoDBDatas?.filter({$0.photoFile == imageFile})
                
                if photoDBFilter?.count>0 {
                    
                    let photoDBObj = photoDBFilter![0]
                
                    let path = Cache_Thumb_Path!+"/"+imageFile
                    let image = UIImage(contentsOfFile: path)
                    let imageView = UIImageView(image:image)
                
                    photoDBObj.photo = imageView
                    
                    photoList.append(photoDBObj)
                }
            }
        }
        
        return photoList
    }
    
    func numberOfSections(in photoTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ photoTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cache_Task_On!.myPhotos.count//photos.count
    }
    
    func tableView(_ photoTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photoTableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoAlbumCellTableViewCell
        cell.tag = indexPath.row
        
        if indexPath.row < Cache_Task_On!.myPhotos.count {
        
            let photo = Cache_Task_On!.myPhotos[indexPath.row] as Photo
        
            cell.photo.sizeToFit()
            cell.photo.layer.masksToBounds = true
            
            cell.photoFilename.text = photo.photoFilename
            cell.photoDescription.text = photo.photoDesc
        
            cell.inspAreaInput.text = photo.inspAreaName
            cell.inspCatInput.text = photo.inspCatName
            cell.inspItemInput.text = photo.inspItemName
        
            if editable {
                cell.photoDescription.isEditable = true
                cell.photoDescription.backgroundColor = UIColor.white
            }else{
                cell.photoDescription.isEditable = false
                cell.photoDescription.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            if photo.photoFilename != "" {
                let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photo.photoFilename
                cell.photo.image = UIImage(contentsOfFile: pathForImage)
            }
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cell.backgroundColor = _TABLECELL_BG_COLOR1
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        NSLog("Did Select Row")
        
        let photoCount = self.pVC?.photoNameAtIndex.filter({ $0 != "" })
        var usedPhotoCount = 0
        if photoCount != nil {
            usedPhotoCount = (photoCount?.count)!
        }
        
        print("SELECTED: \(photosSelected.count + usedPhotoCount)")
        
        if photosSelected.count + usedPhotoCount < 5 {
            photosSelected.append(Cache_Task_On!.myPhotos[indexPath.row])
            
            return indexPath
        }else{
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Photos!"))
            return nil
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let photoobj = Cache_Task_On!.myPhotos[indexPath.row]
        photosSelected = photosSelected.filter({$0.photoId != photoobj.photoId})
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete");
    }
    
    func tableView(_ photoTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        /*if self.view.disableFuns(self.view) {
            
            if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Confirmed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue) {
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Confirmed or Cancelled Task!"))
            }else if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue){
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Uploaded, Reviewed or Refused Task!"))
            }
            
            return
        }*/
        
        if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue) {
            
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Uploaded, Reviewed or Refused Task!"))
            return
        }
        
        if editingStyle == .delete {
            self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Photo From Photo Album?"), parentVC:self, handlerFun: { (action:UIAlertAction!) in
                //Set Photo Added iCon Status for InspElmt
                let photoSelected = Cache_Task_On!.myPhotos[indexPath.row] //self.photos[indexPath.row]
                let inspElmt = photoSelected.inspElmt
                
                if inspElmt != nil {
                    var idx = 0
                    for photo in (inspElmt?.inspPhotos)! {
                        if photo === photoSelected {
                            inspElmt?.inspPhotos.remove(at: idx)
                        }
                        idx += 1
                    }
                }
                
                //Delete From UI
                Cache_Task_On?.myPhotos.remove(at: indexPath.row)
                //self.photos.removeAtIndex(indexPath.row)
                self.photoTableView.reloadData()
                
                //Delete From DB&Local
                if photoSelected.photoId>0 && photoSelected.photoFile != "" {
                    UIImage.init().removeImageFromLocal(photoSelected, path: Cache_Task_Path!)
                }
            })

            //self.photoTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ photoTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.photoTableView.setEditing(editing, animated: animated)
        
        if editing {
            print("Photo Album Editing")
            self.editButtonItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
            
            self.editable = true
            
        }else{
            print("Photo Album Done")
            self.editButtonItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Edit")
            
            if Cache_Task_On!.myPhotos.count > 0 {//if self.photos.count > 0 {
                
                for idx in 0...Cache_Task_On!.myPhotos.count-1 {
                    let indexPath = IndexPath.init(row: idx, section: 0)
                    
                    let cell = self.photoTableView.cellForRow(at: indexPath) as? PhotoAlbumCellTableViewCell
                    
                    if (cell != nil) {
                        
                        let photoSetFilter = Cache_Task_On!.myPhotos.filter({$0.photoFile == (cell?.photoFilename.text)!})
                        
                        if photoSetFilter.count > 0 {
                            let photo = photoSetFilter[0]
                            photo.photoDesc = cell!.photoDescription.text
                        }
                    }
                }
            }
            
            //save to db
            let photoDataHelper = PhotoDataHelper()
            for photo in Cache_Task_On!.myPhotos {
                photoDataHelper.savePhoto(photo)
            }
            
            self.editable = false
            
        }
        
        self.photoTableView.reloadData()
    }
    
    @IBAction func PhotoAlbumSorting(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        
        switch selectedSegment {
        case 0: Cache_Task_On!.myPhotos.sort(){$0.photoFile>$1.photoFile};
        case 1: Cache_Task_On!.myPhotos.sort(){$0.inspCatName<$1.inspCatName};
        case 2: Cache_Task_On!.myPhotos.sort(){$0.inspAreaName<$1.inspAreaName};
        case 3: Cache_Task_On!.myPhotos.sort(){$0.inspItemName<$1.inspItemName};
            
        default: Cache_Task_On!.myPhotos.sort(){$0.photoFile>$1.photoFile};
        }
        
        self.photoTableView.reloadData()
    }
}
