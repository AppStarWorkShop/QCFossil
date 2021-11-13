//
//  UserSettingViewController.swift
//  QCFossil
//
//  Created by pacmobile on 7/12/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class UserSettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var CPTitle: UILabel!
    @IBOutlet weak var currentPwTitle: UILabel!
    @IBOutlet weak var newPwTitle: UILabel!
    @IBOutlet weak var newPwAgainTitle: UILabel!
    @IBOutlet weak var currentPwInput: UITextField!
    @IBOutlet weak var newPwInput: UITextField!
    @IBOutlet weak var newPwAgainInput: UITextField!
    @IBOutlet weak var changePwBtn: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var imageSizeTitle: UILabel!
    @IBOutlet weak var imageSizeSegment: UISegmentedControl!
    @IBOutlet weak var inspectorSignatureLabel: UILabel!
    @IBOutlet weak var inspectorSignatureInput: UIImageView!
    @IBOutlet weak var inspectorSignatureBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var useBackgroundModeTitle: UILabel!
    @IBOutlet weak var useBackgroundModeSwitch: UISwitch!
    
    var signInputView:SignoffView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
        }
        
        self.CPTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Change Password") + " ?"
        self.currentPwTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Current Password")
        self.newPwTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password")
        self.newPwAgainTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password Again")
        self.changePwBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Change Password"), for: UIControl.State())
        self.imageSizeTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Resolution of Photo from Library or Camera")
        self.inspectorSignatureLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspector Signature")
        self.useBackgroundModeTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Use Background Mode for Download/Upload Task")
        
        self.newPwInput.delegate = self
        self.newPwAgainInput.delegate = self
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("User Setting")
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        
        self.view.setButtonCornerRadius(self.changePwBtn)
        self.view.setButtonCornerRadius(self.clearBtn)
        
        self.inspectorSignatureBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Tap to Sign"), for: UIControl.State())
        self.clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update Signature"), for: UIControl.State())
        
        let keyValueDataHelper = KeyValueDataHelper()
        let signImageInCode = keyValueDataHelper.getInspectorSignImage(String(describing: Cache_Inspector?.inspectorId))
        
        if signImageInCode != "" {
            self.inspectorSignatureInput.image = UIImage.init().fromBase64(signImageInCode)
            self.inspectorSignatureBtn.isHidden = true
        }
        
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "backgroundrun_preference") != nil) && defaults.string(forKey: "backgroundrun_preference")! != "true" {
            self.useBackgroundModeSwitch.isOn = false
        }else{
            self.useBackgroundModeSwitch.isOn = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */
    
    @IBAction func showMenuAction(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.newPwInput || textField == self.newPwAgainInput {
            
            if string == " " {
                return false
            }
        }
        
        return true
    }
    
    @IBAction func changePwAction(_ sender: UIButton) {
        
        do{
            self.errorMsg.textColor = UIColor.red
            let inspectorDataHelper = InspectorDataHelper()
            if (inspectorDataHelper.getInspector((Cache_Inspector?.appUserName)!, password: (self.currentPwInput.text?.md5())!) != nil) {
                self.errorMsg.isHidden = true
                
                //Check if New password equit to appUsername
                if self.newPwInput.text == Cache_Inspector?.appUserName! {
                    print("new password cant be the same as user login name!")
                    
                    DispatchQueue.main.async {
                        self.errorMsg.isHidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Login Name Cannot Be Used As New Password")
                    }
                    
                    return
                }
                
                //Check if New password contains 8 to 15 charators
                if self.newPwInput.text?.characters.count < 8 || self.newPwInput.text?.characters.count > 15 {
                    DispatchQueue.main.async {
                        self.errorMsg.isHidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password should be 8-15 Characters")
                    }
                    
                    return
                }
                
                
                //Check if New password including Numbers
                let tNumRegularExpression = try NSRegularExpression(pattern: "[0-9]", options: .caseInsensitive)
                let tNumMatchCount = tNumRegularExpression.numberOfMatches(in: self.newPwInput.text!, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.newPwInput.text!.characters.count))
                
                if tNumMatchCount < 1 {
                    print("match Num count: \(tNumMatchCount)")
                    
                    DispatchQueue.main.async {
                        self.errorMsg.isHidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password need to include Numbers")
                    }
                    
                    return
                }
                
                //Check if New password including Letters
                let tLetterRegularExpression = try NSRegularExpression(pattern: "[A-Za-z]", options: .caseInsensitive)
                let tLetterMatchCount = tLetterRegularExpression.numberOfMatches(in: self.newPwInput.text!, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.newPwInput.text!.characters.count))
                
                if tLetterMatchCount < 1 {
                    print("match Letter count: \(tLetterMatchCount)")
                
                    DispatchQueue.main.async {
                        self.errorMsg.isHidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password need to include Letters")
                    }
                    
                    return
                }
                
                //Check if New password is the same as Confirm password
                if self.newPwInput.text == self.newPwAgainInput.text {
                
                    var data = "\(_DS_PREFIX){"
                    for (key, value) in _DS_CHANGE_PW["APIPARA"] as! Dictionary<String,String> {
                        data += "\"\(key)\":\"\(value)\","
                    }
                    data += "}"
                    data = data.replacingOccurrences(of: ",}", with: "}")
                    data = data.replacingOccurrences(of: "new_password", with: self.newPwInput.text!)
                
                    self.makePostRequest(_DS_CHANGE_PW["APINAME"] as! String, dataInJson: data, actionNames: _DS_CHANGE_PW["ACTIONNAMES"] as! [String], actionFields: _DS_CHANGE_PW["ACTIONFIELDS"] as! Dictionary,  handler: { (result, response, totalRecords) -> Void in
                    
                        if response == "SUCCESS"{
                            
                            DispatchQueue.main.async {
                                self.errorMsg.isHidden = false
                                self.errorMsg.textColor = _FOSSILBLUECOLOR
                                self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New password reset Successfully!")
                                
                                let inspectorDataHelper = InspectorDataHelper()
                                Cache_Inspector?.appPassword = self.newPwInput.text!.md5()
                                inspectorDataHelper.updateInspector(Cache_Inspector!)
                                
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update failed. Please check internet connection"), handlerFun: { (action:UIAlertAction!) in
                                    
                                    
                                })
                            }
                        }
                    
                    })
                
                }else{
                    DispatchQueue.main.async {
                        self.errorMsg.isHidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm Password and New Password Not Matched")
                    }
                    
                }
                
            }else{
                DispatchQueue.main.async {
                    self.errorMsg.isHidden = false
                    self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Old Password Not Correct")
                }
            }
            
        }catch {
            print("error: \(error)")
        }
        
    }
    
    @IBAction func imageSizeSegmentAction(_ sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex
        
        switch selectedSegment {
            case 0:
                _RESIZEIMAGEWIDTH = 600
                _RESIZEIMAGEHEIGHT = 800
                break
            case 1:
                _RESIZEIMAGEWIDTH = 800
                _RESIZEIMAGEHEIGHT = 1200
                break
            case 2:
                _RESIZEIMAGEWIDTH = 1200
                _RESIZEIMAGEHEIGHT = 1600
                break
            default:
                _RESIZEIMAGEWIDTH = 600
                _RESIZEIMAGEHEIGHT = 800
        }
    }
    
    @IBAction func inspectorSignTap(_ sender: UIButton) {
        sender.isHidden = true
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
        
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.isHidden = false
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor.clear
        
        let layer = UIView()
        layer.frame = self.view.frame
        layer.center = self.view.center
        layer.backgroundColor = UIColor.black
        layer.alpha = 0.7
        container.addSubview(layer)
        
        signInputView = SignoffView()
        signInputView!.frame = CGRect(x: 0,y: 0,width: 650,height: 415)
        signInputView!.center = container.center
        signInputView!.backgroundColor = UIColor.white
        signInputView!.isUserInteractionEnabled = true
        
        let okBtn = UIButton(frame: CGRect(x: _DEVICE_WIDTH/2 + 225, y: (signInputView?.frame.maxY ?? 800) + 10, width: 100, height: 50))
        okBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        okBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm"), for: UIControl.State())
        okBtn.addTarget(self, action: #selector(UserSettingViewController.confirmInspctorSign), for: UIControl.Event.touchUpInside)
        self.view.setButtonCornerRadius(okBtn)
        
        let clearBtn = UIButton(frame: CGRect(x: _DEVICE_WIDTH/2 + 105, y: (signInputView?.frame.maxY ?? 800) + 10, width: 100, height: 50))
        clearBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), for: UIControl.State())
        clearBtn.addTarget(self, action: #selector(UserSettingViewController.clearInspctorSign), for: UIControl.Event.touchUpInside)
        self.view.setButtonCornerRadius(clearBtn)
        /*
        let cancelBtn = UIButton(frame: CGRect(x: 380, y: 750, width: 100, height: 50))
        cancelBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        cancelBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: #selector(UserSettingViewController.cancelInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(cancelBtn)
        */
        //Use the Regular Size Image
        container.addSubview(signInputView!)
        container.addSubview(okBtn)
        container.addSubview(clearBtn)
        //container.addSubview(cancelBtn)
        
        self.view.addSubview(container)
    }
    
    @objc func cancelInspctorSign() {
        if self.inspectorSignatureInput.image == nil {
            self.inspectorSignatureBtn.isHidden = false
        }
        
        self.view.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":true])
    }
    
    @objc func clearInspctorSign(){
        signInputView?.image = nil
    }
    
    @objc func confirmInspctorSign() {
        
        if signInputView?.image == nil {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Signature"))
            return
        }
        
        self.inspectorSignatureInput.image = signInputView?.image
        
        let keyValueDataHelper = KeyValueDataHelper()
        keyValueDataHelper.saveInspectorSignImage(String(describing: Cache_Inspector?.inspectorId), imageToBase64: (self.inspectorSignatureInput.image?.toBase64())!)
        
        self.view.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":true])
    }
    
    @IBAction func clearBtnOnClick(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
        
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.isHidden = false
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor.clear
        
        let layer = UIView()
        layer.frame = self.view.frame
        layer.center = self.view.center
        layer.backgroundColor = UIColor.black
        layer.alpha = 0.7
        container.addSubview(layer)
        
        signInputView = SignoffView()
        signInputView!.frame = CGRect(x: 0,y: 0,width: 650,height: 415)
        signInputView!.center = container.center
        signInputView!.backgroundColor = UIColor.white
        signInputView!.isUserInteractionEnabled = true
        
        let okBtn = UIButton(frame: CGRect(x: _DEVICE_WIDTH/2 + 225, y: (signInputView?.frame.maxY ?? 800) + 10, width: 100, height: 50))
        okBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        okBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm"), for: UIControl.State())
        okBtn.addTarget(self, action: #selector(UserSettingViewController.confirmInspctorSign), for: UIControl.Event.touchUpInside)
        self.view.setButtonCornerRadius(okBtn)
        
        let clearBtn = UIButton(frame: CGRect(x: _DEVICE_WIDTH/2 + 105, y: (signInputView?.frame.maxY ?? 800) + 10, width: 100, height: 50))
        clearBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), for: UIControl.State())
        clearBtn.addTarget(self, action: #selector(UserSettingViewController.clearInspctorSign), for: UIControl.Event.touchUpInside)
        self.view.setButtonCornerRadius(clearBtn)
        
        if self.inspectorSignatureInput.image != nil {
            let cancelBtn = UIButton(frame: CGRect(x: _DEVICE_WIDTH/2 - 15, y: (signInputView?.frame.maxY ?? 800) + 10, width: 100, height: 50))
            cancelBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
            cancelBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), for: UIControl.State())
            cancelBtn.addTarget(self, action: #selector(UserSettingViewController.cancelInspctorSign), for: UIControl.Event.touchUpInside)
            self.view.setButtonCornerRadius(cancelBtn)
            container.addSubview(cancelBtn)
        }
        
        //Use the Regular Size Image
        container.addSubview(signInputView!)
        container.addSubview(okBtn)
        container.addSubview(clearBtn)
        
        self.view.addSubview(container)
        /*
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear Signature?"),parentVC:self, handlerFun: { (action:UIAlertAction!) in
            self.inspectorSignatureInput.image = nil
            self.inspectorSignatureBtn.hidden = false
            
            let keyValueDataHelper = KeyValueDataHelper()
            keyValueDataHelper.saveInspectorSignImage(String(Cache_Inspector?.inspectorId), imageToBase64: "")
         
        })*/
    }
    
    @IBAction func useBackgroundModeOnchange(_ sender: UISwitch) {
        
        let defaults = UserDefaults.standard
        
        if sender.isOn {
            defaults.set("true", forKey: "backgroundrun_preference")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "initSessionWithBackgroundSession"), object: nil, userInfo: nil)
        }else{
            defaults.set("false", forKey: "backgroundrun_preference")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "initSessionWithDefaultSession"), object: nil, userInfo: nil)
        }
    }
}
