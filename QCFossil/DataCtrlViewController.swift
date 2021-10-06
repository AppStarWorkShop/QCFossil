//
//  DataCtrlViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 6/5/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DataCtrlViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate, SSZipArchiveDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backupListTableView: UITableView!
    @IBOutlet weak var loginUserLabel: UILabel!
    @IBOutlet weak var lastLoginDate: UILabel!
    @IBOutlet weak var lastDownload: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginUserInput: UILabel!
    @IBOutlet weak var lastLoginDateInput: UILabel!
    @IBOutlet weak var lastDownloadInput: UILabel!
    @IBOutlet weak var lastUpdateInput: UILabel!
    @IBOutlet weak var backupBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var restoreDataBtn: UIButton!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backupDesc: UITextView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var btnsPanel: UIView!
    @IBOutlet weak var activityActor: UIActivityIndicatorView!
    @IBOutlet weak var backupHistoryLabel: UILabel!
    @IBOutlet weak var upperLine: UILabel!
    @IBOutlet weak var downLine: UILabel!
    @IBOutlet weak var dataControlStatusDetailButton: UIButton!
    
    typealias CompletionHandler = (_ obj:AnyObject?, _ success: Bool?) -> Void
    var filePath = NSHomeDirectory() + "/Documents"
    var zipPath5 = NSHomeDirectory() + "/task.zip"
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var bgSession: Foundation.URLSession?
    var fgSession: Foundation.URLSession?
    var sessionDownloadTask: URLSessionDownloadTask?
    var backupFileList = [BackupFile]()
    var selectedBackupFile:BackupFile!
    var pWInput:UITextField!
    let typeListBackupFiles = "L"
    let typeBackup = "B"
    let typeRestore = "R"
    var typeNow = ""
    let keyValueDataHelper = KeyValueDataHelper()
    var errorMessage = ""
    
    struct BackupFile {
        var appRealse:String
        var appVersion:String
        var backupProcessDate:String
        var backupRemarks:String
        var backupSyncId:String
        var deviceId:String
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateLocalizedString()
        
        //bgSession = backgroundSession
        //fgSession = defaultSession
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = true
        
        fgSession = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        configuration = URLSessionConfiguration.background(withIdentifier: "com.pacmobile.fossilqc")
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = true
        
        self.dataControlStatusDetailButton.isHidden = true
        
        bgSession = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        if Cache_Inspector?.appUserName == "" {
            self.view.alertView("No Login User Found!")
            return
        }
        
        initPage()
    
    }
    
    func updateDataControlStatusDetailButton(_ isHidden: Bool = false) {
        DispatchQueue.main.async(execute: {
            self.dataControlStatusDetailButton.isHidden = isHidden
        })
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("All tasks are finished")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            completionHandler()
        }
        
        print("All tasks are finished")
    }
    
    func updateButtonsStatus(_ status:Bool) {
        DispatchQueue.main.async(execute: {
            self.backupBtn.isEnabled = status
            self.removeBtn.isEnabled = status
            self.restoreBtn.isEnabled = status
            self.restoreDataBtn.isEnabled = status
            
            if status {
                self.backupBtn.backgroundColor = _FOSSILBLUECOLOR
                self.removeBtn.backgroundColor = _FOSSILBLUECOLOR
                self.restoreBtn.backgroundColor = _FOSSILBLUECOLOR
                self.restoreDataBtn.backgroundColor = _FOSSILBLUECOLOR
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":true])
            }else{
                self.backupBtn.backgroundColor = UIColor.gray
                self.removeBtn.backgroundColor = UIColor.gray
                self.restoreBtn.backgroundColor = UIColor.gray
                self.restoreDataBtn.backgroundColor = UIColor.gray
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
            }
            
        })
    }
    
    func initPage() {
        
        self.backupHistoryLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup History")
        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please input description for backup data.")
        self.descLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Remarks")
        self.loginUserLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Login User")
        self.lastLoginDate.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Login")
        self.lastDownload.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Restore")
        self.lastUpdate.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Backup")
        self.passwordLabel.text = ""
        self.backupBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data"), for: UIControl.State())
        self.restoreDataBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup History List"), for: UIControl.State())
        self.restoreBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore"), for: UIControl.State())
        self.lastLoginDateInput.text = Cache_Inspector?.lastLoginDate
        self.removeBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Login User Data"), for: UIControl.State())
        
//        let keyValueDataHelper = KeyValueDataHelper()
        self.lastUpdateInput.text = keyValueDataHelper.getLastBackupDatetimeByUserId(String(describing: Cache_Inspector?.inspectorId))
        self.lastDownloadInput.text = keyValueDataHelper.getLastRestoreDatetimeByUserId(String(describing: Cache_Inspector?.inspectorId))
        self.loginUserInput.text = Cache_Inspector?.appUserName!
        
        self.view.setButtonCornerRadius(self.backupBtn)
        self.view.setButtonCornerRadius(self.restoreDataBtn)
        self.view.setButtonCornerRadius(self.restoreBtn)
        self.view.setButtonCornerRadius(self.clearBtn)
        self.view.setButtonCornerRadius(self.removeBtn)
        self.activityActor.isHidden = true
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        zipPath5 = path + "/task.zip"
        filePath = filePath + "/\((Cache_Inspector?.appUserName?.lowercased())!)"
        
        self.backupListTableView.delegate = self
        self.backupListTableView.dataSource = self
        self.backupListTableView.rowHeight = 120
        self.backupListTableView.isHidden = true
        self.backupHistoryLabel.isHidden = true
        self.restoreBtn.isHidden = true
        self.upperLine.isHidden = true
        self.downLine.isHidden = true
        
        self.typeNow = self.typeListBackupFiles
        self.buffer.setData(NSMutableData() as Data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocalizedString(){
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Control")
        
    }
    
    func zipArchiveProgressEvent(_ loaded: UInt64, total: UInt64) {
        print("loaded: \(loaded) total: \(total)")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let percentageUploaded = Float(loaded) / Float(total)
            
            DispatchQueue.main.async(execute: {
                
                self.progressBar.progress = percentageUploaded
                
                if loaded == total {
                //if lroundf(100*percentageUploaded) == 100 {
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Complete")
                    
//                    let keyValueDataHelper = KeyValueDataHelper()
                    self.keyValueDataHelper.updateLastRestoreDatetime(String(describing: Cache_Inspector?.inspectorId), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                    
                    
                    self.lastDownloadInput.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                    self.updateButtonsStatus(true)
                    self.backupListTableView.isHidden = true
                    self.backupHistoryLabel.isHidden = true
                    self.restoreBtn.isHidden = true
                    self.upperLine.isHidden = true
                    self.downLine.isHidden = true
                    
                }else{
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Decompressing")) \(String(lroundf(100*percentageUploaded)))%"
                    
                }
            })
        }
    }
    
    //在Caches文件夹下随机创建一个文件夹，并返回路径
    func tempDestPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        path += "/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            
            return url.path
        } catch {
            return nil
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func MenuButton(_ sender: UIBarButtonItem) {
        NSLog("Toggle Menu")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
    }
    
    @IBAction func backupDataClick(_ sender: UIButton) {
        updateDataControlStatusDetailButton(true)
        self.typeNow = self.typeBackup
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data")+"?",parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            if self.backupDesc.text == "" {
                self.errorMsg.isHidden = false
                return
                
            }else{
                self.errorMsg.isHidden = true
            }
            
            DispatchQueue.main.async(execute: {
                self.activityActor.isHidden = false
                self.activityActor.startAnimating()
                self.updateButtonsStatus(false)
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Compressing Data...")
                
                DispatchQueue.main.async(execute: {
                    self.activityActor.isHidden = true
                    self.activityActor.stopAnimating()
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
                    //---------------------------- Backup Data First ------------------------------
                    //需要压缩的文件夹啊
                    SSZipArchive.createZipFile(atPath: self.zipPath5, withContentsOfDirectory: self.filePath)
                    //-----------------------------------------------------------------------------
                    
                    var param = _DS_UPLOADDBBACKUP["APIPARA"] as! [String:String]
                    param["service_token"] = _DS_SERVICETOKEN
                    param["db_filename"] = "task.zip"
                    param["db_file"] = self.zipPath5
                    param["backup_remarks"] = self.backupDesc.text
                    param["app_version"] = String(_VERSION)
                    param["app_release"] = _RELEASE
                    
                    let request = self.createBackupRequest(param, url: URL(string: _DS_UPLOADDBBACKUP["APINAME"] as! String)!)
                    if UIApplication.shared.applicationState == .active {
                        
                        // foreground
                        self.sessionDownloadTask = self.fgSession?.downloadTask(with: request)
                        self.sessionDownloadTask?.resume()
                    } else {
                        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sync Failed when iPad in Sleep Mode")
                        self.updateButtonsStatus(true)
                        self.errorMessage = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please avoid to press home/power button or show up control center when data sync in progress.")
                        self.updateDataControlStatusDetailButton()
                    }
                })
            })
        })
    }
    
    func createBackupRequest (_ param: [String: String], url:URL) -> URLRequest {
        
        let boundary = self.generateBoundaryString()
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBackupBodyWithParameters(param, boundary: boundary)
        
        return request as URLRequest
    }
    
    func createBackupBodyWithParameters(_ parameters: [String: String], boundary: String) -> Data {
        let body = NSMutableData()
        
        //if parameters != nil {
        for (key, value) in parameters {
            if key != "db_file" {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }else{
                
                let url = URL(fileURLWithPath: value)
                let data = try? Data(contentsOf: url)
                
                if data == nil {
                    self.view.alertView("No Zip File Found!")
                    return NSMutableData() as Data
                }
                
                let mimetype = mimeTypeForPath(value)
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"task.zip\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data!)
                body.appendString("\r\n")
            }
        }
        //}
        
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func mimeTypeForPath(_ path: String) -> String {
        return  "application/zip"
        //return "application/x-sqlite3";
    }
    
    func createRequest (_ param:String, url: URL) -> URLRequest {
        
        let boundary = self.generateBoundaryString()
        let body = NSMutableData()
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"req_msg\"\r\n\r\n")
        body.appendString("\(param)\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        let request = NSMutableURLRequest(url: url)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.httpBody = body as Data
        request.httpShouldHandleCookies = false
        
        return request as URLRequest
    }
    
    @IBAction func removeOnClick(_ sender: UIButton) {
        
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Cleanup?"),parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            self.handlePwChangeBeforeRedirect()
            
        })
    }
    
    func handlePwChangeBeforeRedirect() {
        let alert = UIAlertController(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Input Your Password"), message: "", preferredStyle: UIAlertController.Style.alert)
        let saveAction = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
                let inspectorDataHelper = InspectorDataHelper()
                let inspector = inspectorDataHelper.getInspector((Cache_Inspector?.appUserName!)!, password: self.pWInput.text!.md5())
                
                if (inspector == nil) {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Password Not Correct!"))
                    return
                    
                }else{
                    DispatchQueue.main.async(execute: {
                        self.view.showActivityIndicator()
                        
                        DispatchQueue.main.async(execute: {
                            //remove file before restortion
                            let filemgr = FileManager.default
                            let taskFilePath = self.filePath
                    
                            do {
                                if filemgr.fileExists(atPath: taskFilePath) {
                                    let fileNames = try filemgr.contentsOfDirectory(atPath: "\(taskFilePath)")
                                    print("all files in folder: \(fileNames)")
                                    for fileName in fileNames {
                                        let filePathName = "\(taskFilePath)/\(fileName)"
                                        try filemgr.removeItem(atPath: filePathName)
                                
                                    }
                                    //delete folder
                                    try filemgr.removeItem(atPath: taskFilePath)
                                }
                        
                                self.view.removeActivityIndicator()
                                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Suceess."), handlerFun: { action in
                                    self.dismiss(animated: true, completion: nil)
                            
                                })
                            } catch {
                                print("Could not clear temp folder: \(error)")
                            }
                        })
                    })
                }
 
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }
        })
        
        alert.addTextField(configurationHandler: self.configurationPwInputTextField)
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func configurationPwInputTextField(_ textField: UITextField!) {
        print("configurat hire the TextField")
        
        self.pWInput = textField!        //Save reference to the UITextField
        self.pWInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Input Your Password")
        self.pWInput.isSecureTextEntry = true
        
    }
    
    @IBAction func restoreDataOnClick(_ sender: UIButton) {
        updateDataControlStatusDetailButton(true)
        self.typeNow = self.typeListBackupFiles
        
        DispatchQueue.main.async(execute: {
            self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Listing Backup Files..."))"
        })
        
        //self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Data")+"?",parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            var param = "{"
            for (key, value) in _DS_LISTDBBACKUP["APIPARA"] as! Dictionary<String,String> {
                
                if key == "service_token" {
                    param += "\"\(key)\":\"\(_DS_SERVICETOKEN)\","
                }else if key == "app_version" {
                    param += "\"\(key)\":\"\(String(_VERSION))\","
                }else if key == "app_release" {
                    param += "\"\(key)\":\"\(_RELEASE)\","
                }else{
                    param += "\"\(key)\":\"\(value)\","
                }
                
            }
            param += "}"
            param = param.replacingOccurrences(of: ",}", with: "}")
            self.updateButtonsStatus(false)
        
            let request = self.createRequest(param, url: URL(string: _DS_LISTDBBACKUP["APINAME"] as! String)!)
            if UIApplication.shared.applicationState == .active {
            
                // foreground
                self.sessionDownloadTask = self.fgSession?.downloadTask(with: request)
                self.sessionDownloadTask?.resume()
            } else {
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sync Failed when iPad in Sleep Mode")
                self.updateButtonsStatus(true)
                self.errorMessage = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please avoid to press home/power button or show up control center when data sync in progress.")
                self.updateDataControlStatusDetailButton()
            }
    }

    //------------------------------------- Delegate Funcs --------------------------------------------------------
    func URLSession(_ session: Foundation.URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (Foundation.URLSession.ResponseDisposition) -> Void) {
        
        //here you can get full lenth of your content
        expectedContentLength = Int(response.expectedContentLength)
        print("expectedContentLength: \(expectedContentLength)")
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("bytesSent: \(bytesSent) totalBytesSent: \(totalBytesSent) totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let percentageUploaded = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            
            DispatchQueue.main.async(execute: {
                self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Uploading Backup File:")) \(String(lroundf(100*percentageUploaded)))%"
                self.progressBar.progress = percentageUploaded
            })
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        self.bgSession!.finishTasksAndInvalidate()
        self.fgSession!.finishTasksAndInvalidate()
        print("Complete, Clear Session")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下载完成")
        
        buffer.setData(try! Data.init(contentsOf: location))
        
        if self.typeNow == self.typeRestore {
        
        if Cache_Inspector?.appUserName == "" {
            self.view.alertView("No Login User Found.")
            return
        }
        
        DispatchQueue.main.async(execute: {
            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Local Data...")
        })
        
        //dispatch_async(dispatch_get_main_queue(), {
        //---------------------------- Backup Data First ------------------------------
        //需要压缩的文件夹啊
        SSZipArchive.createZipFile(atPath: self.zipPath5, withContentsOfDirectory: self.filePath)
            
        //remove file before restortion
        let filemgr = FileManager.default
        let taskFilePath = self.filePath //+ "/Tasks/"
            
        do {
            if filemgr.fileExists(atPath: taskFilePath) {
                let fileNames = try filemgr.contentsOfDirectory(atPath: "\(taskFilePath)")
                print("all files in folder: \(fileNames)")
                for fileName in fileNames {
                    let filePathName = "\(taskFilePath)/\(fileName)"
                    try filemgr.removeItem(atPath: filePathName)
                    
                }
                //delete folder
                try filemgr.removeItem(atPath: taskFilePath)
            }
                
        } catch {
            print("Could not clear temp folder: \(error)")
            let _error = error as NSError
            self.errorMessage = "\(_error.localizedDescription ?? "" )"
            self.updateDataControlStatusDetailButton()
        }
            
                    
        DispatchQueue.main.async(execute: {
            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore In Progress...")
        })
        
        //begin restore
        do {
            if try SSZipArchive.unzipFileAtPath(location.path, toDestination: self.filePath, overwrite: true, password: "", delegate: self) {
                // Check DB version if low, then upgrade
                let backupFile = self.selectedBackupFile
                if (backupFile?.appVersion)! < _VERSION {
                    let appUpgradeDataHelper = AppUpgradeDataHelper()
                    appUpgradeDataHelper.appUpgradeCode(_VERSION, parentView: self.view, completion: { (result) in
                        if result {
                            self.keyValueDataHelper.updateDBVersionNum(_VERSION)
                        }
                    })
                }
                
                //Remove Zip File Here
                self.removeLocalBackupZipFile()
            }
          
        } catch {
            let _error = error as NSError
            self.errorMessage = "\(_error.localizedDescription ?? "" )"
            self.updateDataControlStatusDetailButton()
            
            do{
                try SSZipArchive.unzipFileAtPath(self.zipPath5, toDestination: self.filePath, overwrite: true, password: "", delegate: self)
                
                //Remove Zip File Here
                self.removeLocalBackupZipFile()
                
            }catch{
                print(error)
                let _error = error as NSError
                self.errorMessage = "\(_error.localizedDescription ?? "" )"
                self.updateDataControlStatusDetailButton()
                DispatchQueue.main.async(execute: {
                    self.passwordLabel.text = "\(error)"
                })
            }
            
            print(error)
            DispatchQueue.main.async(execute: {
                self.passwordLabel.text = "\(error)"
            })
        }
        
        self.updateButtonsStatus(true)
        //Send local notification for Task Done.
        self.presentLocalNotification("Data Restore Complete.")
        }
    }
    
    //Download Task Process
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("正在下载 \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
        
        print("totalBytesSent: \(totalBytesWritten) totalBytesExpectedToSend: \(totalBytesExpectedToWrite)")
        DispatchQueue.global(qos: .userInitiated).async {
            let percentageUploaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            DispatchQueue.main.async(execute: {
                
                if lroundf(100*percentageUploaded) >= 100 {
                    
                    if self.typeNow == self.typeRestore {
                        self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore In Progress..."))"
                    }else if self.typeNow == self.typeBackup {
                        
                        self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup In Progress..."))"
                    }
                    
                }else{
                    
                    if self.typeNow == self.typeRestore {
                        self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Downloading Backup File:")) \(String(lroundf(100*percentageUploaded)))%"
                    }else if self.typeNow == self.typeBackup {
                        self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Uploading Backup File:")) \(String(lroundf(100*percentageUploaded)))%"
                        
                    }
                    
                }
                
                self.progressBar.progress = percentageUploaded
            })
        }
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if(error != nil) {
            
            buffer.setData(NSMutableData() as Data)
            var errorMsg = ""
            
            if error?._code == NSURLErrorTimedOut {
                errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sync Failed due to Network Issue")
                self.updateButtonsStatus(true)
            }else if error?._code == NSURLErrorNotConnectedToInternet || error?._code == NSURLErrorCannotConnectToHost {
                errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("App is in Offline Mode and unable to proceed Data Download.")
            }else{
                errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("Network Request Failed with Unknown Reason!")
            }
            self.errorMessage = "\(error?.localizedDescription ?? "") with code: \(error?._code)"
            
            if UIApplication.shared.applicationState != .active {
                errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sync Failed when iPad in Sleep Mode")
                self.errorMessage = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please avoid to press home/power button or show up control center when data sync in progress.")
            }
            
            self.updateButtonsStatus(true)
            updateDataControlStatusDetailButton()
            DispatchQueue.main.async(execute: {
                self.progressBar.progress = 0
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(errorMsg)
            })
            
            //Remove Zip File Here
            self.removeLocalBackupZipFile()
            
        }else if self.typeNow == self.typeListBackupFiles {
            
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: buffer as Data, options: []) as? NSDictionary {
                    print("success == \(responseDictionary)")
                    
                    if responseDictionary.count > 0 {
                        print("Name: \(responseDictionary["app_db_backup_list"])")
                        self.backupFileList = [BackupFile]()
                        let appBackupList = responseDictionary["app_db_backup_list"] as! [[String : String]]
                        for info in appBackupList {
                            
                            let backupFile = BackupFile(appRealse: info["app_release"]!, appVersion: info["app_version"]!, backupProcessDate: info["backup_process_date"]!, backupRemarks: info["backup_remarks"]!, backupSyncId: info["backup_sync_id"]!, deviceId: info["device_id"]!)
                            self.backupFileList.append(backupFile)
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.updateButtonsStatus(true)
                            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("List Backup History Complete")
                            self.progressBar.progress = 100
                            self.backupListTableView.reloadData()
                            self.backupListTableView.isHidden = false
                            self.backupHistoryLabel.isHidden = false
                            self.restoreBtn.isHidden = false
                            self.upperLine.isHidden = false
                            self.downLine.isHidden = false
                            
                        })
                    }
                }
                
            } catch {
                DispatchQueue.main.async(execute: {
                    let error = error as NSError
                    self.updateButtonsStatus(true)
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString(error.localizedDescription))"
                    self.errorMessage = "\(error.localizedDescription ?? "" )"
                    self.updateDataControlStatusDetailButton()
                })
            }
            buffer.setData(NSMutableData() as Data)
        }else if self.typeNow == self.typeBackup {
            
            do {
                
                if let responseDictionary = try JSONSerialization.jsonObject(with: buffer as Data, options: []) as? NSDictionary {
                    
                    if responseDictionary.count > 0 {
                        
                        if let result = responseDictionary["ul_result"] as? String {
                            
                            if result == "OK" {
                                let keyValueDataHelper = KeyValueDataHelper()
                                _ = keyValueDataHelper.updateLastBackupDatetime(String(describing: Cache_Inspector?.inspectorId), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                                self.lastUpdateInput.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                                
                                DispatchQueue.main.async(execute: {
                                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Complete")
                                    self.progressBar.progress = 100
                                    self.updateButtonsStatus(true)
                                    self.backupDesc.text = ""
                                    self.backupListTableView.isHidden = true
                                    self.backupHistoryLabel.isHidden = true
                                    self.upperLine.isHidden = true
                                    
                                    //Send local notification for Task Done.
                                    self.presentLocalNotification("Data Backup Complete.")
                                })
                                
                                //Remove Zip File Here
                                self.removeLocalBackupZipFile()
                            }
                        }
                    }
                }
                
            } catch {
                DispatchQueue.main.async(execute: {
                    print(error)
                    
                    let error = error as NSError
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Failed!"))\(MylocalizedString.sharedLocalizeManager.getLocalizedString(error.localizedDescription))"
                    
                    self.removeLocalBackupZipFile()
                    let responseString = NSString(data: self.buffer as Data, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(responseString)")
                    self.errorMessage = "\(error.localizedDescription ?? "" )"
                    self.updateDataControlStatusDetailButton()
                })
            }
            
            buffer.setData(NSMutableData() as Data)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("从 \(fileOffset) 处恢复下载，一共 \(expectedTotalBytes)")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.backupFileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backupFile = self.backupFileList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BackupFileCell", for: indexPath) as! BackupTableViewCell
        
        cell.appReleaseInput.text = backupFile.appRealse
        cell.appVersionInput.text = backupFile.appVersion
        cell.backupProcessDateInput.text = backupFile.backupProcessDate
        cell.backupRemarksInput.text = backupFile.backupRemarks
        cell.loginUserNameInput.text = Cache_Inspector?.appUserName
        
        if backupFile.backupProcessDate != "" {
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "\(_DATEFORMATTER) HH:mm"
            
            let locale2:Locale = Locale(identifier: "en_US")
            let timezone2:TimeZone = TimeZone(secondsFromGMT: 28800)!
            let dateFormatter2:DateFormatter = DateFormatter()
            dateFormatter2.dateFormat = "\(_DATEFORMATTER) hh:mm:ss a"
            dateFormatter2.locale = locale2
            dateFormatter2.timeZone = timezone2
            
            cell.backupProcessDateInput.text = dateFormatter.string(from: dateFormatter2.date(from: backupFile.backupProcessDate)!)
        }
        
        if backupFile.appRealse != "" {
            let dateTmp = backupFile.backupProcessDate
            let dateTmpArray = dateTmp.characters.split{$0 == " "}.map(String.init)
            
            if dateTmpArray.count>0 {
                cell.appReleaseInput.text = dateTmpArray[0]
                
                let dateFormatter:DateFormatter = DateFormatter()
                dateFormatter.dateFormat = _DATEFORMATTER
                cell.appReleaseInput.text = dateFormatter.string(from: dateFormatter.date(from: cell.appReleaseInput.text!)!)
            }
        }
        
        cell.backupRemarksInput.font = UIFont.systemFont(ofSize: 17)
        
        return cell
    }
    
    @IBAction func restoreBtnOnClick(_ sender: UIButton) {
        updateDataControlStatusDetailButton(true)
        self.typeNow = self.typeRestore
        
        if self.selectedBackupFile == nil {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select One Backup Record"))
            return
        }
        
        if self.selectedBackupFile.appVersion > _VERSION {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Current app version not support this DB version!"))
            return
        }

        
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Data")+"?",parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            let backupFile = self.selectedBackupFile
            
            var param = "{"
            for (key, value) in _DS_DBBACKUPDOWNLOAD["APIPARA"] as! Dictionary<String,String> {
                
                if key == "service_token" {
                    param += "\"\(key)\":\"\(_DS_SERVICETOKEN)\","
                }else if key == "backup_sync_id", let backupSyncId = backupFile?.backupSyncId {
                    param += "\"\(key)\":\"\(backupSyncId)\","
                }else{
                    param += "\"\(key)\":\"\(value)\","
                }
                
            }
            param += "}"
            param = param.replacingOccurrences(of: ",}", with: "}")
            
            self.updateButtonsStatus(false)
            let request = self.createRequest(param, url: URL(string: _DS_DBBACKUPDOWNLOAD["APINAME"] as! String)!)
            if UIApplication.shared.applicationState == .active {
                
                // foreground
                self.sessionDownloadTask = self.fgSession?.downloadTask(with: request)
                self.sessionDownloadTask!.resume()
            } else {
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sync Failed when iPad in Sleep Mode")
                self.updateButtonsStatus(true)
                self.errorMessage = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please avoid to press home/power button or show up control center when data sync in progress.")
                self.updateDataControlStatusDetailButton()
            }
            
            //self.sessionDownloadTask = self.session?.downloadTaskWithRequest(request)
            //self.sessionDownloadTask?.resume()
        })
    }
    
    @IBAction func clearBackupHistory(_ sender: UIButton) {
        self.backupListTableView.isHidden = true
        self.backupHistoryLabel.isHidden = true
        self.restoreBtn.isHidden = true
        self.upperLine.isHidden = true
        self.downLine.isHidden = true
        updateDataControlStatusDetailButton(true)
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBackupFile = self.backupFileList[indexPath.row]
    }
    
    func removeLocalBackupZipFile() {
        //Remove Zip File Here
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            print("Remove Zip File Here on the Background Queue.")
            let filemgr = FileManager.default
            do {
                
                if filemgr.fileExists(atPath: self.zipPath5) {
                    try filemgr.removeItem(atPath: self.zipPath5)
                }
                
            } catch {
                print("Could not clear Zip file: \(error)")
                let _error = error as NSError
                self.errorMessage = "\(_error.localizedDescription ?? "" )"
                self.updateDataControlStatusDetailButton()
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                print("Zip File has been Removed Successfully!")
            })
        })
    }
    
    @IBAction func dataControlStatusDetailButtonDidPress(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 640, height: 320)
        
        popoverContent.dataType = _DOWNLOADTASKSTATUSDESC
        popoverContent.selectedValue = self.errorMessage
        
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.tintColor = UIColor.black
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .black
            nav.navigationBar.standardAppearance = navBarAppearance
            nav.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
        let popover = nav.popoverPresentationController
        popover?.delegate = sender.parentVC as? PopoverMaster
        popover?.sourceView = sender
        popover?.sourceRect = CGRect(x: 0,y: 0,width: sender.frame.size.width,height: sender.frame.size.height)
        
        sender.parentVC?.present(nav, animated: true, completion: nil)
    }
}
