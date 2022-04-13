//
//  ViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 14/12/15.
//  Copyright © 2015 kira. All rights reserved.
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


class ViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    //labels
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    //textfields
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var language: UISegmentedControl!
    
    //buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var forgetUserNameButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginStatusMsg: UILabel!
    @IBOutlet weak var versionCode: UILabel!
    @IBOutlet weak var databaseUsingCode: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    var newPwInput:UITextField!
    var confirmPwInput:UITextField!
    var validateStatus:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("\(UIDevice.currentDevice().systemVersion)")
        // Do any additional setup after loading the view, typically from a nib.
        self.language.selectedSegmentIndex = 1
        MylocalizedString.sharedLocalizeManager.setMyLanguage(.zh)
        updateLocalizedString()
        // DatabaseManager.sharedDatabaseManager.initDbObj()
        
        //------------------------------------------ Do Any Updating Here before Login if Needed ------------------------------------------
        if _NEEDDATAUPDATE {
            DispatchQueue.main.async(execute: {
                self.view.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Updating"))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    //Upgrade to support multiple inspectors
                    let filemgr = FileManager.default
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let dbDir = dirPaths[0] as String
                    let dbDir2 = dirPaths[0] as String
                    
                    let defaults = UserDefaults.standard
                    if defaults.object(forKey: "lastLoginUsername") != nil {
                        let inspectorName = defaults.object(forKey: "lastLoginUsername")! as? String
                        let folderPath = _TASKSPHYSICALPATHPREFIX + (inspectorName?.lowercased())!
                        let databasePath = dbDir + "\(_DBNAME_USING)"
                        let taskPhotosPath = dbDir2 + "/Tasks"
                        
                        if !filemgr.fileExists(atPath: folderPath) && filemgr.fileExists(atPath: databasePath) {
                            
                            do {
                                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                                try filemgr.moveItem(atPath: databasePath, toPath: folderPath+"/\(_DBNAME_USING)_\((inspectorName?.lowercased())!)")
                                
                                if filemgr.fileExists(atPath: taskPhotosPath) {
                                    try filemgr.moveItem(atPath: taskPhotosPath, toPath: folderPath+"/Tasks")
                                }
                                
                            } catch let error as NSError {
                                print(error.localizedDescription)
                                
                            }
                        }
                    }
                    //Upgrade to support multiple inspectors End
                    
                    
                    self.view.removeActivityIndicator()
                    _NEEDDATAUPDATE = false
                }
            })
        }
        //--------------------------------------------------------------------------------------------------------------------------------
        
        self.view.setButtonCornerRadius(self.loginButton)
        self.view.setButtonCornerRadius(self.clearButton)
        self.view.setButtonCornerRadius(self.forgetPasswordButton)
        self.view.setButtonCornerRadius(self.forgetUserNameButton)
        self.versionCode.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Version")+" \(_VERSION)"
        _VERSIONCODE = MylocalizedString.sharedLocalizeManager.getLocalizedString("Version")+" \(_VERSION)"
        //self.username.text = "delicate01"
        //self.password.text = "g3271952"
        //self.username.text = "jy01"
        //self.password.text = "wE$6T+8a"
        
        let defaults = UserDefaults.standard
        let releaseDate = "202204013"//self.view.getCurrentDate("MMdd")
        _RELEASE = releaseDate as String
        defaults.set(releaseDate, forKey: "release_preference")
        
        var releaseCode = ""
        #if UAT
            releaseCode = "UAT " + releaseDate
            defaults.set("UAT", forKey: "serverEnv_preference")
            defaults.set(dataSyncUatServer, forKey: "webServiceUrl_preference")
        #elseif TESTENV
            releaseCode = "TEST " + releaseDate
            defaults.set("TEST", forKey: "serverEnv_preference")
            defaults.set(dataSyncUatServer, forKey: "webServiceUrl_preference")
        #else
            releaseCode = "PRD " + releaseDate
            defaults.set("PRD", forKey: "serverEnv_preference")
            defaults.set(dataSyncPrdServer, forKey: "webServiceUrl_preference")
        #endif
        _RELEASECODE = releaseCode
        self.databaseUsingCode.text = releaseCode
        
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc func defaultsChanged(){
        updateDisplayFromDefaults()
    }
    
    func updateDisplayFromDefaults(){
        
        //Get the defaults, Update Version No.
        let defaults = UserDefaults.standard
                
        //Set the controls to the default values.
        if let imagesize = defaults.string(forKey: "imagesize_preference"){
            
            if Int(imagesize) > 1 {
                _RESIZEIMAGEWIDTH = 1200
                _RESIZEIMAGEHEIGHT = 1600
                
            }else if Int(imagesize) > 0 {
                _RESIZEIMAGEWIDTH = 800
                _RESIZEIMAGEHEIGHT = 1200
                
            }else{
                _RESIZEIMAGEWIDTH = 600
                _RESIZEIMAGEHEIGHT = 800
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLoginStatus() {
        self.loginIndicator.isHidden = true
        self.loginStatusMsg.text = ""
        self.password.text = ""
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "lastLoginUsername") != nil {
            self.username.text = defaults.object(forKey: "lastLoginUsername")! as? String
        }
        
        updateDisplayFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initLoginStatus()
    }
    
    func startLoginStatus(_ loginMsg:String = "", textColor:UIColor = _DEFAULTBUTTONTEXTCOLOR){
        self.loginIndicator.isHidden = false
        self.loginIndicator.startAnimating()
        self.loginStatusMsg.textColor = textColor
        self.loginStatusMsg.text = loginMsg
    }
    
    func stopLoginStatus(_ loginMsg:String = "", textColor:UIColor = UIColor.red) {
        self.loginIndicator.isHidden = true
        self.loginIndicator.stopAnimating()
        self.loginStatusMsg.textColor = textColor
        self.loginStatusMsg.text = loginMsg
    }
    
    @IBAction func changeLanguage(_ sender: UISegmentedControl) {
        /*
        selectedSegment: 0 - English
        selectedSegment: 1 - Chinese
        */
        let selectedSegment = sender.selectedSegmentIndex;
        
        switch selectedSegment {
        case 1:
            MylocalizedString.sharedLocalizeManager.setMyLanguage(.zh)
        case 2:
            MylocalizedString.sharedLocalizeManager.setMyLanguage(.fr)
        default:
            MylocalizedString.sharedLocalizeManager.setMyLanguage(.en)
        }
        
        //switch language
        updateLocalizedString()
    }
    
    @IBAction func userLogin(_ sender: UIButton) {
        NSLog("userLogin")
        
        if _DEBUG_MODE {
            self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
            return
        }
        
        self.startLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login through WS..."))
        
        //if username or password nil, alert
        if(self.username.text == "" || self.password.text == ""){
            self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Username or Password should not be nil!"))
            
        }else{
            
            //Login From Server first, if no network, then use local data
            //Data Sync Login
            var data = "\(_DS_PREFIX){"
            for (key, value) in _DS_USERLOGIN["APIPARA"] as! Dictionary<String,String> {
                data += "\"\(key)\":\"\(value)\","
            }
            data += "}"
            data = data.replacingOccurrences(of: ",}", with: "}")
            data = data.replacingOccurrences(of: _DS_USERNAME, with: self.username.text!)
            data = data.replacingOccurrences(of: _DS_USERPASSWORD, with: self.password.text!.md5())
                
            print("password: \(self.password.text!.md5())")
                
            self.makePostRequest(_DS_USERLOGIN["APINAME"] as! String, dataInJson: data, actionNames: _DS_USERLOGIN["ACTIONNAMES"] as! [String], actionFields: _DS_USERLOGIN["ACTIONFIELDS"] as! Dictionary,  handler: { (result, response, totalRecords) -> Void in
                    
                if response == "SUCCESS"{
                    DispatchQueue.main.async(execute: {
                        
                        if result![0]["inspector_id"] != nil && result![0]["prod_type_id"] != nil && result![0]["rec_status"] != nil {
                            let inspector = Inspector(inspectorId: Int(result![0]["inspector_id"]!), inspectorName: result![0]["inspector_name"]!, prodTypeId: Int(result![0]["prod_type_id"]!), appUserName: result![0]["app_username"]!, appPassword: result![0]["app_password"]!, serviceToken: result![0]["service_token"]!, reportPrefix: result![0]["report_prefix"]!, reportRunningNo: result![0]["report_running_no"]!, phoneNo: result![0]["phone_no"]!, emailAddr: result![0]["email_addr"]!, typeCode: "")
                                
                            inspector.recStatus = Int(result![0]["rec_status"]!)
                            inspector.createUser = result![0]["create_user"]
                            inspector.createDate = result![0]["create_date"]
                            inspector.modifyUser = result![0]["modify_user"]
                            inspector.modifyDate = result![0]["modify_date"]
                            inspector.deleteFlag = Int(result![0]["deleted_flag"]!)
                            inspector.deleteUser = result![0]["delete_user"]
                            inspector.deleteDate = result![0]["delete_date"]
                            inspector.chgPwdReqDate = result![0]["chg_pwd_req_date"]!
                            
                            var prodType = ProdType()
                            if let typeId = result![1]["type_id"] {
                                prodType.typeId = typeId
                            }
                            
                            if let typeCode = result![1]["type_code"] {
                                prodType.typeCode = typeCode
                            }
                            
                            if let typeNameEn = result![1]["type_name_en"] {
                                prodType.typeNameEn = typeNameEn
                            }
                            
                            if let typeNameCn = result![1]["type_name_cn"] {
                                prodType.typeNameCn = typeNameCn
                            }
                            
                            if let typeNameFr = result![1]["type_name_fr"] {
                                prodType.typeNameFr = typeNameFr
                            }
                            
                            if let dataEnv = result![1]["data_env"] {
                                prodType.dataEnv = dataEnv
                            }
                            
                            if let recStatus = result![1]["rec_status"] {
                                prodType.recStatus = recStatus
                            }
                            
                            if let createDate = result![1]["create_date"] {
                                prodType.createDate = createDate
                            }
                            
                            if let createUser = result![1]["create_user"] {
                                prodType.createUser = createUser
                            }
                            
                            if let modifyDate = result![1]["modify_date"] {
                                prodType.modifyDate = modifyDate
                            }
                            
                            if let modifyUser = result![1]["modify_user"] {
                                prodType.modifyUser = modifyUser
                            }
                            
                            if let deletedFlag = result![1]["deleted_flag"] {
                                prodType.deletedFlag = deletedFlag
                            }
                            
                            if let deleteDate = result![1]["delete_date"] {
                                prodType.deleteDate = deleteDate
                            }
                            
                            if let deleteUser = result![1]["delete_user"] {
                                prodType.deleteUser = deleteUser
                            }
                            
                            //Update Service Token
                            _DS_SERVICETOKEN = result![0]["service_token"]!
                                
                            //update local DB
                            //DatabaseManager.sharedDatabaseManager.initDbObj("\(_DBNAME_USING)_\((inspector.appUserName?.lowercaseString)!)")
                            
                            //update local DB for Multi User
                            DatabaseManager.sharedDatabaseManager.initDbObj("\((inspector.appUserName?.lowercased())!)")
                            
                            let inspectorDataHelper = InspectorDataHelper()
                            inspectorDataHelper.updateInspector(inspector)
                            inspectorDataHelper.updateProdType(prodType)
                            
                            Cache_Inspector = inspectorDataHelper.getInspectorById(inspector.inspectorId ?? 0)
                            if Cache_Inspector == nil {
                                Cache_Inspector = inspector
                                Cache_Inspector?.typeCode = prodType.typeCode
                            }
                            Cache_Inspector?.lastLoginDate = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                                
                            let keyValueDataHelper = KeyValueDataHelper()
                            keyValueDataHelper.updateLastLoginDatetime(String((Cache_Inspector?.inspectorId)!), datetime: self.view.getCurrentDateTime())
                                
                            _DS_SERVICETOKEN = (Cache_Inspector?.serviceToken)!
                            //7029c6d9-7933-4be7-86e6-8bbc0aac1cb8
                            
                            let defaults = UserDefaults.standard
                            defaults.set(Cache_Inspector?.appUserName, forKey: "lastLoginUsername")
                            
                            
                            //------------- Checking Any Update for DB ----------------
                            //add column for vdr_location_mstr table
                            let currDBVersion = keyValueDataHelper.getDBVersionNum()
                            
                            if _VERSION < currDBVersion {
                                self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Database Version is \(currDBVersion), But iPad App Version is \(_VERSION)"))
                                return
                                
                            }else if _VERSION != currDBVersion {
                            
                                let appUpgradeDataHelper = AppUpgradeDataHelper()
                                appUpgradeDataHelper.appUpgradeCode(_VERSION, parentView: self.view, completion: { (result) in
                                    
                                    if result {
                                        keyValueDataHelper.updateDBVersionNum(_VERSION)
                                    }
                                
                                    let DBVersion = keyValueDataHelper.getDBVersionNum()
                                    if _VERSION != DBVersion {
                                        self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Database Version is \(DBVersion), But iPad App Version is \(_VERSION)"))
                                        return
                                    }
                                    
                                    self.copyAppInfoFile(true)
                                    
                                    self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login success, Redirect..."), textColor: _DEFAULTBUTTONTEXTCOLOR)
                                    if Cache_Inspector?.chgPwdReqDate != "" && Cache_Inspector?.chgPwdReqDate != nil {
                                        self.handlePwChangeBeforeRedirect()
                                        Cache_Inspector?.chgPwdReqDate = ""
                                        let inspectorDataHelper = InspectorDataHelper()
                                        inspectorDataHelper.updateInspector(Cache_Inspector!)
                                    
                                    }else{
                                        self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
                                    }
                                })
                            }else{
                                
                                self.copyAppInfoFile()
                                self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login success, Redirect..."), textColor: _DEFAULTBUTTONTEXTCOLOR)
                                if Cache_Inspector?.chgPwdReqDate != "" && Cache_Inspector?.chgPwdReqDate != nil {
                                    self.handlePwChangeBeforeRedirect()
                                    Cache_Inspector?.chgPwdReqDate = ""
                                    let inspectorDataHelper = InspectorDataHelper()
                                    inspectorDataHelper.updateInspector(Cache_Inspector!)
                                    
                                }else{
                                    
                                    if self.isBackupDateOverNdays() {
                                        self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("You haven't done data sync over 3 days!"), handlerFun: { (UIAlertAction) in
                                            self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
                                        })
                                    }else{
                                        self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
                                    }
                                }
                            }
                            //------------------------------------------------
                            
                        }
                    })
                }else{
                    
                    DispatchQueue.main.async(execute: {
                        self.startLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login through Local Database..."))
                        if DatabaseManager.sharedDatabaseManager.openLocalDB(self.username.text!.lowercased()) {
                            
                            let inspectorDataHelper = InspectorDataHelper()
                            Cache_Inspector = inspectorDataHelper.getInspector(self.username.text!, password: self.password.text!.md5())
                        
                            if (Cache_Inspector != nil) {
                                //local login
                                _DS_SERVICETOKEN = (Cache_Inspector?.serviceToken)!
                                Cache_Inspector?.lastLoginDate = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                            
                                let keyValueDataHelper = KeyValueDataHelper()
                                keyValueDataHelper.updateLastLoginDatetime(String((Cache_Inspector?.inspectorId)!), datetime: self.view.getCurrentDateTime())
                            
                                let defaults = UserDefaults.standard
                                defaults.set(Cache_Inspector?.appUserName, forKey: "lastLoginUsername")
                                
                                //------------- Checking Any Update for DB ----------------
                                //add column for vdr_location_mstr table
                                let currDBVersion = keyValueDataHelper.getDBVersionNum()
                                
                                if _VERSION < currDBVersion {
                                    self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Database Version is \(currDBVersion), But iPad App Version is \(_VERSION)"))
                                    return
                                    
                                }else if _VERSION != currDBVersion {
                                    
                                    let appUpgradeDataHelper = AppUpgradeDataHelper()
                                    appUpgradeDataHelper.appUpgradeCode(_VERSION, parentView: self.view, completion: { (result) in
                                        
                                        let keyValueDataHelper = KeyValueDataHelper()
                                        if result {
                                            keyValueDataHelper.updateDBVersionNum(_VERSION)
                                        }
                                    
                                        let DBVersion = keyValueDataHelper.getDBVersionNum()
                                        if _VERSION != DBVersion {
                                            self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Database Version is \(DBVersion), But iPad App Version is \(_VERSION)"))
                                            return
                                        }
                                        
                                        self.copyAppInfoFile(true)
                                    
                                        self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login success, Redirect..."), textColor: _DEFAULTBUTTONTEXTCOLOR)
                                        if Cache_Inspector?.chgPwdReqDate != "" && Cache_Inspector?.chgPwdReqDate != nil {
                                            self.handlePwChangeBeforeRedirect()
                                            Cache_Inspector?.chgPwdReqDate = ""
                                            let inspectorDataHelper = InspectorDataHelper()
                                            inspectorDataHelper.updateInspector(Cache_Inspector!)
                                        
                                        }else{
                                            self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
                                        }
                                    })
                                }else{
                                    
                                    self.copyAppInfoFile()
                                    if self.isBackupDateOverNdays() {
                                        self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("You haven't done data sync over 3 days!"), handlerFun: { (UIAlertAction) in
                                            self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
                                        })
                                    }else{
                                        self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
                                    }
                                    self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login success, Redirect..."), textColor: _DEFAULTBUTTONTEXTCOLOR)
                                    if Cache_Inspector?.chgPwdReqDate != "" && Cache_Inspector?.chgPwdReqDate != nil {
                                        self.handlePwChangeBeforeRedirect()
                                        Cache_Inspector?.chgPwdReqDate = ""
                                        let inspectorDataHelper = InspectorDataHelper()
                                        inspectorDataHelper.updateInspector(Cache_Inspector!)
                                        
                                    }else{
                                        self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
                                    }
                                }
                                //------------------------------------------------
                                
                                
                                
                            }else{
                            
                                DispatchQueue.main.async(execute: {
                                    self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Username / Password Not Correct"))
                                
                                })
                            }
                        }else{
                            DispatchQueue.main.async(execute: {
                                self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login Information Not Correct"))
                            
                            })
                        }
                    })
                }
            })
        }
    }
    
    func handlePwChangeBeforeRedirect() {
        let alert = UIAlertController(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Change Your Password Now"), message: "", preferredStyle: UIAlertController.Style.alert)
        let saveAction = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
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
                            let style = NSMutableParagraphStyle()
                            style.alignment = NSTextAlignment.center
                            let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("New password reset Successfully!"), attributes: convertToOptionalNSAttributedStringKeyDictionary([
                                convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style,
                                convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                                convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : _DEFAULTBUTTONTEXTCOLOR
                                ]))
                            alert.setValue(attributedString, forKey: "attributedMessage")
                            
                            let inspectorDataHelper = InspectorDataHelper()
                            Cache_Inspector?.appPassword = self.newPwInput.text!.md5()
                            inspectorDataHelper.updateInspector(Cache_Inspector!)
                            
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "TaskSearchNavigatorSegue", sender: self)
                            }
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update failed. Please check internet connection"), handlerFun: { (action:UIAlertAction!) in
                                //self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update New Password Failed"))
                            })
                        }
                    }
                        
                })
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }
        })
        
        saveAction.isEnabled = false
        
        alert.addTextField(configurationHandler: self.configurationNewPwInputTextField)
        alert.addTextField(configurationHandler: self.configurationConfirmPwInputTextField)
        alert.addAction(saveAction)
        
        // Adding the notification observer here
        NotificationCenter.default.addObserver(forName: UITextField.textDidEndEditingNotification, object:alert.textFields?[0], queue: OperationQueue.main) { (notification) -> Void in
            
            let newPwInput = alert.textFields![0]
            self.isValidPw(newPwInput.text!, alert: alert)
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[0], queue: OperationQueue.main) { (notification) -> Void in
            
            let newPwInput = alert.textFields![0]
            let confirmPwInput = alert.textFields![1]
            
            saveAction.isEnabled = self.isValidPw(newPwInput.text!, alert: alert) && self.isValidConfirmPw(newPwInput.text!, confirmPwInput: confirmPwInput.text!, alert: alert)
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[1], queue: OperationQueue.main) { (notification) -> Void in
                                                                    
            let newPwInput = alert.textFields![0]
            let confirmPwInput = alert.textFields![1]
            
            saveAction.isEnabled = self.isValidConfirmPw(newPwInput.text!, confirmPwInput: confirmPwInput.text!, alert: alert)
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidBeginEditingNotification, object:alert.textFields?[1], queue: OperationQueue.main) { (notification) -> Void in
            
            let newPwInput = alert.textFields![0]
            let confirmPwInput = alert.textFields![1]
            
            self.isValidConfirmPw(newPwInput.text!, confirmPwInput: confirmPwInput.text!, alert: alert)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidConfirmPw(_ pwInput:String, confirmPwInput:String, alert:UIAlertController) ->Bool {
        
        if pwInput != confirmPwInput {
            
            DispatchQueue.main.async {
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.center
                let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm Password and New Password Not Matched"), attributes: convertToOptionalNSAttributedStringKeyDictionary([
                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style,
                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red
                    ]))
                alert.setValue(attributedString, forKey: "attributedMessage")
                
            }
            
            return false
        }else if !self.isValidPw(newPwInput.text!, alert: alert) {
            
            return false
        }else{
            DispatchQueue.main.async {
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.center
                let attributedString = NSAttributedString(string: "", attributes: convertToOptionalNSAttributedStringKeyDictionary([
                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style,
                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red
                    ]))
                alert.setValue(attributedString, forKey: "attributedMessage")
                
            }
        }
        
        return true
    }
    
    func isValidPw(_ pwInput:String, alert:UIAlertController) ->Bool {
        
        //Check if New password equit to appUsername
        if pwInput == Cache_Inspector?.appUserName! {
            print("new password cant be the same as user login name!")
            
            DispatchQueue.main.async {
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.center
                let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("Login Name Cannot Be Used As New Password"), attributes: convertToOptionalNSAttributedStringKeyDictionary([
                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style,
                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red
                    ]))
                alert.setValue(attributedString, forKey: "attributedMessage")
                
            }
            
            return false
        }else if pwInput.characters.count < 8 || pwInput.characters.count > 15 {//Check if New password contains 8 to 15 charators
            DispatchQueue.main.async {
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.center
                let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password should be 8-15 Characters"), attributes: convertToOptionalNSAttributedStringKeyDictionary([
                    convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style,
                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red
                    ]))
                alert.setValue(attributedString, forKey: "attributedMessage")
                
            }
            
            return false
        }
        
        do{
            //Check if New password including Numbers
            let tNumRegularExpression = try NSRegularExpression(pattern: "[0-9]", options: .caseInsensitive)
            let tNumMatchCount = tNumRegularExpression.numberOfMatches(in: pwInput, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, pwInput.characters.count))
        
            if tNumMatchCount < 1 {
                print("match Num count: \(tNumMatchCount)")
            
                DispatchQueue.main.async {
                    let style = NSMutableParagraphStyle()
                    style.alignment = NSTextAlignment.center
                    let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password need to include Numbers"), attributes: convertToOptionalNSAttributedStringKeyDictionary([
                        convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style,
                        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red
                        ]))
                    alert.setValue(attributedString, forKey: "attributedMessage")
                    
                }
            
                return false
            }
            
            //Check if New password including Letters
            let tLetterRegularExpression = try NSRegularExpression(pattern: "[A-Za-z]", options: .caseInsensitive)
            let tLetterMatchCount = tLetterRegularExpression.numberOfMatches(in: pwInput, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, pwInput.characters.count))
            
            if tLetterMatchCount < 1 {
                print("match Letter count: \(tLetterMatchCount)")
                
                DispatchQueue.main.async {
                    let style = NSMutableParagraphStyle()
                    style.alignment = NSTextAlignment.center
                    let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password need to include Letters"), attributes: convertToOptionalNSAttributedStringKeyDictionary([
                        convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style,
                        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red
                        ]))
                    alert.setValue(attributedString, forKey: "attributedMessage")
                    
                }
                
                return false
            }
            
        }catch{
            return false
        }
        
        DispatchQueue.main.async {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            let attributedString = NSAttributedString(string: "", attributes: convertToOptionalNSAttributedStringKeyDictionary([
                convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style,
                convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont.systemFont(ofSize: 15),
                convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red
                ]))
            alert.setValue(attributedString, forKey: "attributedMessage")
                
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.newPwInput || textField == self.confirmPwInput {
            
            if string == " " {
                return false
            }
        }
        
        return true
    }
    
    func configurationNewPwInputTextField(_ textField: UITextField!) {
        print("configurat hire the TextField")
        
        self.newPwInput = textField!        //Save reference to the UITextField
        self.newPwInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password")
        self.newPwInput.isSecureTextEntry = true
        self.newPwInput.delegate = self
        
    }
    
    func configurationConfirmPwInputTextField(_ textField: UITextField!) {
        print("configurat hire the TextField")
        
        self.confirmPwInput = textField!        //Save reference to the UITextField
        self.confirmPwInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm Password")
        self.confirmPwInput.isSecureTextEntry = true
        self.confirmPwInput.delegate = self
        
    }
    
    func handleCancel(_ alertView: UIAlertAction!){
        print("User click Cancel button")
        print(self.newPwInput.text)
    }
    
    @IBAction func userClear(_ sender: UIButton) {
        NSLog("userClear")
        
        self.username.text = ""
        self.password.text = ""
    }
    
    @IBAction func userForgetUsername(_ sender: UIButton) {
        NSLog("userForgetUsername")
        
    }
    
    @IBAction func userForgetPassword(_ sender: UIButton) {
        NSLog("userForgetPassword")
       
    }
    
    func updateLocalizedString() {
        NSLog("updateLocalizedString")
        
        self.usernameLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Username")
        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Password")
        self.languageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Language")
        self.loginButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login"), for: UIControl.State())
        self.clearButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), for: UIControl.State())
        self.forgetUserNameButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Forget Username?"), for: UIControl.State())
        self.forgetPasswordButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Forget Password?"), for: UIControl.State())
        self.versionCode.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Version")+" \(_VERSION)"
    }
    
    func isBackupDateOverNdays(_ N:Double = 3) ->Bool {
        
        let keyValueDataHelper = KeyValueDataHelper()
        let lastDownloadDateInString = keyValueDataHelper.getLastDownloadDatetimeByUserId(String((Cache_Inspector?.inspectorId)!))
        
        if lastDownloadDateInString != "" {
        
            let now = Date.init()
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            let lastDownloadDate = dateFormatter.date(from: lastDownloadDateInString)
            let NDaysAgo = now.addingTimeInterval(-60*60*(24*N))
            let timeBetween3Days = now.timeIntervalSince(NDaysAgo)
            let timeBetweenBacupDays = now.timeIntervalSince(lastDownloadDate!)
            
            if timeBetween3Days < timeBetweenBacupDays {
            
                return true
            }
        }
        
        let lastUploadDateInString = keyValueDataHelper.getLastUploadDatetimeByUserId(String((Cache_Inspector?.inspectorId)!))
        
        if lastUploadDateInString != "" {
            
            let now = Date.init()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            let lastUploadDate = dateFormatter.date(from: lastUploadDateInString)
            let NDaysAgo = now.addingTimeInterval(-60*60*(24*N))
            let timeBetween3Days = now.timeIntervalSince(NDaysAgo)
            let timeBetweenBacupDays = now.timeIntervalSince(lastUploadDate!)
            
            if timeBetween3Days < timeBetweenBacupDays {
                
                return true
            }
        }
        
        return false
    }
    
    func calculateTimeDifferenceWithStartDate(_ startDate:Date, endDate:Date) ->DateComponents {
        
        let calendar = Calendar.current
        let unitFlags = NSCalendar.Unit.day
        
        return (calendar as NSCalendar).components(unitFlags, from: startDate, to: endDate, options: NSCalendar.Options.init(rawValue: 0))
    }
    
    func copyAppInfoFile(_ needUpdate:Bool = false) {
        //CPY App Info XML to Inspector Folder
        let filemgr = FileManager.default
        do{
            /*
             if filemgr.fileExistsAtPath("\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo") {
             try filemgr.removeItemAtPath("\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
             try filemgr.copyItemAtPath(self.view.getPreferencesFilePath()!, toPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
             }else{
             try filemgr.copyItemAtPath(self.view.getPreferencesFilePath()!, toPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
             }*/
            
            if needUpdate {
                if filemgr.fileExists(atPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercased())!)/AppInfo") {
                    try filemgr.removeItem(atPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercased())!)/AppInfo")
                }
                
                if filemgr.fileExists(atPath: self.view.getPreferencesFilePath()!) {
                    try filemgr.copyItem(atPath: self.view.getPreferencesFilePath()!, toPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercased())!)/AppInfo")
                }
                
            }else if !filemgr.fileExists(atPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercased())!)/AppInfo") {
                
                if filemgr.fileExists(atPath: self.view.getPreferencesFilePath()!) {
                    try filemgr.copyItem(atPath: self.view.getPreferencesFilePath()!, toPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercased())!)/AppInfo")
                }
            }
            
        }catch let error as NSError{
            self.view.alertView("CPY App Info: "+error.localizedDescription)
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

extension ViewController {
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        segue.destination.modalPresentationStyle = .overFullScreen// .fullScreen
        if let vc = segue.destination as? ContainerViewController {
            vc.resetLogonItems = {
                self.initLoginStatus()
            }
        }
    }
}

extension ViewController {
    func setupView() {
//        loginButton.titleLabel?.numberOfLines = 1
//        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        loginButton.titleLabel?.lineBreakMode = .byClipping
//        
//        clearButton.titleLabel?.numberOfLines = 1
//        clearButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        clearButton.titleLabel?.lineBreakMode = .byClipping
//        
//        forgetPasswordButton.titleLabel?.numberOfLines = 1
//        forgetPasswordButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        forgetPasswordButton.titleLabel?.lineBreakMode = .byClipping
//        
//        forgetUserNameButton.titleLabel?.numberOfLines = 1
//        forgetUserNameButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        forgetUserNameButton.titleLabel?.lineBreakMode = .byClipping
    }
}
