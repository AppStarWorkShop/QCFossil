//
//  InspectionDefectList.swift
//  QCFossil
//
//  Created by pacmobile on 5/11/2016.
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


class InspectionDefectList: PopoverMaster, UITextFieldDelegate, UITableViewDelegate,  UITableViewDataSource {
    

    @IBOutlet weak var inspectionTitle1: UILabel!
    @IBOutlet weak var inspectionTitle2: UILabel!
    @IBOutlet weak var inspectDefectTableview: UITableView!
    @IBOutlet weak var inspectionTitle1Input: UILabel!
    @IBOutlet weak var inspectionTitle2Input: UILabel!
    @IBOutlet weak var showDPPDescBtn: UIButton!
    
    var inspItem:InputModeICMaster?
    weak var currentCell:InputModeDFMaster2!
    var defectItems = [TaskInspDefectDataRecord]()
    var defectPositionPointsDesc = ""
    var validateNow = false
    var passValidation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.inspectionTitle1Input.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("\(inspItem?.inspReqCatText != "" ? (inspItem?.inspReqCatText)! : (inspItem?.inspAreaText)!)")
        self.inspectionTitle2Input.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("\((inspItem?.inspItemText)!)")
        
        self.inspectionTitle1.font = UIFont.boldSystemFont(ofSize: 18.0)
        self.inspectionTitle2.font = UIFont.boldSystemFont(ofSize: 18.0)
        self.inspectionTitle1.text = MylocalizedString.sharedLocalizeManager.getLocalizedString( inspItem?.inspCatText != "" ? "Inspection Category" : "Inspection Area")
        self.inspectionTitle2.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Item")

        
        if inspItem?.parentView.InputMode == _INPUTMODE02 {
            self.showDPPDescBtn.isHidden = false
            self.inspectionTitle1Input.text = inspItem?.inspAreaText
            self.defectPositionPointsDesc = (inspItem?.inspItemText)!
        } else if inspItem?.parentView.InputMode == _INPUTMODE01 {
            
            if let inspectItem = inspItem as? InputMode01CellView {
                self.inspectionTitle1.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Area")
                self.inspectionTitle2.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Details")
                self.inspectionTitle1Input.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("\((inspItem?.inspAreaText)!)")
                self.inspectionTitle2Input.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("\((inspectItem.inptDetailInput.text)!)")
            }
        }
        
