//
//  InputMode02View.swift
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


class InputMode02View: InputModeSCMaster {
    
    @IBOutlet weak var scrollCellView: UIScrollView!
    @IBOutlet weak var applyToAllButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var result: UITextField!
    @IBOutlet weak var addCellButton: UIButton!
    var inputCells = [InputMode02CellView]()
    var defectPosits = [PositObj]()
    var defectPositPoints = [PositPointObj]()
    let inputCellCount = 6
    let cellWidth = Int(_DEVICE_WIDTH)
    let cellHeight = 160
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        
        if inputCellCount<1 {
            return
        }

        NSLayoutConstraint.activate([
            scrollCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
            
        NotificationCenter.default.addObserver(self, selector: #selector(parentScrollEnable), name: NSNotification.Name(rawValue: "parentScrollEnable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(parentScrollDisable), name: NSNotification.Name(rawValue: "parentScrollDisable"), object: nil)
    }
    
    @objc func parentScrollEnable() {
        scrollCellView.isScrollEnabled = true
    }
    
    @objc func parentScrollDisable() {
        scrollCellView.isScrollEnabled = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "parentScrollEnable"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "parentScrollDisable"), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        
        if touch.view!.isKind(of: UITextField().classForCoder) || String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.resignFirstResponderByTextField(self)
            
        }else {
            self.clearDropdownviewForSubviews(self)
            
        }
    }
    
    override func didMoveToSuperview() {
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            return
        }
        self.applyToAllButton.addTarget(self, action: #selector(applyRstToAll), for: UIControl.Event.touchUpInside)
        
        //Init Defect Position Items
        let dpDataHelper = DPDataHelper()
        self.defectPosits = dpDataHelper.getDefectPositions((inspSection?.sectionId)!)
        self.defectPositPoints = dpDataHelper.getAllDefectPositPoints()
        
        let photoDataHelper = PhotoDataHelper()
        var idx = 1
        
        for taskInspDataRecord in (inspSection?.taskInspDataRecords)! {
            //if taskInspDataRecord.postnObj?.positionId > 0 {
            
            let dfPositPoints = dpDataHelper.getDefectPositionPointsByRecordId(taskInspDataRecord.recordId!)
            let inputCell = inputCellInit(idx, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(idx),dpText: MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: taskInspDataRecord.postnObj?.positionNameEn, .zh: taskInspDataRecord.postnObj?.positionNameCn, .fr: taskInspDataRecord.postnObj?.positionNameFr]), dpDescText: taskInspDataRecord.inspectPositionDesc!, dppText: dfPositPoints, dismissBtnHidden: true, elementDbId: (taskInspDataRecord.elmtObj?.elementId)!, refRecordId: taskInspDataRecord.refRecordId!, inspElmId: (taskInspDataRecord.elmtObj?.elementId)!, inspPostId: taskInspDataRecord.postnObj!.positionId, resultValueObj:taskInspDataRecord.resultObj!, taskInspDataRecordId:taskInspDataRecord.recordId!, inspectPositionZoneValueId: taskInspDataRecord.inspectPositionZoneValueId ?? 0)
            
            inputCell.photoAdded = photoDataHelper.checkPhotoAddedByInspDataRecordId(taskInspDataRecord.recordId!)
            inputCell.updatePhotoNeededStatus((taskInspDataRecord.resultObj?.resultValueNameEn)!)
            
            let defectItems = Cache_Task_On!.defectItems.filter({$0.taskId == taskInspDataRecord.taskId && $0.inspectRecordId == taskInspDataRecord.recordId})
            
            for defectItem in defectItems {
                defectItem.inspElmt = inputCell
            }
            
            inputCells.append(inputCell)
            //}
            
