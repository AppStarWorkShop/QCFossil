//
//  InputMode01View.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputMode01View: InputModeSCMaster {

    @IBOutlet weak var scrollCellView: UIScrollView!
    @IBOutlet weak var applyToAllButton: UIButton!
    @IBOutlet weak var result: UITextField!
    @IBOutlet weak var addCellButton: UIButton!
    var inputCells = [InputMode01CellView]()
    let inputCellCount = 6
    let cellWidth = Int(_DEVICE_WIDTH)
    let cellHeight = 200

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        
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
        
        let photoDataHelper = PhotoDataHelper()
        let taskDataHelper = TaskDataHelper()
        var idx = 1
        
        self.optInspElmsMaster = taskDataHelper.getOptInspSecElementsByIds(inspSection!.prodTypeId!, inspTypeId: inspSection!.inspectTypeId!, inspSectionId: inspSection!.sectionId!)!
        self.optInspPostsMaster = taskDataHelper.getOptInspSecPositionByIds(inspSection!.prodTypeId!, inspTypeId: inspSection!.inspectTypeId!, sectionId: inspSection!.sectionId!)!
        self.optInspElms = self.optInspElmsMaster
        self.optInspPosts = self.optInspPostsMaster
        
        var inspElmNames = [String]()
        for taskInspDataRecord in (inspSection?.taskInspDataRecords)! {
            
            let inputCell = inputCellInit(idx, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(idx),inspItemText: MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: taskInspDataRecord.elmtObj?.elementNameEn, .zh: taskInspDataRecord.elmtObj?.elementNameCn, .fr: taskInspDataRecord.elmtObj?.elementNameFr]),inspDetailText: taskInspDataRecord.inspectDetail!, inspRemarksText: taskInspDataRecord.inspectRemarks!,dismissBtnHidden: true, elementDbId: (taskInspDataRecord.elmtObj?.elementId)!, refRecordId: taskInspDataRecord.refRecordId!, inspElmId: (taskInspDataRecord.elmtObj?.elementId)!, inspPostId:taskInspDataRecord.postnObj!.positionId, resultValueObj: taskInspDataRecord.resultObj!, taskInspDataRecordId: taskInspDataRecord.recordId!, inspItemInputText:"" , requiredElementFlag: taskInspDataRecord.elmtObj!.reqElmtFlag, optionEnableFlag: inspSection?.optionalEnableFlag ?? 1)
            
            
            inputCell.photoAdded = photoDataHelper.checkPhotoAddedByInspDataRecordId(taskInspDataRecord.recordId!)
            inputCell.updatePhotoNeededStatus((taskInspDataRecord.resultObj?.resultValueNameEn)!)
            
            let defectItems = Cache_Task_On!.defectItems.filter({$0.taskId == taskInspDataRecord.taskId && $0.inspectRecordId == taskInspDataRecord.recordId})
            
            for defectItem in defectItems {
                defectItem.inspElmt = inputCell
            }
            
            //self.optInspElms = self.optInspElms.filter({ $0.elementId != taskInspDataRecord.elmtObj?.elementId})
            inputCells.append(inputCell)
            inspElmNames.append(MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: taskInspDataRecord.elmtObj?.elementNameEn, .zh: taskInspDataRecord.elmtObj?.elementNameCn, .fr: taskInspDataRecord.elmtObj?.elementNameFr]))
        
            idx += 1
        }
        
        if inputCells.count < 1 {
        //    return
        }
        
        self.updateOptionalInspElmts(inspElmNames)
        self.updateContentView()
        self.initSegmentControlView(self.InputMode,apyToAllBtn: self.applyToAllButton)
        
        NSLayoutConstraint.activate([
            scrollCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
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
            //return
            
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
            
            if cell.cellPhysicalIdx < inputCells.count {
                self.scrollCellView.addSubview(inputCells[cell.cellPhysicalIdx])
            }
        }
        }
        
        self.addCellButton.frame = CGRect.init(x: 8, y: inputCells.count*cellHeight+10, width: 50, height: 50)
        self.scrollCellView.addSubview(self.addCellButton)
        resizeScrollView(CGSize.init(width: _DEVICE_WIDTH, height: CGFloat(inputCells.count*cellHeight+800)))
    }
    
    func resizeScrollView(_ size:CGSize) {
        self.scrollCellView.contentSize = size
    }
    
    func inputCellInit(_ index:Int, sectionId:Int, sectionName:String, idxLabelText:String, inspItemText:String, inspDetailText:String,inspRemarksText:String, dismissBtnHidden:Bool, elementDbId:Int, refRecordId:Int, inspElmId:Int, inspPostId:Int, resultValueObj:ResultValueObj=ResultValueObj(resultValueId:0,resultValueNameEn: "",resultValueNameCn: "", resultValueNameFr: ""), taskInspDataRecordId:Int=0, inspItemInputText:String="", userInteractive:Bool=true, requiredElementFlag:Int=0, optionEnableFlag:Int=1) -> InputMode01CellView {
        
        let inputCellViewObj = InputMode01CellView.loadFromNibNamed("InputMode01Cell")
        inputCellViewObj?.frame.size = CGSize(width: _DEVICE_WIDTH, height: 200)
        inputCellViewObj?.parentView = self
        inputCellViewObj?.cellIndexLabel.text = idxLabelText
        inputCellViewObj?.cellCatIdx = sectionId
        inputCellViewObj?.cellCatName = sectionName
        inputCellViewObj?.cellIdx = index
        inputCellViewObj?.cellPhysicalIdx = index-1
        inputCellViewObj?.elementDbId = elementDbId
        inputCellViewObj?.inptItemInputTextView.text = inspItemText
        inputCellViewObj?.inptDetailInputTextView.text = inspDetailText
        inputCellViewObj?.cellRemarksInput.text = inspRemarksText
        inputCellViewObj?.cellResultInput.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: resultValueObj.resultValueNameEn, .zh: resultValueObj.resultValueNameCn, .fr: resultValueObj.resultValueNameFr])
        
        //for Save DB
        inputCellViewObj?.refRecordId = refRecordId
        inputCellViewObj?.inspElmId = inspElmId
        inputCellViewObj?.inspPostId = inspPostId
        inputCellViewObj?.resultValueId = resultValueObj.resultValueId
        inputCellViewObj?.taskInspDataRecordId = taskInspDataRecordId
        inputCellViewObj?.inspReqCatText = sectionName
        inputCellViewObj?.inspAreaText = inspItemText
        inputCellViewObj?.inspItemText = inspItemInputText
        inputCellViewObj?.requiredElementFlag = requiredElementFlag
        
        if !userInteractive {
            inputCellViewObj?.inptItemInputTextView.isUserInteractionEnabled = false
        }
        
        if !dismissBtnHidden || (requiredElementFlag < 1 && optionEnableFlag > 0) {
            inputCellViewObj?.showDismissButton()
        }
        
        return inputCellViewObj!
    }
    
    @IBAction func addCellBtnOnClick(_ sender: UIButton) {
        NSLog("Add Cell")
        
        let inputCell = inputCellInit(inputCells.count+1, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(inputCells.count+1),inspItemText: "", inspDetailText: "", inspRemarksText: "", dismissBtnHidden: false, elementDbId: 0, refRecordId: 0, inspElmId: 0, inspPostId: 0, userInteractive: true)
        
        inputCell.saveMyselfToGetId()
        inputCells.append(inputCell)
        self.updateContentView()
    }

    func updateOptionalInspElmts(_ inspElmtNames:[String]=[], action:String="filter") {
        
        if action == "filter" {

        }else{
            for inspElmtName in inspElmtNames {
                let inspElmt = self.optInspElmsMaster.filter({ MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: $0.elementNameEn, .zh: $0.elementNameCn, .fr: $0.elementNameFr]) == inspElmtName })
                
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
