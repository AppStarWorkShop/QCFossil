//
//  InputMode02CellView.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
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


class InputMode02CellView: InputModeICMaster, UITextFieldDelegate {
    
    @IBOutlet weak var cellIndexLabel: UILabel!
    @IBOutlet weak var dpLabel: UILabel!
    @IBOutlet weak var dpInput: UITextField!
    @IBOutlet weak var dpDescLabel: UILabel!
    @IBOutlet weak var dpDescInput: UITextField!
    @IBOutlet weak var cellResultLabel: UILabel!
    @IBOutlet weak var cellResultInput: UITextField!
    @IBOutlet weak var cellDPPLabel: UILabel!
    @IBOutlet weak var cellDPPInput: UITextField!
    @IBOutlet weak var cellPAInput: UILabel!
    @IBOutlet weak var cellDefectButton: UIButton!
    @IBOutlet weak var cellDismissButton: UIButton!
    @IBOutlet weak var photoAddedIcon: UIImageView!
    @IBOutlet weak var takePhotoIcon: UIButton!
    @IBOutlet weak var defectZoneLabel: UILabel!
    @IBOutlet weak var defectZoneInput: UITextField!
    @IBOutlet weak var defectZoneListIcon: UIButton!
    @IBOutlet weak var defectPositionPointIcon: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var showDefectPositionPointsButton: UIButton!
    
    var myDefectPositPoints = [PositPointObj]()
    var zoneValues:[DropdownValue]?
    var inspectItemKeyValues = [String:Int]()
    var zoneItemKeyValues = [String:Int]()
    var defectPositionPoints = [String:Int]()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    override func awakeFromNib() {
        self.cellResultInput.delegate = self
        self.dpInput.delegate = self
        self.cellDPPInput.delegate = self
        self.defectZoneInput.delegate = self
        self.cellDismissButton.isHidden = true
        updateLocalizedString()
    }
    
