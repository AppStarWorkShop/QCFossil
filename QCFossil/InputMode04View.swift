//
//  InputMode04View.swift
//  QCFossil
//
//  Created by pacmobile on 30/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class InputMode04View: InputModeSCMaster{

    @IBOutlet weak var apyToAllBtn: UIButton!
    @IBOutlet weak var addCellButton: UIButton!
    @IBOutlet weak var ScrollCellView: UIScrollView!
    
    @IBOutlet weak var inspAreaLabel: UILabel!
    @IBOutlet weak var inspItemLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    var inputCells = [InputMode04CellView]()
    let cellWidth = 768
    let cellHeight = 61

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
        self.apyToAllBtn.addTarget(self, action: #selector(applyRstToAll), for: UIControl.Event.touchUpInside)
        
        updateLocalizedString()
        
        var idx = 1
        let photoDataHelper = PhotoDataHelper()
        let taskDataHelper = TaskDataHelper()
        
        self.optInspElmsMaster = taskDataHelper.getOptInspSecElementsByIds(inspSection!.prodTypeId!, inspTypeId: inspSection!.inspectTypeId!, inspSectionId: inspSection!.sectionId!)!
        self.optInspPostsMaster = taskDataHelper.getOptInspSecPositionByIds(inspSection!.prodTypeId!, inspTypeId: inspSection!.inspectTypeId!, sectionId: inspSection!.sectionId!)!
        self.optInspElms = self.optInspElmsMaster
        self.optInspPosts = self.optInspPostsMaster
        
        var inspElmNames = [String]()
        //Init Insp Items
        for taskInspDataRecord in (inspSection?.taskInspDataRecords)! {
            
            let inputCell = inputCellInit(idx, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(idx),iaLabelText: _ENGLISH ?(taskInspDataRecord.postnObj?.positionNameEn)! : (taskInspDataRecord.postnObj?.positionNameCn)!,iiLabelText: _ENGLISH ? (taskInspDataRecord.elmtObj?.elementNameEn)! : (taskInspDataRecord.elmtObj?.elementNameCn)!,dismissBtnHidden: true, elementDbId: (taskInspDataRecord.elmtObj?.elementId)!, refRecordId: taskInspDataRecord.refRecordId!, inspElmId: (taskInspDataRecord.elmtObj?.elementId)!, inspPostId:(taskInspDataRecord.postnObj?.positionId)!, resultValueId: taskInspDataRecord.resultValueId, taskInspDataRecordId:taskInspDataRecord.recordId!, requiredElementFlag: taskInspDataRecord.elmtObj!.reqElmtFlag, optionEnableFlag: inspSection?.optionalEnableFlag ?? 1)
            
            inputCell.photoAdded = photoDataHelper.checkPhotoAddedByInspDataRecordId(taskInspDataRecord.recordId!)
            inputCell.updatePhotoNeededStatus((taskInspDataRecord.resultObj?.resultValueNameEn)!)
            
            let defectItems = Cache_Task_On!.defectItems.filter({$0.taskId == taskInspDataRecord.taskId && $0.inspectRecordId == taskInspDataRecord.recordId})
            
            for defectItem in defectItems {
                defectItem.inspElmt = inputCell
            }
            
            self.optInspElms = self.optInspElms.filter({ $0.elementId != taskInspDataRecord.elmtObj?.elementId})
            inputCells.append(inputCell)
            inspElmNames.append(_ENGLISH ? (taskInspDataRecord.elmtObj?.elementNameEn)! : (taskInspDataRecord.elmtObj?.elementNameCn)!)
            
            idx += 1
        }
        
        self.updateOptionalInspElmts(inspElmNames)
        self.updateContentView()
        self.initSegmentControlView(self.InputMode,apyToAllBtn: self.apyToAllBtn)
    }
    
    func updateLocalizedString(){
        
        self.inspAreaLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Area")
        self.inspItemLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Item")
        self.resultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result")
    }
    
    @objc func applyRstToAll() {
        self.alertConfirmView("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Apply to All"))?",parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
            
            let taskDataHelper = TaskDataHelper()
            let resultValueId = taskDataHelper.getResultValueIdByResultValue(self.resultForAll, prodTypeId: (Cache_Task_On?.prodTypeId)!, inspTypeId: (Cache_Task_On?.inspectionTypeId)!)
        
            for cell in self.inputCells {
                cell.subResultInput.text = self.resultForAll
                cell.updatePhotoAddediConStatus(self.resultForAll,photoTakenIcon: cell.photoAddedIcon)
                cell.resultValueId = resultValueId
            }
            
            Cache_Task_On?.didModify = true
            self.updateContentView()
        
        })
    }
    
    func updateContentView() {
        if inputCells.count < 1 {
            return
        }
        
        for index in 0...inputCells.count-1 {
            let cell = inputCells[index]
            cell.updateCellIndex(cell,index: index)
            cell.idxLabel.text = String(cell.cellIdx)
            cell.frame = CGRect.init(x: 0, y: (index) * cellHeight, width: cellWidth, height: cellHeight)
            
            if index % 2 == 0 {
                cell.backgroundColor = _TABLECELL_BG_COLOR1
            }else{
                cell.backgroundColor = _TABLECELL_BG_COLOR2
            }
            
            if cell.cellPhysicalIdx < inputCells.count {
                self.ScrollCellView.addSubview(inputCells[cell.cellPhysicalIdx])
            }
        }
        
        self.addCellButton.frame = CGRect.init(x: 25, y: inputCells.count*cellHeight+10, width: 42, height: 42)
        self.ScrollCellView.addSubview(self.addCellButton)
        resizeScrollView(CGSize.init(width: 768, height: CGFloat(inputCells.count*cellHeight+500)))
    }
    
    func resizeScrollView(_ size:CGSize) {
        self.ScrollCellView.contentSize = size
    }

    @IBAction func addCellButton(_ sender: UIButton) {
        NSLog("Add Cell")
        
        if self.optInspElms.count > 0 {
            let usedInspItems = self.inputCells.filter({ $0.requiredElementFlag == 0 })
            var usedInspItemNames = [String]()
            
            for usedInspItem in usedInspItems {
                usedInspItemNames.append(usedInspItem.inspectionItemLabel.text!)
            }
            
            let optInspElm = self.optInspElms[0]
            let optInspPost = self.optInspPosts.filter({$0.positionId == optInspElm.inspectPositionId})[0]
            usedInspItemNames.append((_ENGLISH ? optInspElm.elementNameEn:optInspElm.elementNameCn)!)
            
            let inputCell = inputCellInit(inputCells.count+1, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(inputCells.count+1),iaLabelText: (_ENGLISH ? optInspPost.positionNameEn:optInspPost.positionNameCn)!, iiLabelText: (_ENGLISH ? optInspElm.elementNameEn:optInspElm.elementNameCn)!,dismissBtnHidden: false, elementDbId: 0, refRecordId: 0, inspElmId: optInspElm.elementId!, inspPostId: optInspPost.positionId!, displayDDList: true, userInteractive:true)
            
            
            inputCell.saveMyselfToGetId()
            inputCells.append(inputCell)
            
            self.updateContentView()
            self.updateOptionalInspElmts(usedInspItemNames)
        }
    }
    
    func inputCellInit(_ index:Int, sectionId:Int, sectionName:String, idxLabelText:String, iaLabelText:String, iiLabelText:String, dismissBtnHidden:Bool, elementDbId:Int, refRecordId:Int, inspElmId:Int, inspPostId:Int, displayDDList:Bool=false, resultValueId:Int=0, taskInspDataRecordId:Int=0, requiredElementFlag:Int=0, userInteractive:Bool=false, optionEnableFlag:Int=1) -> InputMode04CellView {
        
        let inputCellViewObj = InputMode04CellView.loadFromNibNamed("InputMode04Cell")
        inputCellViewObj?.frame.size = CGSize(width: 768, height: 61)
        inputCellViewObj?.parentView = self
        inputCellViewObj?.idxLabel.text = idxLabelText
        inputCellViewObj?.inspectionAreaLabel.text = iaLabelText
        inputCellViewObj?.inspectionItemLabel.text = iiLabelText
        inputCellViewObj!.cellCatName = sectionName
        inputCellViewObj?.cellCatIdx = sectionId
        inputCellViewObj?.cellIdx = index
        inputCellViewObj?.cellPhysicalIdx = index-1
        inputCellViewObj?.elementDbId = elementDbId
        inputCellViewObj?.resultValueId = resultValueId
        inputCellViewObj?.taskInspDataRecordId = taskInspDataRecordId
        
        let taskDataHelper = TaskDataHelper()
        inputCellViewObj?.subResultInput.text = taskDataHelper.getResultValueByResultValueId(resultValueId)
        //for Save DB
        inputCellViewObj?.refRecordId = refRecordId
        inputCellViewObj?.inspElmId = inspElmId
        inputCellViewObj?.inspPostId = inspPostId
        inputCellViewObj?.inspReqCatText = sectionName
        inputCellViewObj?.inspAreaText = iaLabelText
        inputCellViewObj?.inspItemText = iiLabelText
        inputCellViewObj?.requiredElementFlag = requiredElementFlag
        
        if !userInteractive {
            inputCellViewObj?.inspectionAreaLabel.isUserInteractionEnabled = false
            inputCellViewObj?.inspectionItemLabel.isUserInteractionEnabled = false
        }
        
        if !dismissBtnHidden || (requiredElementFlag < 1 && optionEnableFlag > 0) {
            inputCellViewObj?.showDismissButton()
        }
        
        if displayDDList {
            inputCellViewObj?.displayDDList()
        }
        
        return inputCellViewObj!
    }
    
    func updateOptionalInspElmts(_ inspElmtNames:[String]=[], action:String="filter") {
        
        if action == "filter" {
            self.optInspElms = self.optInspElmsMaster
            for inspElmtName in inspElmtNames {
                self.optInspElms = self.optInspElms.filter({ _ENGLISH ? $0.elementNameEn != inspElmtName : $0.elementNameCn != inspElmtName })
            }
        }else{
            for inspElmtName in inspElmtNames {
                let inspElmt = self.optInspElmsMaster.filter({ _ENGLISH ? $0.elementNameEn == inspElmtName : $0.elementNameCn == inspElmtName })
                
                if inspElmt.count>0{
                    self.optInspElms.append(inspElmt[0])
                }
            }
        }
        
        if self.optInspElms.count < 1 {
            self.addCellButton.isHidden = true
        }else{
            self.addCellButton.isHidden = false
        }
    }
}
