//
//  UserForgetViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 16/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class UserForgetViewController: UIViewController {
    
    @IBOutlet weak var forgetPwOKBtn: UIButton!
    @IBOutlet weak var forgetPwBackBtn: UIButton!
    @IBOutlet weak var forgetUsernameOKBtn: UIButton!
    @IBOutlet weak var forgetUsernameBackBtn: UIButton!
    @IBOutlet weak var forgetPwTitle: UILabel!
    @IBOutlet weak var forgetPwEmailLabel: UILabel!
    @IBOutlet weak var forgetPwEmailInput: UITextField!
    @IBOutlet weak var forgetUsernameTitle: UILabel!
    @IBOutlet weak var forgetUsernameUsernameLabel: UILabel!
    @IBOutlet weak var forgetUsernameUsernameInput: UITextField!
    @IBOutlet weak var forgetUsernameEmailInput: UITextField!
    @IBOutlet weak var forgetUsernameEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (self.forgetPwBackBtn != nil) {
            self.view.setButtonCornerRadius(self.forgetPwBackBtn)
        }
        
        if (self.forgetPwOKBtn != nil) {
            self.view.setButtonCornerRadius(self.forgetPwOKBtn)
        }
        
        if (self.forgetUsernameBackBtn != nil) {
            self.view.setButtonCornerRadius(self.forgetUsernameBackBtn)
        }
        
        if (self.forgetUsernameOKBtn != nil) {
            self.view.setButtonCornerRadius(self.forgetUsernameOKBtn)
        }
        
        updateLocalizeString()
    }
    
    func updateLocalizeString() {
        if (self.forgetPwBackBtn != nil) {
            self.forgetPwBackBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Back"), for: UIControl.State())
        }
        
        if (self.forgetPwOKBtn != nil) {
            self.forgetPwOKBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), for: UIControl.State())
        }
        
        if (self.forgetPwEmailLabel != nil) {
            self.forgetPwEmailLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Email Address")
        }
        
        if (self.forgetUsernameBackBtn != nil) {
            self.forgetUsernameBackBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Back"), for: UIControl.State())
        }
        
        if (self.forgetUsernameOKBtn != nil) {
            self.forgetUsernameOKBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), for: UIControl.State())
        }
        
        if (self.forgetUsernameEmailLabel != nil) {
            self.forgetUsernameEmailLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Email Address")
        }
        
        if (self.forgetUsernameUsernameLabel != nil) {
            self.forgetUsernameUsernameLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Username")
        }
        
        if (self.forgetPwTitle != nil) {
            self.forgetPwTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please provide below info and email would be sent")
        }
        
        if (self.forgetUsernameTitle != nil) {
            self.forgetUsernameTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please provide below info and email would be sent")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
    */
    
    @IBAction func resetUserNameEmailOKBtn(_ sender: UIButton) {
        print("reset password by username & email")
        
        //Data Sync Forget Username
        var data = "\(_DS_PREFIX){"
        for (key, value) in _DS_FORGET_UNPW["APIPARA"] as! Dictionary<String,String> {
            data += "\"\(key)\":\"\(value)\","
        }
        data += "}"
        data = data.replacingOccurrences(of: ",}", with: "}")
        data = data.replacingOccurrences(of: _DS_RESETEMAIL, with: self.forgetUsernameEmailInput.text!)
        data = data.replacingOccurrences(of: _DS_USERNAME, with: self.forgetUsernameUsernameInput.text!)
        
        self.makePostRequest(_DS_FORGET_UNPW["APINAME"] as! String, dataInJson: data, actionFields: _DS_FORGET_UNPW["ACTIONFIELDS"] as! Dictionary,  handler: { (result, response, totalRecords) -> Void in
            
            if response == "SUCCESS"{
                DispatchQueue.main.async(execute: {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Password has been reset! Please check your Email!"))
                })
            }else if response == "Fail"{
                DispatchQueue.main.async(execute: {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update failed. Please check internet connection"))
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Username / Email Not Correct"))
                })
            }
        })
    }
    
    @IBAction func resetEmailOKBtn(_ sender: UIButton) {
        print("reset username")
        
        //Data Sync Forget Username
        var data = "\(_DS_PREFIX){"
        for (key, value) in _DS_FORGET_UN["APIPARA"] as! Dictionary<String,String> {
            data += "\"\(key)\":\"\(value)\","
        }
        data += "}"
        data = data.replacingOccurrences(of: ",}", with: "}")
        data = data.replacingOccurrences(of: _DS_RESETEMAIL, with: self.forgetPwEmailInput.text!)
        
        self.makePostRequest(_DS_FORGET_UN["APINAME"] as! String, dataInJson: data, actionFields: _DS_FORGET_UN["ACTIONFIELDS"] as! Dictionary,  handler: { (result, response, totalRecords) -> Void in
            
            if response == "SUCCESS"{
                DispatchQueue.main.async(execute: {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Username has been reset! Please check your Email!"))
                })
            }else if response == "Fail"{
                DispatchQueue.main.async(execute: {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update failed. Please check internet connection"))
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Username / Password Not Correct"))
                })
            }
        })
    }

    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
