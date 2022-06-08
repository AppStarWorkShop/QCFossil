//
//  InptCategoryCell.swift
//  QCFossil
//
//  Created by Yin Huang on 14/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InptCategoryCell: UIView {

    @IBOutlet weak var resultValue1: UILabel!
    @IBOutlet weak var resultValue2: UILabel!
    @IBOutlet weak var resultValue3: UILabel!
    @IBOutlet weak var resultValue4: UILabel!
    @IBOutlet weak var resultValue5: UILabel!
    @IBOutlet weak var resultValueTotal: UILabel!
    
    @IBOutlet weak var result4Divider: UILabel!
    @IBOutlet weak var inptCatButton: CustomButton!
    weak var parentView:TaskDetailViewInput!
    var resultSetValueFrames = [ResultValueFrame]()
    var resultSetValues = [SummaryResultValue]()
    var resultValueLabels = [UILabel]()
    var frameWidth:CGFloat = 90.0
    var frameHeight:CGFloat = 21.0
    var frameTop:CGFloat = 9
    var sectionId:Int?
    
    let marginX1:CGFloat = 191
    let marginX2:CGFloat = 289
    let marginX3:CGFloat = 387
    let marginX4:CGFloat = 484
    let marginX5:CGFloat = 582
    let marginX6:CGFloat = 680
    
    struct ResultValueFrame {
        var xPos:CGFloat
        var yPos:CGFloat
        var width:CGFloat
        var height:CGFloat
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        resultValue1.numberOfLines = 2
//        resultValue1.adjustsFontSizeToFitWidth = true
//        resultValue1.lineBreakMode = .byClipping
        resultValue1.lineBreakMode = .byWordWrapping
        
        resultValue2.numberOfLines = 2
//        resultValue2.adjustsFontSizeToFitWidth = true
//        resultValue2.lineBreakMode = .byClipping
        resultValue2.lineBreakMode = .byWordWrapping
        
        resultValue3.numberOfLines = 2
//        resultValue3.adjustsFontSizeToFitWidth = true
//        resultValue3.lineBreakMode = .byClipping
        resultValue3.lineBreakMode = .byWordWrapping
        
        resultValue4.numberOfLines = 2
//        resultValue4.adjustsFontSizeToFitWidth = true
//        resultValue4.lineBreakMode = .byClipping
        resultValue4.lineBreakMode = .byWordWrapping
        
        resultValue5.numberOfLines = 2
//        resultValue5.adjustsFontSizeToFitWidth = true
//        resultValue5.lineBreakMode = .byClipping
        resultValue5.lineBreakMode = .byWordWrapping
        
        resultValueTotal.numberOfLines = 2
//        resultValueTotal.adjustsFontSizeToFitWidth = true
//        resultValueTotal.lineBreakMode = .byClipping
        resultValueTotal.lineBreakMode = .byWordWrapping
        
        resultValueLabels.append(resultValue1)
        resultValueLabels.append(resultValue2)
        resultValueLabels.append(resultValue3)
        resultValueLabels.append(resultValue4)
        resultValueLabels.append(resultValue5)
        resultValueLabels.append(resultValueTotal)
        
        if TypeCode.LEATHER.rawValue == Cache_Inspector?.typeCode || TypeCode.PACKAGING.rawValue == Cache_Inspector?.typeCode {
            resultValueTotal.isHidden = true
            resultValue5.superview?.isHidden = true
            result4Divider.isHidden = true
        }
    }
    
    override func didMoveToSuperview() {
        if self.parentVC == nil {
            return
        }
        
        self.setButtonCornerRadius(self.inptCatButton)
        updateSummaryResultValues(resultSetValues)
    }
    
    func updateSummaryResultValues(_ resultSetValues:[SummaryResultValue]) {
        var totalCount = 0
        for idx in 0...resultSetValues.count {
            if idx < resultValueLabels.count {
                let resultValueLabel = resultValueLabels[idx]
                
                resultValueLabel.font = resultValueTotal.font.withSize(12)
                if idx == resultSetValues.count {
                    resultValueLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Total"))(\(totalCount))"
                }else{
                    let resultSetValue = resultSetValues[idx]
                    
                    resultValueLabel.text = "\(resultSetValue.valueName)(\(resultSetValue.resultCount))"
                    totalCount += resultSetValue.resultCount
                }
            }
        }
    }
    
    @IBAction func inptCatButton(_ sender: UIButton) {
        let myParentVC = self.parentVC as! TaskDetailsViewController
        myParentVC.startTask(sender.tag)
    }
}