    override func didMoveToSuperview() {
        
        guard let parentView = self.parentView as? InputMode02View else {return}

        for dfPosit in parentView.defectPosits {
            inspectItemKeyValues[MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: dfPosit.positionNameEn, .zh: dfPosit.positionNameCn, .fr: dfPosit.positionNameFr])] = dfPosit.positionId
        }
        
        let zoneDataHelper = ZoneDataHelper()
        let zoneItems = zoneDataHelper.getZoneValuesByPositionId(self.inspPostId ?? 0)
        zoneItems.forEach({ zoneItem in
            zoneItemKeyValues[MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: zoneItem.valueNameEn, .zh: zoneItem.valueNameCn, .fr: zoneItem.valueNameFr])] = zoneItem.valueId
        })
        
        let defectPositPoints = (self.parentView as! InputMode02View).defectPositPoints.filter({ $0.parentId == self.inspPostId ?? 0})
        defectPositPoints.forEach({ defectPositPoint in
            defectPositionPoints[MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: defectPositPoint.positionNameEn, .zh: defectPositPoint.positionNameCn, .fr: defectPositPoint.positionNameFr])] = defectPositPoint.positionId
        })
        
        if self.cellDPPInput.isTruncated() {
            self.showDefectPositionPointsButton.isHidden = false
        }
        
        if self.dpInput.isTruncated() {
            self.showTextFieldFullTextButton(textField: dpInput)
        }
        
        if self.defectZoneInput.isTruncated() {
            self.showTextFieldFullTextButton(textField: defectZoneInput)
        }
        
        updatePhotoAddediConStatus(self.cellResultInput.text ?? "", photoTakenIcon: self.photoAddedIcon)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return;
        }
        
        if touch.view!.isKind(of: UITextField().classForCoder) || String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.resignFirstResponderByTextField((self.parentVC?.view)!)
            
        }else {
            self.parentVC?.view.clearDropdownviewForSubviews((self.parentVC?.view)!)
            
        }
    }
    
    func updateLocalizedString(){
        self.dpLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position")
        self.dpDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Description")
        self.cellDPPLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Points & Info")
        self.cellResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result")
        self.defectZoneLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Zone")
        self.errorMessageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter defect point info")
    }
    
    @IBAction func defectBtnOnClick(_ sender: UIButton) {
        
        
        var myParentTabVC:TabBarViewController?
        self.parentVC?.navigationController?.viewControllers.forEach({ vc in
            if let parentVC = vc as? TabBarViewController {
                myParentTabVC = parentVC
            }
        })
        
        //check if defect input and defect position points nil, then return
        if let defectDPPInput = cellDPPInput.text {
            if defectDPPInput == "" || defectDPPInput.isEmpty {
                self.errorMessageLabel.isHidden = false
                return
            } else {
                self.errorMessageLabel.isHidden = true
            }
        }
        
        let defectListVC = myParentTabVC?.defectListViewController
        
        //add defect cell
        if !isDefectItemAdded(defectListVC!) {
            let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime(), isPreSave: "1")
            
            newDfItem?.inputMode = _INPUTMODE02
            newDfItem?.inspElmt = self
            newDfItem?.sectObj = SectObj(sectionId:cellCatIdx, sectionNameEn: self.cellCatName, sectionNameCn: self.cellCatName, sectionNameFr: self.cellCatName,inputMode: _INPUTMODE02)
            newDfItem?.elmtObj = ElmtObj(elementId:self.elementDbId,elementNameEn:"", elementNameCn:"", elementNameFr: "", reqElmtFlag: 0)
            
            let defectsByItemId = Cache_Task_On?.defectItems.filter({$0.sectObj.sectionId == self.cellCatIdx && $0.elmtObj.elementId == self.elementDbId})
            newDfItem?.cellIdx = defectsByItemId!.count
            newDfItem?.sortNum = (newDfItem?.sectObj.sectionId)!*1000000 + (newDfItem?.inspElmt.elementDbId)!*1000 + (newDfItem?.cellIdx)!
            newDfItem?.photoNames = [String]()
            
            let taskDataHelper = TaskDataHelper()
            newDfItem?.recordId = taskDataHelper.updateInspDefectDataRecord(newDfItem!)
            
            if newDfItem?.recordId > 0 {
                Cache_Task_On?.defectItems.append(newDfItem!)
            }
        }
        
        self.parentVC!.performSegue(withIdentifier: "DefectListFromInspectItemSegue", sender:self)
    
    }
    
    func dropdownHandleFunc(_ textField: UITextField) {
        Cache_Task_On?.didModify = true
        
        if textField == self.cellResultInput {
            
            guard let resultText = cellResultInput.text else {return}
            
            self.resultValueId = self.parentView.resultKeyValues[resultText] ?? 0
            updatePhotoAddediConStatus(resultText, photoTakenIcon: self.photoAddedIcon)
            
        }else if textField == self.cellDPPInput {
            self.inspItemText = textField.text!
            myDefectPositPoints = [PositPointObj]()
            
            let selectedValues = textField.text!.replacingOccurrences(of: ", ", with: ",")
            
            let cells = selectedValues.characters.split{$0 == ","}.map(String.init)
            for cell in cells {
                let positName = (cell as String).trimmingCharacters(in: .whitespaces)

                let positObjs = (self.parentView as! InputMode02View).defectPositPoints.filter({$0.positionNameFr == positName || $0.positionNameEn == positName || $0.positionNameCn == positName})
                
                if positObjs.count>0 {
                    myDefectPositPoints.append(positObjs[0])
                }
            }
            
            textField.backgroundColor = UIColor.white
            self.defectPositionPointIcon.isHidden = false
            
            if self.cellDPPInput.isTruncated() {
                self.showDefectPositionPointsButton.isHidden = false
            } else {
                self.showDefectPositionPointsButton.isHidden = true
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePhotoInfo"), object: nil,userInfo: ["inspElmt":self])
        }else if textField == self.dpInput {
            
            if self.inspAreaText != textField.text! {
                self.cellDPPInput.text = ""
                self.inspItemText = ""
                
                // delete all defect items if not match
                self.deleteDefectItems()
            }
            
            self.inspAreaText = textField.text!
            
            self.inspPostId = inspectItemKeyValues[textField.text!]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePhotoInfo"), object: nil,userInfo: ["inspElmt":self])
            
            let parentPositObjs = (self.parentView as! InputMode02View).defectPosits.filter({$0.positionNameFr == self.dpInput.text || $0.positionNameEn == self.dpInput.text || $0.positionNameCn == self.dpInput.text})
            if parentPositObjs.count > 0 {
                self.cellDPPInput.backgroundColor = UIColor.white
                self.defectPositionPointIcon.isHidden = false
            }
            
            let zoneDataHelper = ZoneDataHelper()
            let defectZoneValues = zoneDataHelper.getZoneValuesByPositionId(self.inspPostId ?? 0)
            if defectZoneValues.count > 0 {
                defectZoneInput.backgroundColor = UIColor.white
                self.defectZoneListIcon.isHidden = false
            }
            
            let zoneItems = zoneDataHelper.getZoneValuesByPositionId(self.inspPostId ?? 0)
            zoneItems.forEach({ zoneItem in
                zoneItemKeyValues[MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: zoneItem.valueNameEn, .zh: zoneItem.valueNameCn, .fr: zoneItem.valueNameFr])] = zoneItem.valueId
            })
            
            let defectPositPoints = (self.parentView as! InputMode02View).defectPositPoints.filter({ $0.parentId == self.inspPostId ?? 0})
            defectPositionPoints = [:]
            defectPositPoints.forEach({ defectPositPoint in
                defectPositionPoints[MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: defectPositPoint.positionNameEn, .zh: defectPositPoint.positionNameCn, .fr: defectPositPoint.positionNameFr])] = defectPositPoint.positionId
            })
            
        } else if textField == self.defectZoneInput {
            
            guard let zoneValueName = self.defectZoneInput.text else {return}
            self.inspectZoneValueId = zoneItemKeyValues[zoneValueName]
            
            textField.backgroundColor = UIColor.white
            self.defectZoneListIcon.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cellDPPInput {
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //clearDropdownviewForSubviews(self.parentView!)
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.cellResultInput {
            
            if self.ifExistingSubviewByViewTag(self.parentView, tag: _TAG3) {
                clearDropdownviewForSubviews(self.parentView!)
            }else{
                
                textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: self.parentView!.resultValues as NSArray, width: 200, height: 250, tag: _TAG3)
            }
            
        }else if textField == self.dpInput {
            var positName = [String]()
            
            for key in self.inspectItemKeyValues.keys {
                positName.append(key)
            }
            
            if self.ifExistingSubviewByViewTag(self.parentView, tag: _TAG2) {
                clearDropdownviewForSubviews(self.parentView!)
            }else{
            
                textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: self.sortStringArrayByName(positName) as NSArray, height:_DROPDOWNLISTHEIGHT, tag: _TAG2)
            }
            
        }else if textField == self.cellDPPInput {
            
            var positName = [String]()
            for key in self.defectPositionPoints.keys {
                positName.append(key)
            }
                
            if self.ifExistingSubviewByViewTag(self.parentView, tag: _TAG1) {
                clearDropdownviewForSubviews(self.parentView!)
            }else{
                
                textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: self.sortStringArrayByName(positName) as NSArray, width:320, height:_DROPDOWNLISTHEIGHT, allowMulpSel: true, tag: _TAG1)
            }
            
        }else if textField == self.defectZoneInput {
            
            var listData = [String]()
            for key in self.zoneItemKeyValues.keys {
                listData.append(key)
            }
            
            if self.ifExistingSubviewByViewTag(self.parentView, tag: _TAG1) {
                clearDropdownviewForSubviews(self.parentView)
                return false
            }
            
            textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData) as NSArray, height:_DROPDOWNLISTHEIGHT, tag: _TAG1)
        }
        
        return false
    }
    
    @IBAction func dismissBtnOnClick(_ sender: UIButton) {
        let photoDataHelper = PhotoDataHelper()
        if photoDataHelper.existPhotoByInspItem(self.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || self.inspPhotos.count>0 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo(s) of this inspection item will be deleted!"), handlerFun: { (action:UIAlertAction!) in
                self.deleteInspItem()
            })
        }else{
            deleteInspItem()
        }
    }
    
    func deleteInspItem() {
        clearDropdownviewForSubviews(self.parentView!)
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete?"), parentVC:(self.parentView?.parentVC)!, handlerFun: { (action:UIAlertAction!) in
            
            (self.parentView as! InputMode02View).inputCells.remove(at: self.cellPhysicalIdx)
            self.removeFromSuperview()
            (self.parentView as! InputMode02View).updateContentView()
            
            //Update Photos Status
            let taskDataHelper = TaskDataHelper()
            
            if self.taskInspDataRecordId > 0 {
                self.deleteTaskPhotos(true)
                //Reload Photos
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil, userInfo: nil)
                
                //Delete Item From DB
                self.deleteTaskInspDataRecord(self.taskInspDataRecordId!)
                
                //Delete Relative Defect Position Points From DB
                taskDataHelper.deleteTaskDefectDataPPTRecordsByInspItemId(self.taskInspDataRecordId!)
            }
            
            self.deleteDefectItems()
        })
    }
    
    func deleteDefectItems() {
        //Delete Relative Defect Items From DB
        let defectItemsArray = Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == self.cellCatIdx && $0.inspElmt.cellIdx == self.cellIdx })
        
        if defectItemsArray?.count > 0 {
            for defectItem in defectItemsArray! {
                if let defectItems = Cache_Task_On?.defectItems.filter({$0.inspElmt != self}) {
                    Cache_Task_On?.defectItems = defectItems
                }
                
                //remove DB data
                if defectItem.photoNames != nil && defectItem.photoNames?.count>0 {
                    for photoName in defectItem.photoNames! {
                        //Remove defect photo to Photo Album
                        let photoDataHelper = PhotoDataHelper()
                        photoDataHelper.updatePhotoDatasByPhotoName(photoName, dataType:PhotoDataType(caseId: "TASK").rawValue, dataRecordId:0)
                    }
                }
                
                //Delete Record From DB
                let taskDataHelper = TaskDataHelper()
                if defectItem.recordId > 0 {
                    taskDataHelper.deleteTaskInspDefectDataRecordById(defectItem.recordId!)
                }
            }
        }
    }
    
    func showDismissButton() {
        self.cellDismissButton.isHidden = false
    }
    
    @IBAction func takePhotoFromCell(_ sender: UIButton) {
        if self.dpInput.text == "" {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Defect Position and Points"))
            
            return
        }
        
        DispatchQueue.main.async(execute: {
            self.showActivityIndicator()
            //Save self to DB to get the taskDataRecordId
            self.saveMyselfToGetId()
            
            DispatchQueue.main.async(execute: {
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "takePhotoFromICCell"), object: nil, userInfo: ["inspElmt":self])
                
                self.removeActivityIndicator()
            })
        })
    }
    
    override func saveMyselfToGetId() {
        //Save self to DB to get the taskDataRecordId
        if self.taskInspDataRecordId < 1 {
            let taskDataHelper = TaskDataHelper()
            let taskInspDataRecord = TaskInspDataRecord.init(recordId: self.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: self.refRecordId!, inspectSectionId: self.cellCatIdx, inspectElementId: self.inspElmId!, inspectPositionId: self.inspPostId!, inspectPositionDesc: "", inspectDetail: "", inspectRemarks: "", resultValueId: self.resultValueId, requestSectionId: 0, requestElementDesc: "", createUser: (Cache_Inspector?.appUserName)!, createDate: self.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.getCurrentDateTime(), isPreSave: "1")
            
            self.taskInspDataRecordId = taskDataHelper.insertTaskInspDataRecord(taskInspDataRecord!)
            
            if self.taskInspDataRecordId>0 /*&& self.myDefectPositPoints.count>0*/ {
                var dppDatas = [TaskInspPosinPoint]()
                for dpp in self.myDefectPositPoints {
                    let dppData = TaskInspPosinPoint.init(inspRecordId: self.taskInspDataRecordId!, inspPosinId: dpp.positionId, createUser: (Cache_Inspector?.appUserName)!, createDate: self.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.getCurrentDateTime())
                    
                    dppDatas.append(dppData!)
                }
                
                let dpDataHelper = DPDataHelper()
                dppDatas = dpDataHelper.updateDefectPositionPoints(self.taskInspDataRecordId!,defectPositionPoints: dppDatas)
            }
        }
    }
    
    @IBAction func clearDropdownListOnClick(_ sender: UIButton) {
        self.parentView.clearDropdownviewForSubviews(self.parentView)
    }
    
    @IBAction func showDefectPositionPoints(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)
        popoverContent.dataType = _POPOVERNOTITLE
        popoverContent.selectedValue = self.cellDPPInput.text ?? ""
        
        let nav = CustomNavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.tintColor = UIColor.black
        
        let popover = nav.popoverPresentationController
        popover!.delegate = sender.parentVC as! PopoverMaster
        popover!.sourceView = sender
        popover!.sourceRect = sender.bounds
        
        sender.parentVC!.present(nav, animated: true, completion: nil)
    }
}
