//
//  InputMode01CellView.swift
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


class InputMode01CellView: InputModeICMaster, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var cellIndexLabel: UILabel!
    @IBOutlet weak var inptItemLabel: UILabel!
//    @IBOutlet weak var inptItemInput: UITextField!
    @IBOutlet weak var inptDetailLabel: UILabel!
//    @IBOutlet weak var inptDetailInput: UITextField!
    @IBOutlet weak var cellResultLabel: UILabel!
    @IBOutlet weak var cellResultInput: UITextField!
    @IBOutlet weak var cellRemarksLabel: UILabel!
    @IBOutlet weak var cellRemarksInput: UITextField!
    @IBOutlet weak var cellPAInput: UILabel!
    @IBOutlet weak var cellDefectButton: UIButton!
    @IBOutlet weak var cellDismissButton: UIButton!
    @IBOutlet weak var photoAddedIcon: UIImageView!
    @IBOutlet weak var takePhotoIcon: UIButton!
    @IBOutlet weak var inptDetailItemList: UIButton!
    @IBOutlet weak var inptDetailItemsListBtn: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var showInspectItemDetailButton: UIButton!
    @IBOutlet weak var showInspectDetailButton: UIButton!
    
    @IBOutlet weak var inptItemInputTextView: UITextView!
    @IBOutlet weak var inptDetailInputTextView: UITextView!
    
    var selectValues = [String]()
    var inspectItemKeyValues = [String:Int]()
    //weak var parentView = InputMode01View()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        self.resignFirstResponderByTextField((self.parentVC?.view)!)
        if touch.view!.isKind(of: UITextView().classForCoder) || touch.view!.isKind(of: UITextField().classForCoder) || String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.resignFirstResponderByTextField((self.parentVC?.view)!)
            
        }else {
            self.parentVC?.view.clearDropdownviewForSubviews((self.parentVC?.view)!)
            
        }
        
    }
    
    override func awakeFromNib() {
        cellResultInput.delegate = self
//        inptItemInput.delegate = self
//        inptDetailInput.delegate = self
        inptItemInputTextView.delegate = self
        inptDetailInputTextView.delegate = self
        
        inptItemInputTextView.layer.borderWidth = 0.5
        inptItemInputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inptItemInputTextView.layer.cornerRadius = 5.0
        
        inptDetailInputTextView.layer.borderWidth = 0.5
        inptDetailInputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inptDetailInputTextView.layer.cornerRadius = 5.0
        
        updateLocalizedString()
    }
    
    func updateLocalizedString() {
        self.inptItemLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Area")
        self.inptDetailLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Details")
        self.cellRemarksLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Remarks")
        self.cellResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result")
        self.errorMessageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter defect point info")
    }
    
    override func didMoveToSuperview() {
        if self.parentVC == nil {
            return
        }
        
        self.inspReqCatText = self.cellCatName
        updatePhotoAddediConStatus("",photoTakenIcon: self.photoAddedIcon)
        
        for optInspElmt in self.parentView!.optInspElms {
            guard let nameEn = optInspElmt.elementNameEn, let nameCn = optInspElmt.elementNameCn, let nameFr = optInspElmt.elementNameFr else {continue}
            inspectItemKeyValues[MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: nameEn, .zh: nameCn, .fr: nameFr])] = optInspElmt.elementId
        }
        
        fetchDetailSelectedValues()
        updatePhotoAddediConStatus(self.cellResultInput.text ?? "", photoTakenIcon: self.photoAddedIcon)
