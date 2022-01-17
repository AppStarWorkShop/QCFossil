//
//  DefectListViewController.swift
//  QCFossil
//
//  Created by pacmobile on 6/1/16.
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


class DefectListViewController: PopoverMaster, UITableViewDelegate,  UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var sectionSegmentControl: UISegmentedControl!
    @IBOutlet weak var defectTableView: UITableView!
    @IBOutlet weak var inptNoLabel: UILabel!
    var defectCells = [InputModeDFMaster2]()
    var defectItems = [TaskInspDefectDataRecord]()
    var defectSectionCellsCount = [Int]()
    let sectionWidth = 768
    let sectionHeight = 80
    let cellWidth = 768
    var cellHeight = 225
    var cellHeight2 = 225
    var currentHeaderIdx = 0
    var fromSectionIdx = 0
    var fromItemIdx = 0
    weak var currentCell:InputModeDFMaster2!//InputModeDFMaster()
    var keyboardHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.parent?.parent?.classForCoder == TabBarViewController.self {
            let parentVC = self.parent?.parent as! TabBarViewController
            parentVC.defectListViewController = self
        }
        
        inptNoLabel.text = Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo
        
        defectTableView.delegate = self
        defectTableView.dataSource = self
        defectTableView.rowHeight = 225
        defectTableView.allowsSelection = false
        
        sectionSegmentControl.removeAllSegments()
        sectionSegmentControl.insertSegment(withTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: "All", .zh: "全部", .fr: "All"]), at: 0, animated: true)
        
        var index = 1
        for section in (Cache_Task_On?.inspSections)! {
            sectionSegmentControl.insertSegment(withTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: section.sectionNameEn, .zh: section.sectionNameCn, .fr: section.sectionNameEn]), at: index, animated: true)
            index += 1
        }
        
        sectionSegmentControl.selectedSegmentIndex = 0
        sectionSegmentControl.layer.cornerRadius = 5.0
        sectionSegmentControl.setTitleTextAttributes([NSAttributedString.Key(rawValue: convertFromNSAttributedStringKey(NSAttributedString.Key.font)): UIFont.systemFont(ofSize: 16)], for: UIControl.State())
        sectionSegmentControl.backgroundColor = _FOSSILYELLOWCOLOR
        sectionSegmentControl.tintColor = _FOSSILBLUECOLOR
        sectionSegmentControl.addTarget(self, action: #selector(DefectListViewController.sectionSegmentOnchange), for:.valueChanged)
        
        var sortingDictionary = Dictionary<String, Int>()
        
        for defectItem in (Cache_Task_On?.defectItems)! {
           
            if defectItem.inspElmt.cellCatIdx < 1 && defectItem.inspElmt.cellIdx < 1 {
                for inspSection in (Cache_Task_On?.inspSections)! {
                    //print("inspSectionId: \(inspSection.sectionId), defect secObj sectionId: \(defectItem.sectObj.sectionId)")
                    //if inspSection.sectionId == defectItem.sectObj.sectionId {
                        var idx = 1
                        
                        for inspElmt in inspSection.taskInspDataRecords {
                            
                            var inspectElementId = 0
                            if defectItem.inputMode == _INPUTMODE02 || defectItem.inputMode == _INPUTMODE01 {
                                let dpDataHelper = DPDataHelper()
                                inspectElementId = dpDataHelper.getInspElementIdByInspRecordIdForINPUT02(defectItem.recordId!)
                            }
                            
                            if inspElmt.inspectElementId == defectItem.inspectElementId || inspElmt.inspectElementId == inspectElementId {
                                
                                defectItem.inspElmt.cellCatIdx = inspSection.sectionId!
                                defectItem.inspElmt.cellIdx = idx
                                defectItem.inspElmt.cellCatName = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: inspSection.sectionNameEn, .zh: inspSection.sectionNameCn, .fr: inspSection.sectionNameFr])
                                defectItem.inspElmt.inspCatText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: inspSection.sectionNameEn, .zh: inspSection.sectionNameCn, .fr: inspSection.sectionNameFr])
                                defectItem.inspElmt.inspAreaText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: defectItem.postnObj.positionNameEn, .zh: defectItem.postnObj.positionNameCn, .fr: defectItem.postnObj.positionNameFr])
                                
                                if defectItem.inputMode == _INPUTMODE03 {
                                    defectItem.inspElmt.inspReqCatText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: inspElmt.reqSectObj?.sectionNameEn, .zh: inspElmt.reqSectObj?.sectionNameCn, .fr: inspElmt.reqSectObj?.sectionNameFr])
                                    defectItem.inspElmt.inspItemText = inspElmt.requestElementDesc
                                }else if defectItem.inputMode == _INPUTMODE01{
                                    defectItem.inspElmt.inspAreaText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: inspElmt.elmtObj?.elementNameEn, .zh: inspElmt.elmtObj?.elementNameCn, .fr: inspElmt.elmtObj?.elementNameFr])
                                }
                                else{
                                    defectItem.inspElmt.inspItemText = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: inspElmt.elmtObj?.elementNameEn, .zh: inspElmt.elmtObj?.elementNameCn, .fr: inspElmt.elmtObj?.elementNameFr])
                                }
                            }
                            idx += 1
                        }
                    //}
                }
            }
            
            if (sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"] != nil) {
                sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"] = sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"]! + 1
            }else{
                sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"] = 0
            }
            
            defectItem.cellIdx = sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"]!
            defectItem.sortNum = getSortingNum(defectItem.inspElmt.cellCatIdx, elmtFtor: defectItem.inspElmt.cellIdx, cellFtor: defectItem.cellIdx)
        }
        
        defectItems = (Cache_Task_On?.defectItems)!
        updateContentView()
    }
    
    func getSortingNum(_ secFtor:Int, elmtFtor:Int, cellFtor:Int) ->Int {
        return secFtor*1000000 + elmtFtor*1000 + cellFtor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.disableAllFunsForView(self.view)
        if self.defectTableView.frame.size.height < 860 {
            self.defectTableView.frame.size.height += keyboardHeight - 45
        }
    }
    
    func deleteDefectItemsByInspItem(_ notification:Notification) {
        let inspElmt:Dictionary<String,InputModeICMaster> = notification.userInfo as! Dictionary<String,InputModeICMaster>
        let parentInspElmt = inspElmt["inspElmt"]
        
        /*let index = Cache_Task_On?.defectItems.indexOf({ $0.inspElmt.cellCatIdx == parentInspElmt!.cellCatIdx && $0.inspElmt.cellIdx == parentInspElmt!.cellIdx })
        
        if index != nil {
            Cache_Task_On?.defectItems.removeAtIndex(index!)
        }*/
        
        let defectItemsArray = Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == parentInspElmt!.cellCatIdx && $0.inspElmt.cellIdx == parentInspElmt!.cellIdx })
        
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
    }
    
    func setDefectPhotos(_ inputMode:String, defectCell:InputModeDFMaster, photos:[Photo]) {
        
        for photo in photos {
            if photo.photo?.image != nil {
                defectCell.setSelectedPhoto(photo,needSave: false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @objc func sectionSegmentOnchange(/*sender: UISegmentedControl*/) {
        
        let sectionName = sectionSegmentControl?.titleForSegment(at: (sectionSegmentControl?.selectedSegmentIndex)!)!
        
        if sectionSegmentControl?.selectedSegmentIndex < 1 {
            self.defectItems = (Cache_Task_On?.defectItems)!
        }else{
            self.defectItems = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatName == sectionName }))!
        }
        
        //self.defectItems.forEach({ $0.sortNum = getSortingNum($0.sectObj.sectionId, elmtFtor: $0.inspElmt.elementDbId, cellFtor: $0.cellIdx) })
        
        self.defectItems.sort(by: { $0.sortNum < $1.sortNum })
        self.defectTableView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateContentView()
        var myParentTabVC:TabBarViewController?
        if let vcList = self.navigationController?.viewControllers {
            for vc in vcList {
                if let tabBarVC = vc as? TabBarViewController {
                    myParentTabVC = tabBarVC
                }
            }
        }
        
        myParentTabVC?.setLeftBarItem("< "+MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form"),actionName: "backToTaskDetailFromPADF")
        
        if !self.view.disableFuns(self.view) {
            myParentTabVC?.setRightBarItem(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), actionName: "updateTask:")
        }else{
            myParentTabVC?.setRightBarItem("", actionName: "noAction")
        }
        
        myParentTabVC?.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Findings")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
    }
    
    func updateContentView() {
        
        Cache_Task_On?.defectItems.sort(by: { $0.sortNum < $1.sortNum })
        
        sectionSegmentOnchange()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PhotoAlbumSegueFromDF" {
            
            weak var destVC = segue.destination as? PhotoAlbumViewController
            destVC!.pVC = self.currentCell

        }
    }
    
    func inputCellInit(_ inputMode:String, isHidden:Bool=true, idxLabel:String, iaLabel:String, iiLabel:String, sectionId:Int, itemId:Int, dfDesc:String="",dfQty:String="", criticalQty:String="", majorQty:String="", minorQty:String="", inspItem:AnyObject) ->AnyObject {
        
        switch inputMode {
        case _INPUTMODE01:
            weak var inputCell = InputMode01DefectCellView.loadFromNibNamed("InputMode01DefectCell")
            
            inputCell?.pVC = self
            inputCell?.inspItem = inspItem as? InputMode01CellView
            inputCell?.dismissDescButton.isHidden = isHidden
            inputCell?.indexLabel.text = idxLabel
            inputCell?.iiInput.text = iiLabel
            inputCell?.sectionId = sectionId
            inputCell?.itemId = itemId
            inputCell?.cellIdx = self.defectCells.count
            inputCell?.inputMode = _INPUTMODE01
            inputCell?.idInput.text = dfDesc
            inputCell?.dfQtyInput.text = dfQty
            inputCell?.criticalInput.text = criticalQty
            inputCell?.majorInput.text = majorQty
            inputCell?.minorInput.text = minorQty
            inputCell?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(768), height: CGFloat(320))
            
            return inputCell!
        case _INPUTMODE02:
            weak var inputCell = InputMode02DefectCellView.loadFromNibNamed("InputMode02DefectCell")
            
            inputCell?.pVC = self
            inputCell?.inspItem = inspItem as? InputMode02CellView
            inputCell?.indexLabel.text = idxLabel
            inputCell?.dpInput.text = iaLabel
            inputCell?.dppInput.text = iiLabel
            inputCell?.sectionId = sectionId
            inputCell?.itemId = itemId
            inputCell?.cellIdx = self.defectCells.count
            inputCell?.inputMode = _INPUTMODE02
            inputCell?.dfDescInput.text = dfDesc
            inputCell?.totalInput.text = dfQty
            inputCell?.criticalInput.text = criticalQty
            inputCell?.majorInput.text = majorQty
            inputCell?.minorInput.text = minorQty
            inputCell?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(768), height: CGFloat(320))
            
            return inputCell!
        case _INPUTMODE03:
            weak var inputCell = InputMode03DefectCellView.loadFromNibNamed("InputMode03DefectCell")
            
            inputCell?.pVC = self
            inputCell?.inspItem = inspItem as? InputMode03CellView
            inputCell?.indexLabel.text = idxLabel
            inputCell?.icInput.text = iaLabel
            inputCell?.iiInput.text = iiLabel
            inputCell?.sectionId = sectionId
            inputCell?.itemId = itemId
            inputCell?.cellIdx = self.defectCells.count
            inputCell?.inputMode = _INPUTMODE03
            inputCell?.ddInput.text = dfDesc
            inputCell?.dfQtyInput.text = dfQty
            inputCell?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(768), height: CGFloat(225))
            
            return inputCell!
        case _INPUTMODE04:
            weak var inputCell = InputMode04DefectCellView.loadFromNibNamed("InputMode04DefectCell")
            
            inputCell?.pVC = self
            inputCell?.inspItem = inspItem as? InputMode04CellView
            inputCell?.dismissDescButton.isHidden = isHidden
            inputCell?.indexLabel.text = idxLabel
            inputCell?.iaInput.text = iaLabel
            inputCell?.iiInput.text = iiLabel
            inputCell?.sectionId = sectionId
            inputCell?.itemId = itemId
            inputCell?.cellIdx = self.defectCells.count
            inputCell?.inputMode = _INPUTMODE04
            inputCell?.dfdescInput.text = dfDesc
            inputCell?.dfQtyInput.text = dfQty
            inputCell?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(768), height: CGFloat(225))
            
            return inputCell!
        default:return false as AnyObject
        }
    }
    
    func setCellStyle(_ cellObj:UIView, index:Int, level:Int, idx:Int) {
        let cellOffset = (level-index-1)*cellHeight2 + (index+1)*sectionHeight
        cellObj.frame = CGRect.init(x: 0, y: cellOffset, width: cellWidth, height: cellHeight)
        
        setBackgroundColor(cellObj,idx: idx)
    }
    
    func setBackgroundColor(_ inputCellObj:UIView,idx:Int) {
        if idx%2 == 0 {
            inputCellObj.backgroundColor = _TABLECELL_BG_COLOR1
        }else{
            inputCellObj.backgroundColor = _TABLECELL_BG_COLOR2
        }
    }
    
    func getIdxLabel(_ itemId:Int, sectionId:Int) ->String {
        let result = self.defectItems.filter({$0.inspElmt.cellIdx == itemId && $0.inspElmt.cellCatIdx == sectionId})
        
        return String(result.count)
    }
    
    func addDefectCellWithSection(_ inputMode:String, idxLabel:String, iaLabel:String, iiLabel:String, sectionId:Int, itemId:Int, inspItem:AnyObject, cellIdx:Int = 0) {
        print("add defect cell with section")
        
        let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: (inspItem as! InputModeICMaster).taskInspDataRecordId, refRecordId: 0, inspectElementId: (inspItem as! InputModeICMaster).elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.view.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.view.getCurrentDateTime())
        
        newDfItem?.inputMode = inputMode
        newDfItem?.inspElmt = inspItem as! InputModeICMaster
        newDfItem?.sectObj = SectObj(sectionId:sectionId, sectionNameEn: (inspItem as! InputModeICMaster).cellCatName, sectionNameCn: (inspItem as! InputModeICMaster).cellCatName, sectionNameFr: (inspItem as! InputModeICMaster).cellCatName,inputMode: inputMode)
        newDfItem?.elmtObj = ElmtObj(elementId:itemId,elementNameEn:"", elementNameCn:"", elementNameFr: "", reqElmtFlag: 0)
        newDfItem?.cellIdx = cellIdx
        newDfItem?.sortNum = (newDfItem?.inspElmt.cellCatIdx)!*1000000 + (newDfItem?.inspElmt.cellIdx)!*1000 + cellIdx
        newDfItem?.photoNames = [String]()
        
        Cache_Task_On?.defectItems.append(newDfItem!)
        
        updateContentView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    @IBAction func backButtonOnClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveButtonOnClick(_ sender: UIBarButtonItem) {
        
    }
    
    func duplicate(_ view: AnyObject) ->AnyObject{
        let temArchive = NSKeyedArchiver.archivedData(withRootObject: view)
        let imageview = NSKeyedUnarchiver.unarchiveObject(with: temArchive)
        return imageview! as AnyObject
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (Cache_Task_On?.defectItems.count)!
        return self.defectItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let defectItem = self.defectItems[indexPath.row]
        
        if defectItem.inputMode! == _INPUTMODE02 {
            return 320
        } else if defectItem.inputMode! == _INPUTMODE01 {
            return 320
        }
        
        return 225
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let defectItem = Cache_Task_On?.defectItems[indexPath.row]
        let defectItem = self.defectItems[indexPath.row]
        
        if defectItem.inputMode! == _INPUTMODE04 {
            
            let cellMode4 = tableView.dequeueReusableCell(withIdentifier: "DefectCell", for: indexPath) as! DefectListTableViewCell
            
            cellMode4.pVC = self
            cellMode4.sectionName.text = defectItem.inspElmt.cellCatName
            cellMode4.taskDefectDataRecordId = defectItem.recordId!
            cellMode4.inspItem = defectItem.inspElmt as? InputMode04CellView
            cellMode4.iaInput.text = defectItem.inspElmt.inspAreaText
            cellMode4.iiInput.text = defectItem.inspElmt.inspItemText
            cellMode4.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode4.itemId = defectItem.inspElmt.cellIdx
            cellMode4.cellIdx = defectItem.cellIdx
            cellMode4.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode4.inputMode = _INPUTMODE04
            cellMode4.dfDescInput.text = defectItem.defectDesc!
            cellMode4.dfQtyInput.text = defectItem.defectQtyTotal < 1 ? "" : String(defectItem.defectQtyTotal)
            cellMode4.defectPhoto1.image = nil
            cellMode4.defectPhoto2.image = nil
            cellMode4.defectPhoto3.image = nil
            cellMode4.defectPhoto4.image = nil
            cellMode4.defectPhoto5.image = nil
            cellMode4.dismissPhotoButton1.isHidden = true
            cellMode4.dismissPhotoButton2.isHidden = true
            cellMode4.dismissPhotoButton3.isHidden = true
            cellMode4.dismissPhotoButton4.isHidden = true
            cellMode4.dismissPhotoButton5.isHidden = true
            
            self.view.disableFuns(cellMode4.dismissPhotoButton1)
            self.view.disableFuns(cellMode4.dismissPhotoButton2)
            self.view.disableFuns(cellMode4.dismissPhotoButton3)
            self.view.disableFuns(cellMode4.dismissPhotoButton4)
            self.view.disableFuns(cellMode4.dismissPhotoButton5)
            self.view.disableFuns(cellMode4.addDefectPhotoButton)
            
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                
                var idx = 0
                cellMode4.photoNameAtIndex = ["","","","",""]
                for photoName in defectItem.photoNames! {
         
                    if photoName != "" && idx < 5 {
                        
                        let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName
                        let image = UIImage(contentsOfFile: pathForImage)
                        cellMode4.photoNameAtIndex[idx] = photoName
                        idx += 1
                        
                        if cellMode4.defectPhoto1.image == nil {
                            cellMode4.defectPhoto1.image = image
                            cellMode4.dismissPhotoButton1.isHidden = false
                            
                        }else if cellMode4.defectPhoto2.image == nil {
                            cellMode4.defectPhoto2.image = image
                            cellMode4.dismissPhotoButton2.isHidden = false
                            
                        }else if cellMode4.defectPhoto3.image == nil {
                            cellMode4.defectPhoto3.image = image
                            cellMode4.dismissPhotoButton3.isHidden = false
                            
                        }else if cellMode4.defectPhoto4.image == nil {
                            cellMode4.defectPhoto4.image = image
                            cellMode4.dismissPhotoButton4.isHidden = false
                            
                        }else if cellMode4.defectPhoto5.image == nil {
                            cellMode4.defectPhoto5.image = image
                            cellMode4.dismissPhotoButton5.isHidden = false
                            
                        }
                    }
                }
            }
            
            if indexPath.row % 2 == 0 {
                cellMode4.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode4.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            return cellMode4
          
        }else if defectItem.inputMode! == _INPUTMODE01 {
            let cellMode1 = tableView.dequeueReusableCell(withIdentifier: "DefectCellMode1", for: indexPath) as! DefectListTableViewCellMode1
            
            let inspElement = defectItem.inspElmt as? InputMode01CellView
            
            
            
            cellMode1.pVC = self
            cellMode1.sectionName.text = defectItem.inspElmt.cellCatName
            cellMode1.taskDefectDataRecordId = defectItem.recordId!
            cellMode1.inspItem = inspElement
            cellMode1.icInput.text = defectItem.inspElmt.inspAreaText
            cellMode1.iiInput.text = ""//defectItem.inspElmt.inspectDetail
            cellMode1.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode1.itemId = defectItem.inspElmt.cellIdx
            cellMode1.cellIdx = defectItem.cellIdx
            cellMode1.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode1.inputMode = _INPUTMODE01
            cellMode1.ddInput.text = defectItem.defectDesc!
            cellMode1.majorInput.text = defectItem.defectQtyMajor < 1 ? "0" : String(defectItem.defectQtyMajor)
            cellMode1.minorInput.text = defectItem.defectQtyMinor < 1 ? "0" : String(defectItem.defectQtyMinor)
            cellMode1.criticalInput.text = defectItem.defectQtyCritical < 1 ? "0" : String(defectItem.defectQtyCritical)
            cellMode1.dfQtyInput.text = defectItem.defectQtyTotal < 1 ? "0" : String(defectItem.defectQtyTotal)
            cellMode1.defectPhoto1.image = nil
            cellMode1.defectPhoto2.image = nil
            cellMode1.defectPhoto3.image = nil
            cellMode1.defectPhoto4.image = nil
            cellMode1.defectPhoto5.image = nil
            cellMode1.dismissPhotoButton1.isHidden = true
            cellMode1.dismissPhotoButton2.isHidden = true
            cellMode1.dismissPhotoButton3.isHidden = true
            cellMode1.dismissPhotoButton4.isHidden = true
            cellMode1.dismissPhotoButton5.isHidden = true
//            cellMode1.ddInput.text = defectItem.defectRemarksOptionList
            cellMode1.otherRemarkInput.text = defectItem.othersRemark
            
            let zoneDataHelper = ZoneDataHelper()
            cellMode1.defectDesc1Input.text = zoneDataHelper.getDefectDescValueNameById(defectItem.inspectElementDefectValueId ?? 0)
            cellMode1.defectDesc2Input.text = zoneDataHelper.getCaseValueNameById(defectItem.inspectElementCaseValueId ?? 0)
            
            if var remarkOptionValues = defectItem.defectRemarksOptionList?.components(separatedBy: ",") {
                remarkOptionValues.removeLast()
                let taskDataHelper = TaskDataHelper()
                cellMode1.ddInput.text = taskDataHelper.getRemarksOptionValueById(remarkOptionValues)
            }
            
            let defectDataHelper = DefectDataHelper()
            if Int(defectItem.inspectElementId!) > 0 {
                cellMode1.defectTypeInput.text = defectDataHelper.getInspElementNameById(defectItem.inspectElementId!)
            }else{
                cellMode1.defectTypeInput.text = ""
            }
            
            if let inspectRecordId = defectItem.inspectRecordId {
                let taskInspDataRecord = defectDataHelper.getTaskInspDataRcordNameById(inspectRecordId)
                cellMode1.iiInput.text = taskInspDataRecord?.inspectDetail
                
                if cellMode1.inspItem?.inspPostId == nil || cellMode1.inspItem?.inspPostId < 1 {
                    
                    cellMode1.positionIdOfInspectElement = taskInspDataRecord?.inspectPositionId
                }
            }
            
            self.view.disableFuns(cellMode1.dismissPhotoButton1)
            self.view.disableFuns(cellMode1.dismissPhotoButton2)
            self.view.disableFuns(cellMode1.dismissPhotoButton3)
            self.view.disableFuns(cellMode1.dismissPhotoButton4)
            self.view.disableFuns(cellMode1.dismissPhotoButton5)
            self.view.disableFuns(cellMode1.addDefectPhotoButton)
            
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                
                var idx = 0
                cellMode1.photoNameAtIndex = ["","","","",""]
                for photoName in defectItem.photoNames! {
                    
                    if photoName != "" && idx < 5 {
                        
                        let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName
                        let image = UIImage(contentsOfFile: pathForImage)
                        cellMode1.photoNameAtIndex[idx] = photoName
                        idx += 1
                        
                        if cellMode1.defectPhoto1.image == nil {
                            cellMode1.defectPhoto1.image = image
                            cellMode1.dismissPhotoButton1.isHidden = false
                            
                        }else if cellMode1.defectPhoto2.image == nil {
                            cellMode1.defectPhoto2.image = image
                            cellMode1.dismissPhotoButton2.isHidden = false
                            
                        }else if cellMode1.defectPhoto3.image == nil {
                            cellMode1.defectPhoto3.image = image
                            cellMode1.dismissPhotoButton3.isHidden = false
                            
                        }else if cellMode1.defectPhoto4.image == nil {
                            cellMode1.defectPhoto4.image = image
                            cellMode1.dismissPhotoButton4.isHidden = false
                            
                        }else if cellMode1.defectPhoto5.image == nil {
                            cellMode1.defectPhoto5.image = image
                            cellMode1.dismissPhotoButton5.isHidden = false
                            
                        }
                    }
                }
            }
            
            if indexPath.row % 2 == 0 {
                cellMode1.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode1.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            return cellMode1
            
        }else if defectItem.inputMode! == _INPUTMODE02 {
            
            let cellMode2 = tableView.dequeueReusableCell(withIdentifier: "DefectCellMode2", for: indexPath) as! DefectListTableViewCellMode2
            
            
            cellMode2.pVC = self
            cellMode2.taskDefectDataRecordId = defectItem.recordId!
            cellMode2.inspItem = defectItem.inspElmt as? InputMode02CellView
            cellMode2.sectionName.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: defectItem.sectObj.sectionNameEn, .zh: defectItem.sectObj.sectionNameCn, .fr: defectItem.sectObj.sectionNameFr])
            cellMode2.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode2.itemId = defectItem.inspElmt.cellIdx
            cellMode2.cellIdx = defectItem.cellIdx
            cellMode2.indexInput.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode2.inputMode = _INPUTMODE02
            cellMode2.majorInput.text = defectItem.defectQtyMajor < 1 ? "0" : String(defectItem.defectQtyMajor)
            cellMode2.minorInput.text = defectItem.defectQtyMinor < 1 ? "0" : String(defectItem.defectQtyMinor)
            cellMode2.criticalInput.text = defectItem.defectQtyCritical < 1 ? "0" : String(defectItem.defectQtyCritical)
            cellMode2.totalInput.text = defectItem.defectQtyTotal < 1 ? "0" : String(defectItem.defectQtyTotal)
