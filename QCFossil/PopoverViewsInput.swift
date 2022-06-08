//
//  PopoverViewsInput.swift
//  QCFossil
//
//  Created by Yin Huang on 13/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class PopoverViewsInput: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var typeSelection: UIPickerView!
    var pickerData: [String] = [String]()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.typeSelection.delegate = self
        self.typeSelection.dataSource = self
    }
    
    func initData (_ pickSourceView:String) {
        if pickSourceView == _PRODTYPE {
            let taskDataHelper = TaskDataHelper()
            pickerData = taskDataHelper.getAllProdType() //PRODTYPEDATA
        }else if pickSourceView == _INPTTYPE {
            let taskDataHelper = TaskDataHelper()
            pickerData = taskDataHelper.getAllInspType() //INPTTYPEDATA
        }else if pickSourceView == _TMPLTYPE {
            let taskDataHelper = TaskDataHelper()
            pickerData = taskDataHelper.getAllTmplType() //TMLPTYPEDATA
        }
    }
    
    override func didMoveToSuperview() {
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            return
        }
        
        if pickerData.count > 0 {
            setParentTextFieldValue(pickerData[0])
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData.count > 0 {
            setParentTextFieldValue(pickerData[row])
        }
    }
    
    func setParentTextFieldValue(_ value:String) {
        if self.parentVC != nil {
            let parentVC = self.parentVC as! PopoverViewController
            parentVC.selectedValue = (value)
        }
    }
}
