//
//  InputMode03View.swift
//  QCFossil
//
//  Created by pacmobile on 30/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class InputMode03View: InputModeSCMaster {
    
    @IBOutlet weak var scrollCellView: UIScrollView!
    @IBOutlet weak var applyToAllButton: UIButton!
    @IBOutlet weak var addCellButton: UIButton!
    var inputCells = [InputMode03CellView]()
    let inputCellCount = 6
    let cellWidth = Int(_DEVICE_WIDTH)
    let cellHeight = 140
    
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
            return;
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
        
        var idx = 1
        let photoDataHelper = PhotoDataHelper()
        
        for taskInspDataRecord in (inspSection?.taskInspDataRecords)! {
            
            let inputCell = inputCellInit(idx, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(idx),inspCatInputText: MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: taskInspDataRecord.reqSectObj!.sectionNameEn, .zh: taskInspDataRecord.reqSectObj!.sectionNameCn, .fr: taskInspDataRecord.reqSectObj!.sectionNameFr]),inspItemInputText: taskInspDataRecord.requestElementDesc,dismissBtnHidden: true, elementDbId: (taskInspDataRecord.elmtObj?.elementId)!, refRecordId: taskInspDataRecord.refRecordId!, inspElmId: (taskInspDataRecord.elmtObj?.elementId)!, inspPostId: taskInspDataRecord.postnObj!.positionId,taskInspDataRecordId:taskInspDataRecord.recordId!,requestSecId:taskInspDataRecord.requestSectionId,inspDetailInputText:taskInspDataRecord.inspectDetail!,inspRemarksInputText:taskInspDataRecord.inspectRemarks!,resultValueObj:taskInspDataRecord.resultObj!)
            
            inputCell.photoAdded = photoDataHelper.checkPhotoAddedByInspDataRecordId(taskInspDataRecord.recordId!)
            inputCell.updatePhotoNeededStatus((taskInspDataRecord.resultObj?.resultValueNameEn)!)
            
            let defectItems = Cache_Task_On!.defectItems.filter({$0.taskId == taskInspDataRecord.taskId && $0.inspectRecordId == taskInspDataRecord.recordId})
            
            for defectItem in defectItems {
                defectItem.inspElmt = inputCell
            }

            inputCells.append(inputCell)
            
            idx += 1
        }
        
        if idx<2 {
            //inputCells.append(inputCellInit(idx, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(idx),inspCatInputText: "",inspItemInputText: "",dismissBtnHidden: true, elementDbId: 0, refRecordId: 0, inspElmId: 0, inspPostId: 0,taskInspDataRecordId:0,requestSecId:0))
        }
        
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
            
                cell.updatePhotoAddediConStatus(self.resultForAll,photoTakenIcon: cell.photoTakenIcon)
            
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
            
            if cell.cellPhysicalIdx < inputCells.count {
                self.scrollCellView.addSubview(inputCells[cell.cellPhysicalIdx])
            }
        }
        }
        
        self.addCellButton.frame = CGRect.init(x: 8, y: inputCells.count*cellHeight+10, width: 40, height: 40)
        self.scrollCellView.addSubview(self.addCellButton)
        resizeScrollView(CGSize.init(width: _DEVICE_WIDTH, height: CGFloat(inputCells.count*cellHeight+600)))
    }
    
    func resizeScrollView(_ size:CGSize) {
        self.scrollCellView.contentSize = size
    }
    
    func inputCellInit(_ index:Int, sectionId:Int, sectionName:String, idxLabelText:String, inspCatInputText:String, inspItemInputText:String, dismissBtnHidden:Bool, elementDbId:Int, refRecordId:Int, inspElmId:Int, inspPostId:Int, taskInspDataRecordId:Int=0,requestSecId:Int?=0,inspDetailInputText:String="",inspRemarksInputText:String="",resultValueObj:ResultValueObj=ResultValueObj(resultValueId:0,resultValueNameEn: "",resultValueNameCn: "", resultValueNameFr: "")) -> InputMode03CellView {
        
        let inputCellViewObj = InputMode03CellView.loadFromNibNamed("InputMode03Cell")
        inputCellViewObj?.frame.size = CGSize(width: _DEVICE_WIDTH, height: 140)
        inputCellViewObj?.parentView = self
        inputCellViewObj?.cellIndexLabel.text = idxLabelText
        inputCellViewObj?.cellCatIdx = sectionId
        inputCellViewObj?.cellCatName = sectionName
        inputCellViewObj?.cellIdx = index
        inputCellViewObj?.cellPhysicalIdx = index-1
        inputCellViewObj?.elementDbId = elementDbId
        inputCellViewObj?.icInput.text = inspCatInputText
        inputCellViewObj?.iiInput.text = inspItemInputText
        inputCellViewObj?.idInput.text = inspDetailInputText
        inputCellViewObj?.cellRemarksInput.text = inspRemarksInputText
        inputCellViewObj?.cellResultInput.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: resultValueObj.resultValueNameEn, .zh: resultValueObj.resultValueNameCn, .fr: resultValueObj.resultValueNameFr])
        inputCellViewObj?.resultValueId = resultValueObj.resultValueId
        inputCellViewObj?.idInput.text = inspDetailInputText
        
        //for Save DB
        inputCellViewObj?.refRecordId = refRecordId
        inputCellViewObj?.inspElmId = inspElmId
        inputCellViewObj?.inspPostId = inspPostId
        inputCellViewObj?.taskInspDataRecordId = taskInspDataRecordId
        inputCellViewObj?.requestSectionId = requestSecId
        inputCellViewObj?.inspCatText = "OI"
        inputCellViewObj?.inspReqCatText = inspCatInputText
        inputCellViewObj?.inspAreaText = inspCatInputText
        inputCellViewObj?.inspItemText = inspItemInputText
        
        if !dismissBtnHidden {
            inputCellViewObj?.showDismissButton()
        }
        
        return inputCellViewObj!
    }
    
    @IBAction func addCellBtnOnClick(_ sender: UIButton) {
        NSLog("Add Cell")
        
        let inputCell = inputCellInit(inputCells.count+1,sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(inputCells.count+1),inspCatInputText: "",inspItemInputText: "",dismissBtnHidden: false, elementDbId: 0, refRecordId: 0, inspElmId: 0, inspPostId: 0)
        
        inputCell.saveMyselfToGetId()
        
        inputCells.append(inputCell)
        
        self.updateContentView()
    }
}