        //filter all defectItems belong to the inspItem
        var currIdx = 0
        var currSecId = 0
        var currItemId = 0
        Cache_Task_On?.defectItems.sort(by: { $0.inspElmt.cellCatIdx < $1.inspElmt.cellCatIdx && $0.inspElmt.cellIdx < $1.inspElmt.cellIdx })
        let defectItemFilter = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == self.inspItem!.cellCatIdx && $0.inspElmt.cellIdx == self.inspItem!.cellIdx }))!
        
        for defectItem in defectItemFilter {
            
            if defectItem.inspElmt.cellCatIdx == currSecId && defectItem.inspElmt.cellIdx == currItemId {
                defectItem.cellIdx = currIdx
                
            }else{
                currIdx = 0
                defectItem.cellIdx = currIdx
            }
            
            defectItem.sortNum = (self.inspItem?.cellCatIdx)!*1000000 + (self.inspItem!.cellIdx)*1000 + currIdx
            
            currSecId = defectItem.inspElmt.cellCatIdx
            currItemId = (self.inspItem!.cellIdx)
            currIdx += 1
        }
        
        self.inspectDefectTableview.delegate = self
        self.inspectDefectTableview.dataSource = self
        self.inspectDefectTableview.rowHeight = 170
        self.inspectDefectTableview.allowsSelection = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        
        if touch.view!.isKind(of: UITextField().classForCoder) || String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.view.resignFirstResponderByTextField(self.view)
            
        }else {
            self.view.clearDropdownviewForSubviews(self.view)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.disableAllFunsForView(self.view)
        self.inspectDefectTableview.frame.size.height = 823
        
        DispatchQueue.main.async(execute: {
            self.parent?.parent?.view.removeActivityIndicator()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(InspectionDefectList.reloadDefectItems), name: NSNotification.Name(rawValue: "reloadDefectItems"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InspectionDefectList.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InspectionDefectList.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InspectionDefectList.keyboardDidChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.inspectDefectTableview.frame.size.height = 823
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadDefectItems"), object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: self.view.window)
    }
    
    @objc func reloadDefectItems() {
        self.validateNow = true
        updateContentView()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.inspectDefectTableview.frame.size.height >= 823{
                self.inspectDefectTableview.frame.size.height -= keyboardSize.height - 45
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.inspectDefectTableview.frame.size.height = 823
    }
    
    @objc func keyboardDidChange(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.inspectDefectTableview.frame.size.height = 823 - (keyboardSize.height - 45)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        updateContentView()
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("\((inspItem?.cellCatName)!)")
        
        let leftButton=UIBarButtonItem()
        leftButton.title="< "+MylocalizedString.sharedLocalizeManager.getLocalizedString("Back")
        leftButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
        leftButton.style=UIBarButtonItem.Style.plain
        leftButton.target=self
        leftButton.action=#selector(InspectionDefectList.clearDefectItemsBeforeGOBack)
        self.navigationItem.leftBarButtonItem=leftButton
        
        //myParentTabVC.setLeftBarItem("< "+MylocalizedString.sharedLocalizeManager.getLocalizedString("Back"),actionName: "backToTaskDetailFromSignOffPage")
        
        if (Cache_Task_On?.taskStatus != GetTaskStatusId(caseId: "Confirmed").rawValue && Cache_Task_On?.taskStatus != GetTaskStatusId(caseId: "Cancelled").rawValue) || _DEBUG_MODE {
            
            let rightButton = UIBarButtonItem()
            rightButton.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Save")
            rightButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
            rightButton.style = UIBarButtonItem.Style.plain
            rightButton.target = self
            rightButton.action=#selector(updateTask)
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
    }
    
    @objc func updateTask() {
        self.navigationController?.viewControllers.forEach({ vc in
            if let parentVC = vc as? TabBarViewController {
                parentVC.updateTask()
            }
        })
        validation()
    }
    
    @discardableResult
    func validation() ->Bool {
        self.validateNow = true
        self.passValidation = true
        
        self.inspectDefectTableview.reloadData()
        
        for defectItem in self.defectItems {
            
            if defectItem.inputMode == _INPUTMODE01 || defectItem.inputMode == _INPUTMODE02 {
            
                if let defectType = defectItem.defectType {
                    if defectType == "" {
                        return true
                    }
                }
                
                if defectItem.defectQtyCritical < 1 && defectItem.defectQtyMajor < 1 && defectItem.defectQtyMinor < 1 && defectItem.defectQtyTotal < 1 {
                    self.passValidation = false
                }
            }
        }
        
        return self.passValidation
    }
    
    @objc func clearDefectItemsBeforeGOBack() {
        
        if !validation() {
            return
        }
        
        var myParentTabVC:TabBarViewController?
        self.navigationController?.viewControllers.forEach({ vc in
            if let parentVC = vc as? TabBarViewController {
                myParentTabVC = parentVC
            }
        })

        myParentTabVC?.handler = nil
        
        let defectDataHelper = DefectDataHelper()
        let defectItemArray = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == self.inspItem!.cellCatIdx && $0.inspElmt.cellIdx == self.inspItem!.cellIdx }))!
        
        for defectItem in defectItemArray {
            
            if defectItem.defectDesc == "" && defectItem.defectQtyCritical<1 && defectItem.defectQtyMajor<1 && defectItem.defectQtyMinor<1 && defectItem.defectQtyTotal<1 {
                
                var noPhotos = true
                for name in defectItem.photoNames! {
                    if name != "" {
                        noPhotos = false
                        break
                    }
                }
                
                if noPhotos {
                    let index = Cache_Task_On?.defectItems.index(where: { $0.inspElmt.cellCatIdx == defectItem.inspElmt.cellCatIdx && $0.inspElmt.cellIdx == defectItem.inspElmt.cellIdx && $0.cellIdx == defectItem.cellIdx })
                
                    defectDataHelper.deleteDefectItemById(defectItem.recordId!)
                    Cache_Task_On?.defectItems.remove(at: index!)
                }else{
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Defect Qty."))
                    return
                }
                
            }else if defectItem.defectQtyMajor < 1 && defectItem.defectQtyMinor < 1 && defectItem.defectQtyTotal < 1 && defectItem.defectQtyCritical < 1 {
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Defect Qty."))
                return
            }
        }
        
        self.navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "PhotoAlbumSegueFromIDF" {
            
            weak var destVC = segue.destination as? PhotoAlbumViewController
            destVC!.pVC = self.currentCell
            destVC?.loadPhotos()
        }
     }
    
    func updateContentView() {
        
        //Cache_Task_On?.defectItems.sortInPlace({ $0.sortNum < $1.sortNum })
        self.defectItems = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == inspItem!.cellCatIdx && $0.inspElmt.cellIdx == inspItem!.cellIdx }))!//(Cache_Task_On?.defectItems)!
        self.defectItems.sort(by: { $0.sortNum < $1.sortNum && $0.cellIdx < $1.cellIdx })
        
        var cellIdx = 0
        self.defectItems.forEach({ $0.cellIdx = cellIdx; $0.sortNum = (self.inspItem?.cellCatIdx)!*1000000 + (self.inspItem!.cellIdx)*1000 + cellIdx; cellIdx += 1 })
        
        self.defectItems.sort(by: { $0.sortNum > $1.sortNum })
        
        self.inspectDefectTableview?.reloadData()
    }
    
    @IBAction func addDefectCell(_ sender: UIButton) {
        let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: inspItem!.taskInspDataRecordId, refRecordId: 0, inspectElementId: inspItem!.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.view.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.view.getCurrentDateTime())
        
        newDfItem?.inputMode = inspItem?.parentView?.InputMode
        newDfItem?.inspElmt = inspItem!
        newDfItem?.sectObj = SectObj(sectionId:inspItem!.cellCatIdx, sectionNameEn: inspItem!.cellCatName, sectionNameCn: inspItem!.cellCatName,inputMode: (inspItem?.parentView?.InputMode)!)
        newDfItem?.elmtObj = ElmtObj(elementId:inspItem!.elementDbId,elementNameEn:"", elementNameCn:"", reqElmtFlag: 0)
        //newDfItem!.inspectElementId = 0
        
        let cellIdx = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == inspItem!.cellCatIdx && $0.inspElmt.cellIdx == inspItem!.cellIdx }))!
        newDfItem?.cellIdx = cellIdx.count
        newDfItem?.sortNum = (self.inspItem!.cellCatIdx)*1000000 + (self.inspItem!.cellIdx)*1000 + cellIdx.count
        
        newDfItem?.photoNames = [String]()
        
        let taskDataHelper = TaskDataHelper()
        newDfItem?.recordId = taskDataHelper.updateInspDefectDataRecord(newDfItem!)
        
        self.validateNow = false
        
        if newDfItem?.recordId > 0 {
            Cache_Task_On?.defectItems.append(newDfItem!)
            
            updateContentView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.defectItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defectItem = self.defectItems[indexPath.row]
        
        if defectItem.inputMode! == _INPUTMODE04 {
            self.inspectDefectTableview.rowHeight = 250
            let cellMode4 = tableView.dequeueReusableCell(withIdentifier: "InspDefectCellMode4", for: indexPath) as! InspectionDefectTableViewCellMode4
            
            cellMode4.pVC = self
            cellMode4.taskDefectDataRecordId = defectItem.recordId!
            cellMode4.inspItem = defectItem.inspElmt as? InputMode04CellView
            cellMode4.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode4.itemId = defectItem.inspElmt.cellIdx
            cellMode4.cellIdx = defectItem.cellIdx
            cellMode4.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode4.inputMode = _INPUTMODE04
            cellMode4.defectDescInput.text = defectItem.defectDesc! //+ "SortNum: \(defectItem.sortNum) ElementId: \(defectItem.inspElmt.cellIdx)"
            cellMode4.defectQtyInput.text = defectItem.defectQtyTotal < 1 ? "" : String(defectItem.defectQtyTotal)
            
            cellMode4.refreshImageviews()
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                cellMode4.showDefectPhotoByName(defectItem.photoNames!)
            }
            
            if indexPath.row % 2 == 0 {
                cellMode4.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode4.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            
            
            return cellMode4
            
        }else if defectItem.inputMode! == _INPUTMODE02 {
            self.inspectDefectTableview.rowHeight = 320
            let cellMode2 = tableView.dequeueReusableCell(withIdentifier: "InspDefectCellMode2", for: indexPath) as! InspectionDefectTableViewCellMode2
            
            cellMode2.pVC = self
            cellMode2.taskDefectDataRecordId = defectItem.recordId!
            cellMode2.inspItem = defectItem.inspElmt as? InputMode02CellView
            cellMode2.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode2.itemId = defectItem.inspElmt.cellIdx
            cellMode2.cellIdx = defectItem.cellIdx
            cellMode2.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode2.inputMode = _INPUTMODE02
            //cellMode2.defectDescInput.text = defectItem.defectDesc!
            cellMode2.defectMajorQtyInput.text = defectItem.defectQtyMajor < 1 ? "0" : String(defectItem.defectQtyMajor)
            cellMode2.defectMinorQtyInput.text = defectItem.defectQtyMinor < 1 ? "0" : String(defectItem.defectQtyMinor)
            cellMode2.defectCriticalQtyInput.text = defectItem.defectQtyCritical < 1 ? "0" : String(defectItem.defectQtyCritical)
            cellMode2.defectTotalQtyInput.text = defectItem.defectQtyTotal < 1 ? "0" : String(defectItem.defectQtyTotal)
            cellMode2.defectPPIInput.text = self.defectPositionPointsDesc
            cellMode2.inspectElementId = defectItem.inspectElementId
//            cellMode2.defectRemarkOptionList.text = defectItem.defectRemarksOptionList
            cellMode2.defectRemarksOptionList = defectItem.defectRemarksOptionList
            cellMode2.othersRemarkInput.text = defectItem.othersRemark
            
            let zoneDataHelper = ZoneDataHelper()
            cellMode2.defectDesc1Input.text = zoneDataHelper.getDefectDescValueNameById(defectItem.inspectElementDefectValueId ?? 0)
            cellMode2.defectDesc2Input.text = zoneDataHelper.getCaseValueNameById(defectItem.inspectElementCaseValueId ?? 0)
            
            let taskDataHelper = TaskDataHelper()
            let remarkValues = taskDataHelper.getRemarksOptionList("\(cellMode2.inspItem?.resultValueId)")
            remarkValues.forEach({ value in
                cellMode2.remarkKeyValue[_ENGLISH ? value.valueNameEn ?? "": value.valueNameCn ?? ""] = value.valueId
            })
            
            cellMode2.defectRemarkOptionList.showMultiDropdownValues(defectItem.defectRemarksOptionList ?? "", textField: cellMode2.defectRemarkOptionList, keyValues: cellMode2.remarkKeyValue)
            
            var myRemarkValues = cellMode2.defectRemarkOptionList.text?.characters.split{$0 == ","}.map(String.init)
            if let values = myRemarkValues {
                for value in values {
                    let trimValue = value.trimmingCharacters(
                        in: CharacterSet.whitespacesAndNewlines
                    )
                    
                    if cellMode2.remarkKeyValue[trimValue] == nil {
                        myRemarkValues = myRemarkValues!.filter { $0 != value }
                    }
                }
            }
            
            if let values = myRemarkValues {
                cellMode2.defectRemarkOptionList.text = values.joined(separator: ",")
            }
            
            if Int(defectItem.inspectElementId!) > 0 {
                let defectDataHelper = DefectDataHelper()
                
                cellMode2.defectTypeInput.text = defectDataHelper.getInspElementNameById(defectItem.inspectElementId ?? 0)
                defectItem.defectType = cellMode2.defectTypeInput.text
                
                let zoneDataHelper = ZoneDataHelper()
                cellMode2.defectValues = zoneDataHelper.getDefectValuesByElementId(defectItem.inspectElementId ?? 0)
                cellMode2.caseValues = zoneDataHelper.getCaseValuesByElementId(defectItem.inspectElementId ?? 0)
                
                if cellMode2.defectValues?.count < 1 {
                    cellMode2.defectDesc1Input.backgroundColor = _GREY_BACKGROUD
                    cellMode2.defectDesc1ListIcon.isHidden = true
                } else {
                    cellMode2.defectDesc1Input.backgroundColor = UIColor.white
                    cellMode2.defectDesc1ListIcon.isHidden = false
                }
                
                if cellMode2.caseValues?.count < 1 {
                    cellMode2.defectDesc2Input.backgroundColor = _GREY_BACKGROUD
                    cellMode2.defectDesc2ListIcon.isHidden = true
                } else {
                    cellMode2.defectDesc2Input.backgroundColor = UIColor.white
                    cellMode2.defectDesc2ListIcon.isHidden = false
                }
                
            }else{
                cellMode2.defectTypeInput.text = ""
                defectItem.defectType = ""
                
                cellMode2.defectDesc1Input.backgroundColor = _GREY_BACKGROUD
                cellMode2.defectDesc1ListIcon.isHidden = true
                
                cellMode2.defectDesc2Input.backgroundColor = _GREY_BACKGROUD
                cellMode2.defectDesc2ListIcon.isHidden = true
            }
            
            cellMode2.refreshImageviews()
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                cellMode2.showDefectPhotoByName(defectItem.photoNames!)
            }
            
            if indexPath.row % 2 == 0 {
                cellMode2.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode2.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            if validateNow {
                guard let defectTotalQty = Int(cellMode2.defectTotalQtyInput.text!), let defectCriticalQty = Int(cellMode2.defectCriticalQtyInput.text!), let defectMajorQty = Int(cellMode2.defectMajorQtyInput.text!), let defectMinorQty = Int(cellMode2.defectMinorQtyInput.text!) else {return cellMode2}
                
                if defectTotalQty < 1 && defectCriticalQty < 1 && defectMajorQty < 1 && defectMinorQty < 1 {
                    cellMode2.errorMessageLabel.isHidden = false
                } else {
                    cellMode2.errorMessageLabel.isHidden = true
                }
            }
            
            return cellMode2
         
        }else if defectItem.inputMode! == _INPUTMODE01 {
            self.inspectDefectTableview.rowHeight = 320
            let cellMode1 = tableView.dequeueReusableCell(withIdentifier: "InspDefectCellMode1", for: indexPath) as! InspectionDefectTableViewCellMode1
            
            cellMode1.pVC = self
            cellMode1.taskDefectDataRecordId = defectItem.recordId!
            cellMode1.inspItem = defectItem.inspElmt as? InputMode01CellView
            cellMode1.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode1.itemId = defectItem.inspElmt.cellIdx
            cellMode1.cellIdx = defectItem.cellIdx
            cellMode1.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode1.inputMode = _INPUTMODE01
            cellMode1.defectQtyInput.text = defectItem.defectQtyTotal < 1 ? "0" : String(defectItem.defectQtyTotal)
            cellMode1.majorInput.text = defectItem.defectQtyMajor < 1 ? "0" : String(defectItem.defectQtyMajor)
            cellMode1.minorInput.text = defectItem.defectQtyMinor < 1 ? "0" : String(defectItem.defectQtyMinor)
            cellMode1.criticalInput.text = defectItem.defectQtyCritical < 1 ? "0" : String(defectItem.defectQtyCritical)
            cellMode1.inspectElementId = defectItem.inspectElementId
//            cellMode1.defectDescInput.text = defectItem.defectRemarksOptionList
            cellMode1.defectRemarksOptionList = defectItem.defectRemarksOptionList
            cellMode1.othersRemarkInput.text = defectItem.othersRemark
            
            let zoneDataHelper = ZoneDataHelper()
            cellMode1.defectDesc1Input.text = zoneDataHelper.getDefectDescValueNameById(defectItem.inspectElementDefectValueId ?? 0)
            cellMode1.defectDesc2Input.text = zoneDataHelper.getCaseValueNameById(defectItem.inspectElementCaseValueId ?? 0)
            
            let defectDataHelper = DefectDataHelper()
            let dfElms = defectDataHelper.getDefectObjectsByPositionId(cellMode1.inspItem?.inspPostId ?? 0)
            dfElms.forEach({ dfElm in
                cellMode1.defectTypeKeyValues[_ENGLISH ? dfElm.valueNameEn ?? "": dfElm.valueNameCn ?? ""] = dfElm.valueId
            })
            
            let taskDataHelper = TaskDataHelper()
            let remarkValues = taskDataHelper.getRemarksOptionList(String(cellMode1.inspItem!.resultValueId))
            remarkValues.forEach({ value in
                cellMode1.remarkKeyValue[_ENGLISH ? value.valueNameEn ?? "": value.valueNameCn ?? ""] = value.valueId
            })
            
            cellMode1.defectDescInput.showMultiDropdownValues(defectItem.defectRemarksOptionList ?? "", textField: cellMode1.defectDescInput, keyValues: cellMode1.remarkKeyValue)
            
            var myRemarkValues = cellMode1.defectDescInput.text?.characters.split{$0 == ","}.map(String.init)
            if let values = myRemarkValues {
                for value in values {
                    let trimValue = value.trimmingCharacters(
                        in: CharacterSet.whitespacesAndNewlines
                    )
                    
                    if cellMode1.remarkKeyValue[trimValue] == nil {
                        myRemarkValues = myRemarkValues!.filter { $0 != value }
                    }
                }
            }
            
            if let values = myRemarkValues {
                cellMode1.defectDescInput.text = values.joined(separator: ",")
            }
            
            if Int(defectItem.inspectElementId!) > 0 {
                let defectDataHelper = DefectDataHelper()
                let defectTypeObject = defectDataHelper.getInspElementValueById(defectItem.inspectElementId ?? 0)
                cellMode1.defectTypeInput.text = _ENGLISH ? defectTypeObject.valueNameEn : defectTypeObject.valueNameCn
                defectItem.defectType = cellMode1.defectTypeInput.text
                
                let zoneDataHelper = ZoneDataHelper()
                cellMode1.defectValues = zoneDataHelper.getDefectValuesByElementId(defectTypeObject.valueId ?? 0)
                cellMode1.caseValues = zoneDataHelper.getCaseValuesByElementId(defectTypeObject.valueId ?? 0)
                
                if cellMode1.defectValues?.count < 1 {
                    cellMode1.defectDesc1Input.backgroundColor = _GREY_BACKGROUD
                    cellMode1.defectDesc1ListIcon.isHidden = true
                } else {
                    cellMode1.defectDesc1Input.backgroundColor = UIColor.white
                    cellMode1.defectDesc1ListIcon.isHidden = false
                }
                
                if cellMode1.caseValues?.count < 1 {
                    cellMode1.defectDesc2Input.backgroundColor = _GREY_BACKGROUD
                    cellMode1.defectDesc2ListIcon.isHidden = true
                } else {
                    cellMode1.defectDesc2Input.backgroundColor = UIColor.white
                    cellMode1.defectDesc2ListIcon.isHidden = false
                }

            }else{
                cellMode1.defectTypeInput.text = ""
                defectItem.defectType = ""
                
                cellMode1.defectDesc1Input.backgroundColor = _GREY_BACKGROUD
                cellMode1.defectDesc1ListIcon.isHidden = true
                
                cellMode1.defectDesc2Input.backgroundColor = _GREY_BACKGROUD
                cellMode1.defectDesc2ListIcon.isHidden = true

            }
            
            cellMode1.refreshImageviews()
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                cellMode1.showDefectPhotoByName(defectItem.photoNames!)
            }
            
            if indexPath.row % 2 == 0 {
                cellMode1.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode1.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            if validateNow {
                guard let defectTotalQty = Int(cellMode1.defectQtyInput.text!), let defectCriticalQty = Int(cellMode1.criticalInput.text!), let defectMajorQty = Int(cellMode1.majorInput.text!), let defectMinorQty = Int(cellMode1.minorInput.text!) else {return cellMode1}
                
                if defectTotalQty < 1 && defectCriticalQty < 1 && defectMajorQty < 1 && defectMinorQty < 1 {
                    cellMode1.errorMessageLabel.isHidden = false
                } else {
                    cellMode1.errorMessageLabel.isHidden = true
                }
            }
            
            return cellMode1
        
        }else {
            self.inspectDefectTableview.rowHeight = 170
            let cellMode3 = tableView.dequeueReusableCell(withIdentifier: "InspDefectCellMode3", for: indexPath) as! InspectionDefectTableViewCellMode3
            
            cellMode3.pVC = self
            cellMode3.taskDefectDataRecordId = defectItem.recordId!
            cellMode3.inspItem = defectItem.inspElmt as? InputMode03CellView
            cellMode3.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode3.itemId = defectItem.inspElmt.cellIdx
            cellMode3.cellIdx = defectItem.cellIdx
            cellMode3.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode3.inputMode = _INPUTMODE03
            cellMode3.defectDescInput.text = defectItem.defectDesc! //+ "SortNum: \(defectItem.sortNum) ElementId: \(defectItem.inspElmt.cellIdx)"
            cellMode3.defectQtyInput.text = defectItem.defectQtyTotal < 1 ? "" : String(defectItem.defectQtyTotal)
            
            cellMode3.refreshImageviews()
            
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                cellMode3.showDefectPhotoByName(defectItem.photoNames!)
            }
            
            if indexPath.row % 2 == 0 {
                cellMode3.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode3.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            return cellMode3
        }
    }
    
    @IBAction func showDPP(_ sender: UIButton){
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//        popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
        popoverContent.dataType = _DEFECTPPDESC
        popoverContent.selectedValue = defectPositionPointsDesc
        
        let nav = CustomNavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.tintColor = UIColor.black
        
        let popover = nav.popoverPresentationController
        popover!.delegate = sender.parentVC as! PopoverMaster
        popover!.sourceView = sender
        popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY,width: sender.frame.size.width,height: sender.frame.size.height)
        
        sender.parentVC!.present(nav, animated: true, completion: nil)
    }
}