//        if inptItemInput.isTruncated() {
//            self.showInspectItemDetailButton.isHidden = false
//        }
    }
    
    func fetchDetailSelectedValues() {
        
        let taskDataHelper = TaskDataHelper()
        self.selectValues = taskDataHelper.getInptElementDetailSelectValueByElementId(self.inspElmId ?? 0)
        
        if selectValues.count > 0 {
            inptDetailItemsListBtn.isHidden = false
        } else {
            inptDetailItemsListBtn.isHidden = true
        }
    }

    @IBAction func defectBtnOnClick(_ sender: UIButton) {
 
        //check if defect input and defect position points nil, then return
        if let value = inptDetailInputTextView.text {
            if inptDetailItemsListBtn.isHidden == false && (value == "" || value.isEmpty) {
                self.errorMessageLabel.isHidden = false
                return
            } else {
                self.errorMessageLabel.isHidden = true
            }
        }
        
        var myParentTabVC:TabBarViewController?
        self.parentVC?.navigationController?.viewControllers.forEach({ vc in
            if let parentVC = vc as? TabBarViewController {
                myParentTabVC = parentVC
            }
        })
        
        let defectListVC = myParentTabVC?.defectListViewController
        
        //add defect cell
        if !isDefectItemAdded(defectListVC!) {
            let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime())
            
            newDfItem?.inputMode = _INPUTMODE01
            newDfItem?.inspElmt = self
            newDfItem?.sectObj = SectObj(sectionId:cellCatIdx, sectionNameEn: self.cellCatName, sectionNameCn: self.cellCatName, sectionNameFr: self.cellCatName,inputMode: _INPUTMODE01)
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
        
        self.parentVC?.performSegue(withIdentifier: "DefectListFromInspectItemSegue", sender:self)
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
            
            (self.parentView as! InputMode01View).inputCells.remove(at: self.cellPhysicalIdx)
            self.removeFromSuperview()
            (self.parentView as! InputMode01View).updateContentView()
            
            //Delete Item From DB
            if self.taskInspDataRecordId > 0 {
                self.deleteTaskPhotos(true)
                //Reload Photos
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil, userInfo: nil)
                
                self.deleteTaskInspDataRecord(self.taskInspDataRecordId!)
            }
            
            //Update Parent OptionElmts
            var releaseInspItems = [String]()
            releaseInspItems.append(self.inptItemInputTextView.text!)
            (self.parentView as! InputMode01View).updateOptionalInspElmts(releaseInspItems,action: "add")
            
            // Delete Relative Defect Items From DB
            self.deleteDefectItems()
        })
    }
    
    func deleteDefectItems() {

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
                if defectItem.recordId > 0 {
                    let taskDataHelper = TaskDataHelper()
                    taskDataHelper.deleteTaskInspDefectDataRecordById(defectItem.recordId!)
                    
                }
            }
        }
    }
    
    func showDismissButton() {
        self.cellDismissButton.isHidden = false
    }
    
    func dropdownHandleFunc(_ textField: UITextField) {
        Cache_Task_On?.didModify = true
        
        if textField == self.inptDetailInputTextView {
            if textField.isTruncated() {
                self.showInspectDetailButton.isHidden = false
            } else {
                self.showInspectDetailButton.isHidden = true
            }
        } else if textField == self.cellResultInput {
            guard let resultText = cellResultInput.text else {return}
            
            self.resultValueId = self.parentView.resultKeyValues[resultText] ?? 0
            updatePhotoAddediConStatus(resultText, photoTakenIcon: self.photoAddedIcon)
            
        }else if textField == self.inptItemInputTextView {
            
            if self.inspAreaText != textField.text! {
                // delete all defect items if not match
                self.deleteDefectItems()
            }
            
            //Update Parent InspElmt
            self.inspAreaText = textField.text!
            
            updateParentOptionElmts()
            
            guard let text = textField.text else {return}
            let inspElementId = self.inspectItemKeyValues[text] ?? 0
            
            if inspElementId != self.inspElmId {
                self.inptDetailInputTextView.text = ""
                self.inspElmId = inspElementId
                let defectDataHelper = DefectDataHelper()
                self.inspPostId = defectDataHelper.getPositionIdByElementId(inspElementId)
                
                fetchDetailSelectedValues()
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePhotoInfo"), object: nil,userInfo: ["inspElmt":self])
        }
    }
    
    func dropdownHandleFuncTextView(_ textView: UITextView) {
        Cache_Task_On?.didModify = true
        
        if textView == self.inptDetailInputTextView {

        } else if textView == self.inptItemInputTextView {
            
            if self.inspAreaText != textView.text! {
                // delete all defect items if not match
                self.deleteDefectItems()
            }
            
            //Update Parent InspElmt
            self.inspAreaText = textView.text!
            
            updateParentOptionElmts()
            
            guard let text = textView.text else {return}
            let inspElementId = self.inspectItemKeyValues[text] ?? 0
            
            if inspElementId != self.inspElmId {
                self.inptDetailInputTextView.text = ""
                self.inspElmId = inspElementId
                let defectDataHelper = DefectDataHelper()
                self.inspPostId = defectDataHelper.getPositionIdByElementId(inspElementId)
                
                fetchDetailSelectedValues()
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updatePhotoInfo"), object: nil,userInfo: ["inspElmt":self])
        }
    }
    
    func updateParentOptionElmts() {
        let usedInspItems = (self.parentView as! InputMode01View).inputCells.filter({ $0.requiredElementFlag == 0 })
        var usedInspItemNames = [String]()
        
        for usedInspItem in usedInspItems {
            usedInspItemNames.append(usedInspItem.inptItemInputTextView.text!)
        }
        
        (self.parentView as! InputMode01View).updateOptionalInspElmts(usedInspItemNames)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let handleFun:(UITextView)->(Void) = dropdownHandleFuncTextView
        
        if textView == self.inptItemInputTextView {
            var listData = [String]()
            for key in self.inspectItemKeyValues.keys {
                listData.append(key)
            }
            
            clearDropdownviewForSubviews(self.parentView!)
            if listData.count > 0 {
                
                textView.showListData(textView, parent: (self.parentView as! InputMode01View).scrollCellView, handle: handleFun, listData: self.sortStringArrayByName(listData) as NSArray, width: self.inptItemInputTextView.frame.size.width*1.2, height:_DROPDOWNLISTHEIGHT, tag: _TAG5)
            }

            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.cellResultInput {
            
            if self.ifExistingSubviewByViewTag(self.parentView, tag: _TAG4) {
                clearDropdownviewForSubviews(self.parentView!)
            }else{
                
                textField.showListData(textField, parent: (self.parentView as! InputMode01View).scrollCellView!, handle: handleFun, listData: self.parentView!.resultValues as NSArray, width: 200, height:250, tag: _TAG4)
            }
            
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.inptDetailInputTextView {
            if textField.isTruncated() {
                self.showInspectDetailButton.isHidden = false
            } else {
                self.showInspectDetailButton.isHidden = true
            }
        }
        return true
    }

    @IBAction func showInptDetailVals(_ sender: UIButton) {
        if self.ifExistingSubviewByViewTag(self.inptDetailInputTextView, tag: _TAG1) {
            clearDropdownviewForSubviews(self.inptDetailInputTextView)
            return
        }
        
        self.inptDetailInputTextView.showListData(self.inptDetailInputTextView, parent: (self.parentView as! InputMode01View).scrollCellView!, handle: dropdownHandleFuncTextView, listData: self.sortStringArrayByName(self.selectValues) as NSArray, width: 500, height:_DROPDOWNLISTHEIGHT, tag: _TAG1, allowManuallyInput: true)
    }
    
    
    @IBAction func takePhotoFromCell(_ sender: UIButton) {
        if self.inptItemInputTextView.text == "" {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Item"))
            
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
    
    @IBAction func showInspectItemDetail(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)
        popoverContent.dataType = _POPOVERNOTITLE
        popoverContent.selectedValue = self.inptItemInputTextView.text ?? ""
        
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
    
    @IBAction func showInspectDetailDidPress(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)
        popoverContent.dataType = _POPOVERNOTITLE
        popoverContent.selectedValue = inptDetailInputTextView.text ?? ""
        
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
