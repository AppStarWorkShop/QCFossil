//
//  InputMode03CellView.swift
//  QCFossil
//
//  Created by Yin Huang on 20/1/16.
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


class InputMode03CellView: InputModeICMaster, UITextFieldDelegate {

    @IBOutlet weak var cellIndexLabel: UILabel!
    @IBOutlet weak var icLabel: UILabel!
    @IBOutlet weak var icInput: UITextField!
    @IBOutlet weak var iiLabel: UILabel!
    @IBOutlet weak var iiInput: UITextField!
    @IBOutlet weak var cellResultLabel: UILabel!
    @IBOutlet weak var cellResultInput: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idInput: UITextField!
    @IBOutlet weak var cellPALabel: UILabel!
    @IBOutlet weak var cellPAInput: UILabel!
    @IBOutlet weak var cellDefectButton: UIButton!
    @IBOutlet weak var cellDismissButton: UIButton!
    @IBOutlet weak var cellRemarksLabel: UILabel!
    @IBOutlet weak var cellRemarksInput: UITextField!
    @IBOutlet weak var takePhotoIcon: CustomControlButton! //UIButton!
    @IBOutlet weak var photoTakenIcon: UIImageView!
    
    //weak var parentView = InputMode03View()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        icInput.delegate = self
        cellResultInput.delegate = self
        iiInput.delegate = self
        idInput.delegate = self
        cellRemarksInput.delegate = self
        
        updateLocalizedString()
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
    
    override func didMoveToSuperview() {
        if self.parentVC == nil {
            return
        }
        
        updatePhotoAddediConStatus("",photoTakenIcon: self.photoTakenIcon)
    }
    
    func updateLocalizedString(){
        self.icLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Category")
        self.iiLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Item")
        self.idLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Details")
        self.cellRemarksLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Remarks")
        self.cellResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result")
    }
    
    func dropdownHandleFunc(_ textField: UITextField) {
        
        if textField == cellResultInput {
            guard let resultText = cellResultInput.text else {return}
            
            self.resultValueId = self.parentView.resultKeyValues[resultText] ?? 0
            updatePhotoAddediConStatus(resultText, photoTakenIcon: self.photoTakenIcon)
    
        }else if textField == icInput {
            let taskDataHelper = TaskDataHelper()
            self.requestSectionId = taskDataHelper.getReqSectionIdByName(icInput.text!)
            self.inspReqCatText = icInput.text!
            
            //NSNotificationCenter.defaultCenter().postNotificationName("updateCellInfo", object: nil,userInfo: ["inspElmt":self])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePhotoInfo"), object: nil,userInfo: ["inspElmt":self])
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.iiInput {
            self.inspItemText = textField.text!
            
            //NSNotificationCenter.defaultCenter().postNotificationName("updateCellInfo", object: nil,userInfo: ["inspElmt":self])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePhotoInfo"), object: nil,userInfo: ["inspElmt":self])
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Cache_Task_On?.didModify = true
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //clearDropdownviewForSubviews(self.parentView!)
        if self.ifExistingSubviewByViewTag(self.parentView, tag: _TAG1) {
            clearDropdownviewForSubviews(self.parentView)
            return false
        }
        
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == cellResultInput {
            textField.showListData(textField, parent: (self.parentView as! InputMode03View).scrollCellView!, handle: handleFun, listData: self.parentView!.resultValues as NSArray, width: 200, height: 250, tag:_TAG1)
            Cache_Task_On?.didModify = true
            
            return false
        }else if textField == icInput {
            let inspSecs = Cache_Task_On?.inspSections
            var inspCatList = [String]()
            
            for inspSec in inspSecs! {
                inspCatList.append(MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: inspSec.sectionNameEn, .zh: inspSec.sectionNameCn, .fr: inspSec.sectionNameFr]))
            }
            
            textField.showListData(textField, parent: (self.parentView as! InputMode03View).scrollCellView!, handle: handleFun, listData: inspCatList as NSArray, width: 200, height: 250, tag: _TAG1)
            Cache_Task_On?.didModify = true
            
            return false
        }
        
        return true
    }
    
    @IBAction func defectBtnOnClick(_ sender: UIButton) {
        //add defect cell to defect list
        
        //skip the checking
        /*if self.icInput.text == "" || self.iiInput.text == "" || self.resultValueId < 1 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Category and Inspect Item"))
            return
        }*/
        
        //Save self to DB to get the taskDataRecordId
        //self.saveMyselfToGetId()
        
        var myParentTabVC:TabBarViewController?
        self.parentVC?.navigationController?.viewControllers.forEach({ vc in
            if let parentVC = vc as? TabBarViewController {
                myParentTabVC = parentVC
            }
        })
        
        let defectListVC = myParentTabVC?.defectListViewController
        
        //add section header if not in headerList
  
        
        //add defect cell
        if !isDefectItemAdded(defectListVC!) {
            
            let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime())
        
            newDfItem?.inputMode = _INPUTMODE03
            newDfItem?.inspElmt = self
            newDfItem?.sectObj = SectObj(sectionId:cellCatIdx, sectionNameEn: self.cellCatName, sectionNameCn: self.cellCatName, sectionNameFr: self.cellCatName,inputMode: _INPUTMODE03)
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
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete?"), parentVC:(self.parentView?.parentVC)!, handlerFun: { (action:UIAlertAction!) in
            (self.parentView as! InputMode03View).inputCells.remove(at: self.cellPhysicalIdx)
            self.removeFromSuperview()
            (self.parentView as! InputMode03View).updateContentView()
            
            //Delete Item From DB
            if self.taskInspDataRecordId > 0 {
                self.deleteTaskPhotos(true)
                //Reload Photos
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil, userInfo: nil)
                
                self.deleteTaskInspDataRecord(self.taskInspDataRecordId!)
            }
            
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
    
    func showDismissButton() {
        self.cellDismissButton.isHidden = false
    }

    @IBAction func takePhotoFromCell(_ sender: UIButton) {
        if self.icInput.text == "" || self.iiInput.text == "" {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Category and Inspect Item"))
            
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
            let taskInspDataRecord = TaskInspDataRecord.init(recordId: self.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: self.refRecordId!, inspectSectionId: self.cellCatIdx, inspectElementId: self.inspElmId!, inspectPositionId: self.inspPostId!, inspectPositionDesc: self.idInput.text!, inspectDetail: self.idInput.text, inspectRemarks: self.cellRemarksInput.text, resultValueId: self.resultValueId, requestSectionId: self.requestSectionId!, requestElementDesc: self.iiInput.text!, createUser: (Cache_Inspector?.appUserName)!, createDate: self.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.getCurrentDateTime())
            
            self.taskInspDataRecordId = taskDataHelper.insertTaskInspDataRecord(taskInspDataRecord!)
            
        }
    }
    
}
