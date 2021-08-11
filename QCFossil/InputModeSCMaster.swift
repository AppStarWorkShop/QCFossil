//
//  InputModeSCMaster.swift
//  QCFossil
//
//  Created by pacmobile on 3/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputModeSCMaster:UIView {
    
    var idx = 0
    var categoryIdx = 0
    var categoryName = ""
    var inspSection:InspSection?
    var InputMode = ""
    var resultSetId = 0
    var resultValues = [String]()
    var resultForAll = ""
    var optInspElmsMaster = [InspSectionElement]()
    var optInspPostsMaster = [InspSectionPosition]()
    var optInspElms = [InspSectionElement]()
    var optInspPosts = [InspSectionPosition]()
    var resultKeyValues = [String:Int]()
    
    func initSegmentControlView(_ inputMode:String, apyToAllBtn:UIButton) {
        let taskDataHelper = TaskDataHelper()
//        let otherInspSecTmp = Cache_Task_On?.inspSections.filter({$0.inputModeCode == inputMode})
        var otherInspSec = Cache_Task_On?.inspSections
        
        if otherInspSec!.count > 0 {
            
            resultSetId = otherInspSec![0].resultSetId!
            resultValues = taskDataHelper.getResultSetValueBySetId(resultSetId)!
            resultKeyValues = taskDataHelper.getResultKeyValueBySetId(resultSetId)!
            
            if resultValues.count>0 {
                
                resultForAll = resultValues[0]
                
                let segmentedControl = UISegmentedControl.init(items: resultValues)
                
                segmentedControl.selectedSegmentIndex = 0
                segmentedControl.layer.cornerRadius = 5.0
                
                let font = UIFont.systemFont(ofSize: 16)
                segmentedControl.setTitleTextAttributes([NSAttributedString.Key(rawValue: convertFromNSAttributedStringKey(NSAttributedString.Key.font)): font],
                    for: UIControl.State())
                
                segmentedControl.backgroundColor = _FOSSILYELLOWCOLOR
                segmentedControl.tintColor = _FOSSILBLUECOLOR
                
                let frame = UIScreen.main.bounds
                segmentedControl.frame = CGRect(x: frame.minX + 5, y: frame.minY + 24,
                    width: frame.width*2/3, height: 30)
                
                segmentedControl.addTarget(self, action: #selector(InputModeSCMaster.resultSelect(_:)), for:.valueChanged)
                self.addSubview(segmentedControl)
                
                apyToAllBtn.frame = CGRect(x: segmentedControl.frame.size.width+20, y: frame.minY + 24, width: 120, height: 30)
                self.addSubview(apyToAllBtn)
                
                apyToAllBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Apply to All"), for: UIControl.State() )
                setButtonCornerRadius(apyToAllBtn)
            }
            
            if self.idx < 1 {
                let moveRightBtn = CustomButton()
                let moveRightIcon = UIImage.init(named: "arrow_icon_right")
                moveRightBtn.frame = CGRect(x: 705, y: 0, width: 80, height: 80)
                moveRightBtn.setImage(moveRightIcon, for: UIControl.State())
                moveRightBtn.tintColor = _FOSSILBLUECOLOR
                moveRightBtn.addTarget(self, action: #selector(InputModeSCMaster.moveToRight(_:)), for: UIControl.Event.touchUpInside)
                self.addSubview(moveRightBtn)
                
            }else if self.idx < (otherInspSec?.count ?? 1) - 1 {
                let moveLeftBtn = CustomButton()
                let moveLeftIcon = UIImage.init(named: "arrow_icon_left")
                moveLeftBtn.frame = CGRect(x: 645, y: 0, width: 80, height: 80)
                moveLeftBtn.setImage(moveLeftIcon, for: UIControl.State())
                moveLeftBtn.tintColor = _FOSSILBLUECOLOR
                moveLeftBtn.addTarget(self, action: #selector(InputModeSCMaster.moveToLeft(_:)), for: UIControl.Event.touchUpInside)
                self.addSubview(moveLeftBtn)
                
                let moveRightBtn = CustomButton()
                let moveRightIcon = UIImage.init(named: "arrow_icon_right")
                moveRightBtn.frame = CGRect(x: 705, y: 0, width: 80, height: 80)
                moveRightBtn.setImage(moveRightIcon, for: UIControl.State())
                moveRightBtn.tintColor = _FOSSILBLUECOLOR
                moveRightBtn.addTarget(self, action: #selector(InputModeSCMaster.moveToRight(_:)), for: UIControl.Event.touchUpInside)
                self.addSubview(moveRightBtn)
                
            }else {
                let moveLeftBtn = CustomButton()
                let moveLeftIcon = UIImage.init(named: "arrow_icon_left")
                moveLeftBtn.frame = CGRect(x: 645, y: 0, width: 80, height: 80)
                moveLeftBtn.setImage(moveLeftIcon, for: UIControl.State())
                moveLeftBtn.tintColor = _FOSSILBLUECOLOR
                moveLeftBtn.addTarget(self, action: #selector(InputModeSCMaster.moveToLeft(_:)), for: UIControl.Event.touchUpInside)
                self.addSubview(moveLeftBtn)
            }
        }
    }
    
    @objc func moveToLeft(_ sender: UIButton) {
        let parentView = (sender.parentVC as! TaskDetailsViewController).ScrollView.viewWithTag(_TASKINSPCATVIEWTAG)
        (parentView as! InspectionViewInput).scrollToPosition(self.idx-1)
    }
    
    @objc func moveToRight(_ sender: UIButton) {
        let parentView = (sender.parentVC as! TaskDetailsViewController).ScrollView.viewWithTag(_TASKINSPCATVIEWTAG)
        (parentView as! InspectionViewInput).scrollToPosition(self.idx+1)
    }

    @objc func resultSelect(_ sender: UISegmentedControl) {
        resultForAll = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
