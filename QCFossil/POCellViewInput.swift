//
//  POCellViewInput.swift
//  QCFossil
//
//  Created by Yin Huang on 3/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class POCellViewInput: UIView, UITextFieldDelegate {

    @IBOutlet weak var poNoLabel: UILabel!
    @IBOutlet weak var poNoText: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandText: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleText: UILabel!
    @IBOutlet weak var orderQtyLabel: UILabel!
    @IBOutlet weak var orderQtyText: UILabel!
    @IBOutlet weak var poLineNoLabel: UILabel!
    @IBOutlet weak var poLineNoText: UILabel!
    @IBOutlet weak var shipToLabel: UILabel!
    @IBOutlet weak var shipToText: UILabel!
    @IBOutlet weak var availInspectQtyLabel: UILabel!
    @IBOutlet weak var enableLabel: UILabel!
    @IBOutlet weak var availInspectQtyInput: UITextField!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var sampleQtyLabel: UILabel!
    @IBOutlet weak var sampleQtyInput: UITextField!
    @IBOutlet weak var bookingQtyLabel: UILabel!
    @IBOutlet weak var bookingQtyInput: UILabel!
    @IBOutlet weak var opdRsdLabel: UILabel!
    @IBOutlet weak var opdRsdInput: UILabel!
    @IBOutlet weak var shipWinLabel: UILabel!
    @IBOutlet weak var shipWinInput: UILabel!
    
    
    var idx = 0
    var poItemId:Int?
    var isEnable = 1
    var sampleQtyDB:Int = 0
    var availInspQtyDB:Int = 0
    var bookingQtyDB:Int = 0
    var prodDesc = ""
    
    weak var pVC:UIViewController!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    @IBAction func isEnableSwitchOnClick(_ sender: UISwitch) {
        self.sampleQtyInput.endEditing(true)
        self.availInspectQtyInput.endEditing(true)
        self.bookingQtyInput.endEditing(true)
        
        Cache_Task_On?.didModify = true
        
        if sender.isOn {
            self.isEnable = 1
            self.sampleQtyInput.text = sampleQtyDB>0 ? String(sampleQtyDB) : ""
            self.availInspectQtyInput.text = availInspQtyDB>0 ? String(availInspQtyDB) : ""
            self.bookingQtyInput.text = String(self.bookingQtyDB)//String(bookingQtyDB)
            
            //enable sample & avail Qty Input
            self.sampleQtyInput.isUserInteractionEnabled = true
            self.availInspectQtyInput.isUserInteractionEnabled = true
            
            Cache_Task_On!.poItems.forEach({ if $0.itemId == self.poItemId { $0.isEnable = 1 } })
            
        }else{
            self.isEnable = 0
            self.sampleQtyInput.text = ""
            self.availInspectQtyInput.text = ""
            self.bookingQtyInput.text = "0"//self.orderQtyText.text
            
            self.sampleQtyDB = 0
            self.availInspQtyDB = 0
            
            let taskDataHelper = TaskDataHelper()
            taskDataHelper.updateTaskItemQty(availInspQtyDB, samplingQty: sampleQtyDB, taskId: (Cache_Task_On?.taskId)!, poItemId: poItemId!)
            
            //disable sample & avail Qty Input
            self.sampleQtyInput.isUserInteractionEnabled = false
            self.availInspectQtyInput.isUserInteractionEnabled = false
            
            Cache_Task_On!.poItems.forEach({ if $0.itemId == self.poItemId { $0.isEnable = 0 } })
        }
    }
    
    override func awakeFromNib() {
        self.sampleQtyInput.delegate = self
        self.availInspectQtyInput.delegate = self
        
        updateLocalizedString()
        NotificationCenter.default.addObserver(self, selector: #selector(taskConfirmedAction), name: NSNotification.Name(rawValue: "taskConfirmed"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "taskConfirmed"), object: nil)
    }
    
    @objc func taskConfirmedAction() {
        enableSwitch.isEnabled = false
    }
    
    override func didMoveToSuperview() {
        if self.isEnable == 1 {
            enableSwitch.setOn(true, animated: false)
        }else {
            enableSwitch.setOn(false, animated: false)
        }
        
        if pVC?.classForCoder == CreateTaskViewController.classForCoder() {
            self.availInspectQtyLabel.isHidden = true
            self.availInspectQtyInput.isHidden = true
            self.enableLabel.isHidden = true
            self.enableSwitch.isHidden = true
            
            self.sampleQtyLabel.isHidden = true
            self.sampleQtyInput.isHidden = true
            self.bookingQtyLabel.isHidden = true
            self.bookingQtyInput.isHidden = true
        }
        
        if self.disableFuns(self) {
            enableSwitch.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.sampleQtyInput && textField.text != "" {
            self.sampleQtyDB = Int(textField.text!)!
        }else if textField == self.availInspectQtyInput && textField.text != "" {
            self.availInspQtyDB = Int(textField.text!)!
        }else if textField == self.bookingQtyInput && textField.text != "" {
            self.bookingQtyDB = Int(textField.text!)!
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Cache_Task_On?.didModify = true
        
        
        if textField.keyboardType == UIKeyboardType.numberPad {
            
            return textField.numberOnlyCheck(textField, sourceText: string)
        }
        
        return false
    }
    
    func updateLocalizedString(){
        
        self.poNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        self.poLineNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO Line No.")
        self.brandLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.styleLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style, Size")
        self.orderQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Order Qty")
        self.shipToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship To")
        self.availInspectQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Avail. Qty")
        self.enableLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Enable?")
        self.sampleQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sample Qty")
        self.bookingQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Booked Qty")
        self.opdRsdLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD")
        self.shipWinLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SW/Req. Ex-fty Date")
    }
    
    @IBAction func delBtn(_ sender: UIButton){
        
        if pVC?.classForCoder == CreateTaskViewController.classForCoder() {
            let parentVC = self.pVC as! CreateTaskViewController
            //parentVC.poCellItems.removeAtIndex(self.idx)
            parentVC.poItems.remove(at: self.idx)
            //parentVC.loadPoItemCell()
            
            if parentVC.poItems.count < 1 {
                parentVC.vendorInput.text = ""
                parentVC.vdrLocationInput.text = ""
            }
            
        }else if pVC?.classForCoder == TaskDetailsViewController.classForCoder() {
            let parentVC = self.pVC as! TaskDetailsViewController
            let taskDetailViewInput = parentVC.view.viewWithTag(_TASKDETAILVIEWTAG) as! TaskDetailViewInput
            
            if taskDetailViewInput.poItems.count > 1{
                let poItemRemove = taskDetailViewInput.poItems[self.idx]
                taskDetailViewInput.poItems.remove(at: self.idx)
                //Resize
                taskDetailViewInput.resizePoWrapperContent(-1*CGFloat(taskDetailViewInput.poCellHeight))
                
                taskDetailViewInput.loadPoList()
                
                //Delete From DB
                let taskDataHelper = TaskDataHelper()
                taskDataHelper.deletePOItemByIds(poItemRemove.itemId!, taskId: (Cache_Task_On?.taskId)!)
            }else{
                self.alertView("POItem can not be nil!")
                
            }
            
        }
    }
    
    @IBAction func showProdDesc(_ sender: UIButton){
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//        popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
        popoverContent.dataType = _POPOVERPRODDESC
        popoverContent.selectedValue = prodDesc
        
        let nav = CustomNavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.tintColor = UIColor.black
        
        let popover = nav.popoverPresentationController
        popover!.delegate = sender.parentVC as! PopoverMaster
        popover!.sourceView = sender
        popover!.sourceRect = sender.bounds
        
        sender.parentVC!.present(nav, animated: true, completion: nil)
        
    }
}
