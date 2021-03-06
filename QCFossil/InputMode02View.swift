//
//  InputMode02View.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

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
    let cellWidth = 768
    let cellHeight = 140
    
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
        
    }
    
    override func didMoveToSuperview() {
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            return
        }
        
        //Init Defect Position Items
        let dpDataHelper = DPDataHelper()
        self.defectPosits = dpDataHelper.getDefectPositions()
        self.defectPositPoints = dpDataHelper.getAllDefectPositPoints()
        
        let photoDataHelper = PhotoDataHelper()
        var idx = 1
        
        for taskInspDataRecord in (inspSection?.taskInspDataRecords)! {
            if taskInspDataRecord.postnObj?.positionId > 0 {
            
            let dfPositPoints = dpDataHelper.getDefectPositionPointsByRecordId(taskInspDataRecord.recordId!)
            let inputCell = inputCellInit(idx, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(idx),dpText: (_ENGLISH ? taskInspDataRecord.postnObj?.positionNameEn:taskInspDataRecord.postnObj?.positionNameCn)!, dpDescText: taskInspDataRecord.inspectPositionDesc!, dppText: dfPositPoints, dismissBtnHidden: true, elementDbId: (taskInspDataRecord.elmtObj?.elementId)!, refRecordId: taskInspDataRecord.refRecordId!, inspElmId: (taskInspDataRecord.elmtObj?.elementId)!, inspPostId: taskInspDataRecord.postnObj!.positionId, resultValueObj:taskInspDataRecord.resultObj!, taskInspDataRecordId:taskInspDataRecord.recordId!)
            
            inputCell.photoAdded = photoDataHelper.checkPhotoAddedByInspDataRecordId(taskInspDataRecord.recordId!)
            inputCell.updatePhotoNeededStatus((taskInspDataRecord.resultObj?.resultValueNameEn)!)
            
            let defectItems = Cache_Task_On!.defectItems.filter({$0.taskId == taskInspDataRecord.taskId && $0.inspectRecordId == taskInspDataRecord.recordId})
            
            for defectItem in defectItems {
                defectItem.inspElmt = inputCell
            }
            
            inputCells.append(inputCell)
            }
            
            idx++
        }
        
        //inputCells.append(inputCellInit(idx, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(idx),dpText: "", dpDescText: "", dppText: "", dismissBtnHidden: true, elementDbId: 0, refRecordId: 0, inspElmId: 0, inspPostId: 0))
        
        
        self.updateContentView()
        self.initSegmentControlView(self.InputMode,apyToAllBtn: self.applyToAllButton)
    }
    
    func applyRstToAll() {
        
        let taskDataHelper = TaskDataHelper()
        let resultValueId = taskDataHelper.getResultValueIdByResultValue(resultForAll, prodTypeId: (Cache_Task_On?.prodTypeId)!, inspTypeId: (Cache_Task_On?.inspectionTypeId)!)
        
        for cell in inputCells {
            cell.cellResultInput.text = resultForAll
            cell.updatePhotoAddediConStatus(resultForAll,photoTakenIcon: cell.photoAddedIcon)
            cell.resultValueId = resultValueId
        }
        
        Cache_Task_On?.didModify = true
        updateContentView()
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
        resizeScrollView(CGSize.init(width: self.scrollCellView.frame.size.width, height: CGFloat(inputCells.count*cellHeight+500)))
    }
    
    func resizeScrollView(size:CGSize) {
        self.scrollCellView.contentSize = size
    }
    
    func inputCellInit(index:Int, sectionId:Int, sectionName:String, idxLabelText:String, dpText:String, dpDescText:String, dppText:String, dismissBtnHidden:Bool, elementDbId:Int, refRecordId:Int, inspElmId:Int, inspPostId:Int, resultValueObj:ResultValueObj=ResultValueObj(resultValueId:0,resultValueNameEn: "",resultValueNameCn: ""), taskInspDataRecordId:Int=0) -> InputMode02CellView {
        
        let inputCellViewObj = InputMode02CellView.loadFromNibNamed("InputMode02Cell")
        
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
        inputCellViewObj?.cellResultInput.text = _ENGLISH ? resultValueObj.resultValueNameEn : resultValueObj.resultValueNameCn
        
        //for Save DB
        inputCellViewObj?.refRecordId = refRecordId
        inputCellViewObj?.inspElmId = inspElmId
        inputCellViewObj?.inspPostId = inspPostId
        inputCellViewObj?.resultValueId = resultValueObj.resultValueId
        inputCellViewObj?.taskInspDataRecordId = taskInspDataRecordId
        inputCellViewObj?.inspReqCatText = sectionName
        inputCellViewObj?.inspAreaText = dpText
        inputCellViewObj?.inspItemText = dppText
        
        if !dismissBtnHidden {
            inputCellViewObj?.showDismissButton()
        }
        
        return inputCellViewObj!
    }
    
    @IBAction func addCellBtnOnClick(sender: UIButton) {
        NSLog("Add Cell")
        
        inputCells.append(inputCellInit(inputCells.count+1, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(inputCells.count+1),dpText: "", dpDescText: "", dppText: "", dismissBtnHidden: false, elementDbId: 0, refRecordId: 0, inspElmId: 0, inspPostId: 0))
        
        self.updateContentView()
    }
}
