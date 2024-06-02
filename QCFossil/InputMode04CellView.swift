//
//  InputMode04CellView.swift
//  QCFossil
//
//  Created by pacmobile on 5/1/16.
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


class InputMode04CellView: InputModeICMaster, UITextFieldDelegate {

    @IBOutlet weak var idxLabel: UILabel!
    @IBOutlet weak var inspectionAreaLabel: UITextField!
    @IBOutlet weak var inspectionItemLabel: UITextField!
    @IBOutlet weak var subResultInput: UITextField!
    @IBOutlet weak var photoAddedLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var photoAddedIcon: UIImageView!
    @IBOutlet weak var takePhotoIcon: CustomControlButton!
    
    //weak var parentView = InputMode04View()
    var dismissable = false
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        subResultInput.delegate = self
        inspectionAreaLabel.delegate = self
        inspectionItemLabel.delegate = self
        dismissButton.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        
        if touch.view!.isKind(of: UITextField().classForCoder) || String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.resignFirstResponderByTextField((self.parentVC?.view)!)
            
        }else {
            self.parentVC?.view.clearDropdownviewForSubviews((self.parentVC?.view)!)
            
        }
        
    }
    
    override func didMoveToSuperview() {
        
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            return
        }
        
        self.inspReqCatText = self.cellCatName
        
        updatePhotoAddediConStatus(self.subResultInput.text ?? "", photoTakenIcon: self.photoAddedIcon)
    }
    
    func updateParentOptionElmts() {
        let usedInspItems = (self.parentView as! InputMode04View).inputCells.filter({ $0.requiredElementFlag == 0 })
        var usedInspItemNames = [String]()
        
        for usedInspItem in usedInspItems {
            usedInspItemNames.append(usedInspItem.inspectionItemLabel.text!)
        }
        
        (self.parentView as! InputMode04View).updateOptionalInspElmts(usedInspItemNames)
    }
    
    func dropdownHandleFunc(_ textField:UITextField) {
        if textField == subResultInput {
            
            guard let resultText = subResultInput.text else {return}
            
            self.resultValueId = self.parentView.resultKeyValues[resultText] ?? 0
            updatePhotoAddediConStatus(textField.text!,photoTakenIcon: self.photoAddedIcon)
            
        }else if textField == inspectionAreaLabel {
            
            if  self.inspAreaText != textField.text! {
                self.inspectionItemLabel.text = ""
                self.inspItemText = ""
            }
            
            self.inspAreaText = textField.text!
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePhotoInfo"), object: nil,userInfo: ["inspElmt":self])
            
        }else if textField == inspectionItemLabel {
            if self.parentView!.optInspElms.count > 0 {
                let optInspElmFilterList = self.parentView!.optInspElms.filter({$0.elementNameEn == textField.text || $0.elementNameCn == textField.text})
                
                if optInspElmFilterList.count > 0 {
                    let optInspElmFilter = optInspElmFilterList[0]
                    let optInspPostFilter = self.parentView!.optInspPosts.filter({$0.positionId == optInspElmFilter.inspectPositionId})[0]
                    
                    inspectionAreaLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: optInspPostFilter.positionNameEn, .zh: optInspPostFilter.positionNameCn, .fr: optInspPostFilter.positionNameFr])
                    
                    self.inspItemText = textField.text!
                    self.inspAreaText = inspectionAreaLabel.text!
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePhotoInfo"), object: nil,userInfo: ["inspElmt":self])
                    
                    //Update Parent InspElmt
                    updateParentOptionElmts()
                    
                    //Update DB data
                    self.inspElmId = optInspElmFilter.elementId
                    self.inspPostId = optInspPostFilter.positionId
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //clearDropdownviewForSubviews(self.parentView!)
        if self.ifExistingSubviewByViewTag(self.parentView, tag: _TAG1) {
            clearDropdownviewForSubviews(self.parentView)
            return false
        }
        
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        Cache_Task_On?.didModify = true
        
        if textField == subResultInput {
            
            textField.showListData(textField, parent: ((self.parentView as! InputMode04View).ScrollCellView)!, handle: handleFun, listData: self.parentView!.resultValues as NSArray, width: 200,height:250, tag: _TAG1)
            
        }else if textField == inspectionAreaLabel {
            var listData = [String]()
            for optInspPost in self.parentView!.optInspPosts {
                listData.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: optInspPost.positionNameEn, .zh: optInspPost.positionNameCn, .fr: optInspPost.positionNameFr]) )
            }
            
            textField.showListData(textField, parent: ((self.parentView as! InputMode04View).ScrollCellView)!, handle: handleFun, listData: listData as NSArray, width: inspectionAreaLabel.frame.size.width*1.2, height: 250, tag: _TAG1)
            
        }else if textField == inspectionItemLabel {
            var listData = [String]()
            
            if inspectionAreaLabel.text != "" {
                let optInspPostFilter = self.parentView!.optInspPosts.filter({$0.positionNameEn == inspectionAreaLabel.text || $0.positionNameCn == inspectionAreaLabel.text})
                
                if optInspPostFilter.count > 0 {
                    let optInspElmFilter = self.parentView!.optInspElms.filter({$0.inspectPositionId == optInspPostFilter[0].positionId})
                
                    if optInspElmFilter.count > 0 {
                        for optInspElm in optInspElmFilter {
                            listData.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: optInspElm.elementNameEn, .zh: optInspElm.elementNameCn, .fr: optInspElm.elementNameFr]) )
                        }
                    }
                }
            }else{
                for optInspElm in self.parentView!.optInspElms {
                    listData.append( MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: optInspElm.elementNameEn, .zh: optInspElm.elementNameCn, .fr: optInspElm.elementNameFr]) )
                }
            }
            textField.showListData(textField, parent: ((self.parentView as! InputMode04View).ScrollCellView)!, handle: handleFun, listData: listData as NSArray, width: inspectionItemLabel.frame.size.width*1.2, height: 250, tag: _TAG1)
            
        }
        
        return false
    }
    
    @IBAction func defectButton(_ sender: UIButton) {
        //add defect cell to defect list
        /*
        if self.inspectionAreaLabel.text == "" || self.inspectionItemLabel.text == "" || self.resultValueId < 1 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Area and Inspect Item"))
            return
        }
        
        //Save self to DB to get the taskDataRecordId
        self.saveMyselfToGetId()
        */
        var myParentTabVC:TabBarViewController?
        self.parentVC?.navigationController?.viewControllers.forEach({ vc in
            if let parentVC = vc as? TabBarViewController {
                myParentTabVC = parentVC
            }
        })
        let defectListVC = myParentTabVC?.defectListViewController
        
        
        //add defect cell
        if !isDefectItemAdded(defectListVC!) {
            let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime(), isPreSave: "1")
            
            newDfItem?.inputMode = _INPUTMODE04
            newDfItem?.inspElmt = self
            newDfItem?.sectObj = SectObj(sectionId:cellCatIdx, sectionNameEn: self.cellCatName, sectionNameCn: self.cellCatName, sectionNameFr: self.cellCatName,inputMode: _INPUTMODE04)
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
        
        //NSNotificationCenter.defaultCenter().postNotificationName("switchTabViewToDL", object: nil)
        self.parentVC!.performSegue(withIdentifier: "DefectListFromInspectItemSegue", sender:self)
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        let photoDataHelper = PhotoDataHelper()
        
        if photoDataHelper.existPhotoByInspItem(self.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || self.inspPhotos.count>0 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo(s) of this inspection item will be deleted!"), handlerFun: { (action:UIAlertAction!) in
                self.deleteInspItem()
            })
        }else{
            self.deleteInspItem()
        }
    }

    func deleteInspItem() {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete?"), parentVC:(self.parentView?.parentVC)!, handlerFun: { (action:UIAlertAction!) in
            
            (self.parentView as! InputMode04View).inputCells.remove(at: self.cellPhysicalIdx)
            self.removeFromSuperview()
            (self.parentView as! InputMode04View).updateContentView()
            
            //Delete Item From DB
            if self.taskInspDataRecordId > 0 {
                //self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo(s) of this inspection item will be deleted!"), parentVC:(self.parentView?.parentVC)!, handlerFun: { (action:UIAlertAction!) in
                
                self.deleteTaskPhotos(true)
                //Reload Photos
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil, userInfo: nil)
                //})
                
                self.deleteTaskInspDataRecord(self.taskInspDataRecordId!)
            }
            
            //Update Parent OptionElmts
            var releaseInspItems = [String]()
            releaseInspItems.append(self.inspectionItemLabel.text!)
            (self.parentView as! InputMode04View).updateOptionalInspElmts(releaseInspItems,action: "add")
            
            //Delete Relative Defect Items From DB
            //NSNotificationCenter.defaultCenter().postNotificationName("deleteDefectItemsByInspItem", object: nil, userInfo: ["inspElmt":self])
            
            let defectItemsArray = Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == self.cellCatIdx && $0.inspElmt.cellIdx == self.cellIdx })
            
            if defectItemsArray?.count > 0 {
                for defectItem in defectItemsArray! {
                    let index = Cache_Task_On?.defectItems.index(where: { $0.inspElmt.cellCatIdx == defectItem.inspElmt.cellCatIdx && $0.inspElmt.cellIdx == defectItem.inspElmt.cellIdx && $0.cellIdx == defectItem.cellIdx })
                    Cache_Task_On?.defectItems.remove(at: index!)
                    
                    //remove DB data
                    if defectItem.photoNames != nil && defectItem.photoNames?.count>0 {
                        for photoName in defectItem.photoNames! {
                            //Remove defect photo to Photo Album
                            let photoDataHelper = PhotoDataHelper()
                            photoDataHelper.updatePhotoDatasByPhotoName(photoName, dataType:PhotoDataType(caseId: "TASK").rawValue, dataRecordId:0)
                        }
                    }
                    
                    //Delete Record From DB
                    if defectItem.recordId > 0 {
                        let taskDataHelper = TaskDataHelper()
                        taskDataHelper.deleteTaskInspDefectDataRecordById(defectItem.recordId!)
                        
                    }
                }
            }
        })
    }
    
    func displayDDList() {
        self.inspectionAreaLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.inspectionAreaLabel.backgroundColor = UIColor.white
        self.inspectionAreaLabel.layer.cornerRadius = 5
        self.inspectionAreaLabel.layer.borderWidth = 0.5
        
        self.inspectionItemLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.inspectionItemLabel.backgroundColor = UIColor.white
        self.inspectionItemLabel.layer.cornerRadius = 5
        self.inspectionItemLabel.layer.borderWidth = 0.5
    }
    
    func showDismissButton() {
        self.dismissButton.isHidden = false
    }
    
    @IBAction func takePhotoFromCell(_ sender: UIButton) {
        
        if self.inspectionAreaLabel.text == "" || self.inspectionItemLabel.text == "" {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Area and Inspect Item"))
            
            return
        }
        
        DispatchQueue.main.async(execute: {
            self.showActivityIndicator()
            
            DispatchQueue.main.async(execute: {
    
                NotificationCenter.default.post(name: Notification.Name(rawValue: "takePhotoFromICCell"), object: nil, userInfo: ["inspElmt":self])
                
                self.removeActivityIndicator()
            })
        })
        
    }
}