            idx += 1
        }
        
        self.updateContentView()
        self.initSegmentControlView(self.InputMode,apyToAllBtn: self.applyToAllButton)
    }
    
    @objc func applyRstToAll() {
        
        self.alertConfirmView("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Apply to All"))?",parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in

        
            let taskDataHelper = TaskDataHelper()
            let resultValueId = taskDataHelper.getResultValueIdByResultValue(self.resultForAll, prodTypeId: (Cache_Task_On?.prodTypeId)!, inspTypeId: (Cache_Task_On?.inspectionTypeId)!)
        
            for cell in self.inputCells {
                cell.cellResultInput.text = self.resultForAll
                cell.updatePhotoAddediConStatus(self.resultForAll,photoTakenIcon: cell.photoAddedIcon)
                cell.resultValueId = resultValueId
            }
        
            Cache_Task_On?.didModify = true
            self.updateContentView()
            
        })
    }
    
    func updateContentView() {
        if inputCells.count > 0 {
            
        
        
        for index in 0...inputCells.count-1 {
            let cell = inputCells[index]
            cell.updateCellIndex(cell,index: index)
            cell.cellIndexLabel.text = String(cell.cellIdx)
            cell.frame = CGRect.init(x: 0, y: index * cellHeight, width: cellWidth, height: cellHeight)
            
            if index % 2 == 0 {
                cell.backgroundColor = _TABLECELL_BG_COLOR1
            }else{
                cell.backgroundColor = _TABLECELL_BG_COLOR2
            }
            
            self.scrollCellView.addSubview(inputCells[cell.cellPhysicalIdx])
        }
        }
        
        self.addCellButton.frame = CGRect.init(x: 8, y: inputCells.count*cellHeight+10, width: 50, height: 50)
        self.scrollCellView.addSubview(self.addCellButton)
        resizeScrollView(CGSize.init(width: _DEVICE_WIDTH, height: CGFloat(inputCells.count*cellHeight+600)))
    }
    
    func resizeScrollView(_ size:CGSize) {
        self.scrollCellView.contentSize = size
    }
    
    func inputCellInit(_ index:Int, sectionId:Int, sectionName:String, idxLabelText:String, dpText:String, dpDescText:String, dppText:String, dismissBtnHidden:Bool, elementDbId:Int, refRecordId:Int, inspElmId:Int, inspPostId:Int, resultValueObj:ResultValueObj=ResultValueObj(resultValueId:0,resultValueNameEn: "",resultValueNameCn: "", resultValueNameFr: ""), taskInspDataRecordId:Int=0, inspectPositionZoneValueId:Int=0) -> InputMode02CellView {
        
        let inputCellViewObj = InputMode02CellView.loadFromNibNamed("InputMode02Cell")
        inputCellViewObj?.frame.size = CGSize(width: _DEVICE_WIDTH, height: 160)
        inputCellViewObj?.parentView = self
        inputCellViewObj?.cellIndexLabel.text = idxLabelText
        inputCellViewObj?.cellCatIdx = sectionId
        inputCellViewObj?.cellCatName = sectionName
        inputCellViewObj?.cellIdx = index
        inputCellViewObj?.cellPhysicalIdx = index-1
        inputCellViewObj?.elementDbId = elementDbId
        inputCellViewObj?.dpInput.text = dpText
        inputCellViewObj?.dpDescInput.text = dpDescText
        inputCellViewObj?.cellDPPInput.text = dppText
        inputCellViewObj?.cellResultInput.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: resultValueObj.resultValueNameEn, .zh: resultValueObj.resultValueNameCn, .fr: resultValueObj.resultValueNameFr])
        
        let zoneDataHelper = ZoneDataHelper()
        inputCellViewObj?.defectZoneInput.text = zoneDataHelper.getZoneValueNameById(inspectPositionZoneValueId)
        inputCellViewObj?.inspectZoneValueId = inspectPositionZoneValueId
        
        //for Save DB
        inputCellViewObj?.refRecordId = refRecordId
        inputCellViewObj?.inspElmId = inspElmId
        inputCellViewObj?.inspPostId = inspPostId
        inputCellViewObj?.resultValueId = resultValueObj.resultValueId
        inputCellViewObj?.taskInspDataRecordId = taskInspDataRecordId
        inputCellViewObj?.inspReqCatText = sectionName
        inputCellViewObj?.inspAreaText = dpText
        inputCellViewObj?.inspItemText = dppText
        
        inputCellViewObj?.zoneValues = zoneDataHelper.getZoneValuesByPositionId(inspPostId)
        
        let defectDataHelper = DefectDataHelper()
        inputCellViewObj?.myDefectPositPoints = defectDataHelper.getDefectTypeByTaskInspectDataRecordId(taskInspDataRecordId)
        
        let parentPositObjs = self.defectPosits.filter({$0.positionNameFr == dpText || $0.positionNameEn == dpText || $0.positionNameCn == dpText})
        if parentPositObjs.count < 1 {
            inputCellViewObj?.cellDPPInput.backgroundColor = _GREY_BACKGROUD
            inputCellViewObj?.defectZoneListIcon.isHidden = true
        } else {
            inputCellViewObj?.cellDPPInput.backgroundColor = UIColor.white
            inputCellViewObj?.defectZoneListIcon.isHidden = false
        }
        
        if inputCellViewObj?.zoneValues?.count < 1 {
            inputCellViewObj?.defectZoneInput.backgroundColor = _GREY_BACKGROUD
            inputCellViewObj?.defectPositionPointIcon.isHidden = true
        } else {
            inputCellViewObj?.defectZoneInput.backgroundColor = UIColor.white
            inputCellViewObj?.defectPositionPointIcon.isHidden = false
        }
        
        if !dismissBtnHidden {
            inputCellViewObj?.showDismissButton()
        }
        
        return inputCellViewObj!
    }
    
    @IBAction func addCellBtnOnClick(_ sender: UIButton) {
        NSLog("Add Cell")
        
        let dpDataHelper = DPDataHelper()
        let elementId = dpDataHelper.getElementIdBySectionIdForINPUT02(inspSection!.sectionId!)
        
        let inputCell = inputCellInit(inputCells.count+1, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(inputCells.count+1),dpText: "", dpDescText: "", dppText: "", dismissBtnHidden: false, elementDbId: elementId, refRecordId: 0, inspElmId: elementId, inspPostId: 0)
        
        inputCell.saveMyselfToGetId()
        
        inputCells.append(inputCell)
        
        self.updateContentView()
    }
}
