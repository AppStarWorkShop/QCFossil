//
//  TaskTypeViewController.swift
//  QCFossil
//
//  Created by pacmobile on 12/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class TaskTypeViewController: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var inptTypeLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var templateTypeLabel: UILabel!
    @IBOutlet weak var productType: CustomTextField!
    @IBOutlet weak var inptType: CustomTextField!
    @IBOutlet weak var templateType: CustomTextField!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    weak var pVC:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.productType.delegate = self
        self.inptType.delegate = self
        self.templateType.delegate = self
        
        let taskDataHelper = TaskDataHelper()
        
        self.productType.text = taskDataHelper.getTypeNameByTypeId((Cache_Inspector?.prodTypeId)!)
    
        //localize language
        updateLocalizedString()
        
        (pVC as! CreateTaskViewController).createNotificationFromSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocalizedString(){
        self.productTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Product Type")
        self.inptTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Type")
        self.templateTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Template Type")
        self.okBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), for: UIControl.State())
        self.cancelBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), for: UIControl.State())
        self.messageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please select Product Type and Inspection Type")
        
        self.view.setButtonCornerRadius(self.okBtn)
        self.view.setButtonCornerRadius(self.cancelBtn)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

    @IBAction func okButton(_ sender: UIButton) {
        if self.inptType.text == ""{
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please select a Inspection Type!"))
            return
        }
        
        if self.templateType.text == ""{
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please select a Template Type!"))
            return
        }
        
        (pVC as! CreateTaskViewController).inspectTypeInput.text = self.inptType.text
        (pVC as! CreateTaskViewController).productTypeInput.text = self.productType.text
        (pVC as! CreateTaskViewController).tmplName = self.templateType.text!
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":true])
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CreateTaskCancel"), object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showProdTypes(_ sender: UITextField) {
        print("Show Prod Types")
        /*
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSizeMake(_POPOVERVIEWSIZE_S.width,_POPOVERVIEWSIZE_S.height+_NAVIBARHEIGHT)
        popoverContent.parentTextFieldView = sender
        popoverContent.sourceType = _PRODTYPE
        
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        nav.navigationBar.barTintColor = UIColor.blackColor()

        let popover = nav.popoverPresentationController
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(sender.frame.midX,sender.frame.minY,sender.frame.size.width,sender.frame.size.height)

        self.presentViewController(nav, animated: true, completion: nil)
*/
        /*
        let popoverContent = PopoverViewController()
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        popoverContent.preferredContentSize = CGSizeMake(300,150)
        
        let popover = popoverContent.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRectMake(352,449,200,30)
        
        self.presentViewController(popoverContent, animated: true, completion: nil)
        */
    }
    
    @IBAction func showInptTypes(_ sender: UITextField) {
        print("Show Inpt Types")
        
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: _POPOVERVIEWSIZE_S.width,height: _POPOVERVIEWSIZE_S.height+_NAVIBARHEIGHT)

        popoverContent.parentTextFieldView = sender
        popoverContent.sourceType = _INPTTYPE
        popoverContent.didPickCompletion = {
        
            Cache_Inspector?.selectedInspType = self.inptType.text!
            let taskDataHelper = TaskDataHelper()
            let templates = taskDataHelper.getAllTmplType()
            
            if templates.count < 1 {
                self.templateType?.text = ""
            } else if templates.count == 1 {
                for template in templates {
                    self.templateType?.text = template
                }
            }
            
        }
        
        let nav = CustomNavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        nav.navigationBar.barTintColor = .black
        
        let popover = nav.popoverPresentationController
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRect(x: sender.frame.midX,y: sender.frame.minY,width: sender.frame.size.width,height: sender.frame.size.height)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func showTmlpTypes(_ sender: UITextField) {
        print("show tmlp types")
        
        if self.inptType.text == "" || self.inptType.text == nil {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please select a Inspection Type!"))
            return
        }
        
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: _POPOVERVIEWSIZE_S.width,height: _POPOVERVIEWSIZE_S.height+_NAVIBARHEIGHT)
        
        popoverContent.parentTextFieldView = sender
        popoverContent.sourceType = _TMPLTYPE
        
        let nav = CustomNavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.barTintColor = UIColor.black
        
        let popover = nav.popoverPresentationController
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRect(x: sender.frame.midX,y: sender.frame.minY,width: sender.frame.size.width,height: sender.frame.size.height)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Forbidden editing")
        
        return false
    }
}