//            cellMode2.dfDescInput.text = defectItem.defectRemarksOptionList
            cellMode2.otherRemarkInput.text = defectItem.othersRemark
            
            let zoneDataHelper = ZoneDataHelper()
            cellMode2.defectDesc1Input.text = zoneDataHelper.getDefectDescValueNameById(defectItem.inspectElementDefectValueId ?? 0)
            cellMode2.defectDesc2Input.text = zoneDataHelper.getCaseValueNameById(defectItem.inspectElementCaseValueId ?? 0)
            
            if var remarkOptionValues = defectItem.defectRemarksOptionList?.components(separatedBy: ",") {
                remarkOptionValues.removeLast()
                let taskDataHelper = TaskDataHelper()
                cellMode2.dfDescInput.text = taskDataHelper.getRemarksOptionValueById(remarkOptionValues)
            }
            
            if let parentElement = defectItem.inspElmt as? InputMode02CellView {
                cellMode2.dppInput.text = parentElement.cellDPPInput.text
            } else {
                let dpDataHelper = DPDataHelper()
                defectItem.defectpositionPoints = dpDataHelper.getDefectPositionPointsByRecordId(defectItem.inspectRecordId!)
                cellMode2.dppInput.text = defectItem.defectpositionPoints
            }
            
            cellMode2.dtInput.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: defectItem.elmtObj.elementNameEn, .zh: defectItem.elmtObj.elementNameCn, .fr: defectItem.elmtObj.elementNameFr])
            
            let defectDataHelper = DefectDataHelper()
            if Int(defectItem.inspectElementId!) > 0 {
                cellMode2.dtInput.text = defectDataHelper.getInspElementNameById(defectItem.inspectElementId!)
            }else{
                cellMode2.dtInput.text = ""
            }
            
            if let inspectRecordId = defectItem.inspectRecordId {
                let taskInspDataRecord = defectDataHelper.getTaskInspDataRcordNameById(inspectRecordId)
//                cellMode2.dfDescInput.text = taskInspDataRecord?.inspectDetail
                
                if let inspectPositionId = taskInspDataRecord?.inspectPositionId {
                    cellMode2.dpInput.text =  defectDataHelper.getInspPositionNameById(inspectPositionId)
                }else {
                    cellMode2.dpInput.text = ""
                }
            }else {
                cellMode2.dfDescInput.text = ""
                
            }
            
            cellMode2.defectPhoto1.image = nil
            cellMode2.defectPhoto2.image = nil
            cellMode2.defectPhoto3.image = nil
            cellMode2.defectPhoto4.image = nil
            cellMode2.defectPhoto5.image = nil
            cellMode2.dismissPhotoButton1.isHidden = true
            cellMode2.dismissPhotoButton2.isHidden = true
            cellMode2.dismissPhotoButton3.isHidden = true
            cellMode2.dismissPhotoButton4.isHidden = true
            cellMode2.dismissPhotoButton5.isHidden = true
            
            self.view.disableFuns(cellMode2.dismissPhotoButton1)
            self.view.disableFuns(cellMode2.dismissPhotoButton2)
            self.view.disableFuns(cellMode2.dismissPhotoButton3)
            self.view.disableFuns(cellMode2.dismissPhotoButton4)
            self.view.disableFuns(cellMode2.dismissPhotoButton5)
            self.view.disableFuns(cellMode2.addDefectPhotoButton)
            
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                
                var idx = 0
                cellMode2.photoNameAtIndex = ["","","","",""]
                for photoName in defectItem.photoNames! {
                    
                    if photoName != "" && idx < 5 {
                        
                        let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName
                        let image = UIImage(contentsOfFile: pathForImage)
                        cellMode2.photoNameAtIndex[idx] = photoName
                        idx += 1
                        
                        if cellMode2.defectPhoto1.image == nil {
                            cellMode2.defectPhoto1.image = image
                            cellMode2.dismissPhotoButton1.isHidden = false
                            
                        }else if cellMode2.defectPhoto2.image == nil {
                            cellMode2.defectPhoto2.image = image
                            cellMode2.dismissPhotoButton2.isHidden = false
                            
                        }else if cellMode2.defectPhoto3.image == nil {
                            cellMode2.defectPhoto3.image = image
                            cellMode2.dismissPhotoButton3.isHidden = false
                            
                        }else if cellMode2.defectPhoto4.image == nil {
                            cellMode2.defectPhoto4.image = image
                            cellMode2.dismissPhotoButton4.isHidden = false
                            
                        }else if cellMode2.defectPhoto5.image == nil {
                            cellMode2.defectPhoto5.image = image
                            cellMode2.dismissPhotoButton5.isHidden = false
                            
                        }
                    }
                }
            }
            
            if indexPath.row % 2 == 0 {
                cellMode2.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode2.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            return cellMode2
            
            
        }else /*if defectItem!.inputMode! == _INPUTMODE03*/ {
            let cellMode3 = tableView.dequeueReusableCell(withIdentifier: "DefectCellMode3", for: indexPath) as! DefectListTableViewCellMode3
            
            cellMode3.pVC = self
            cellMode3.sectionName.text = defectItem.inspElmt.cellCatName
            cellMode3.taskDefectDataRecordId = defectItem.recordId!
            cellMode3.inspItem = defectItem.inspElmt as? InputMode03CellView
            cellMode3.icInput.text = defectItem.inspElmt.inspReqCatText
            cellMode3.iiInput.text = defectItem.inspElmt.inspItemText
            cellMode3.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode3.itemId = defectItem.inspElmt.cellIdx
            cellMode3.cellIdx = defectItem.cellIdx
            cellMode3.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode3.inputMode = _INPUTMODE03
            cellMode3.ddInput.text = defectItem.defectDesc!
            cellMode3.dfQtyInput.text = defectItem.defectQtyTotal < 1 ? "" : String(defectItem.defectQtyTotal)
            cellMode3.defectPhoto1.image = nil
            cellMode3.defectPhoto2.image = nil
            cellMode3.defectPhoto3.image = nil
            cellMode3.defectPhoto4.image = nil
            cellMode3.defectPhoto5.image = nil
            cellMode3.dismissPhotoButton1.isHidden = true
            cellMode3.dismissPhotoButton2.isHidden = true
            cellMode3.dismissPhotoButton3.isHidden = true
            cellMode3.dismissPhotoButton4.isHidden = true
            cellMode3.dismissPhotoButton5.isHidden = true
            
            self.view.disableFuns(cellMode3.dismissPhotoButton1)
            self.view.disableFuns(cellMode3.dismissPhotoButton2)
            self.view.disableFuns(cellMode3.dismissPhotoButton3)
            self.view.disableFuns(cellMode3.dismissPhotoButton4)
            self.view.disableFuns(cellMode3.dismissPhotoButton5)
            self.view.disableFuns(cellMode3.addDefectPhotoButton)
            
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                
                var idx = 0
                cellMode3.photoNameAtIndex = ["","","","",""]
                for photoName in defectItem.photoNames! {
                    
                    if photoName != "" && idx < 5 {
                        let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName
                        let image = UIImage(contentsOfFile: pathForImage)
                        cellMode3.photoNameAtIndex[idx] = photoName
                        idx += 1
                        
                        if cellMode3.defectPhoto1.image == nil {
                            cellMode3.defectPhoto1.image = image
                            cellMode3.dismissPhotoButton1.isHidden = false
                            
                        }else if cellMode3.defectPhoto2.image == nil {
                            cellMode3.defectPhoto2.image = image
                            cellMode3.dismissPhotoButton2.isHidden = false
                            
                        }else if cellMode3.defectPhoto3.image == nil {
                            cellMode3.defectPhoto3.image = image
                            cellMode3.dismissPhotoButton3.isHidden = false
                            
                        }else if cellMode3.defectPhoto4.image == nil {
                            cellMode3.defectPhoto4.image = image
                            cellMode3.dismissPhotoButton4.isHidden = false
                            
                        }else if cellMode3.defectPhoto5.image == nil {
                            cellMode3.defectPhoto5.image = image
                            cellMode3.dismissPhotoButton5.isHidden = false
                            
                        }
                    }
                }
            }
            
            if indexPath.row % 2 == 0 {
                cellMode3.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode3.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            return cellMode3
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
