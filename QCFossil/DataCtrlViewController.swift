//
//  DataCtrlViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 6/5/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit
import Zip

class DataCtrlViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate, UITableViewDelegate, UITableViewDataSource {

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
    @IBOutlet weak var backupTaskCountLabel: UILabel!
    @IBOutlet weak var backupRetryButton: UIButton!
    
    typealias CompletionHandler = (_ obj:AnyObject?, _ success: Bool?) -> Void
    var filePath = NSHomeDirectory() + "/Documents/\(Cache_Inspector?.appUserName ?? "")/fossil_qc_prd_\(Cache_Inspector?.appUserName ?? "")"
    var appInfofilePath = NSHomeDirectory() + "/Documents/\(Cache_Inspector?.appUserName ?? "")/AppInfo"
    let backupFilePathBeforeRestore = NSHomeDirectory() + "/Documents/\(Cache_Inspector?.appUserName ?? "")"
    let backupFileSavePathBeforeRestore = NSHomeDirectory() + "/Documents/\(Cache_Inspector?.appUserName ?? "").zip"
    let rollbackFilePath = NSHomeDirectory() + "/Documents/rollback_\(Cache_Inspector?.appUserName ?? "")"
    var zipPath5 = NSHomeDirectory() + "/\(dbBackupFileName)"
    let tmpPath = NSHomeDirectory() + "/tmp"
    let restoreDBFilePath = NSHomeDirectory() + "/Documents/\(Cache_Inspector?.appUserName ?? "")"
    let restoreFolderPath = NSHomeDirectory() + "/Documents/\(Cache_Inspector?.appUserName ?? "")/Tasks"
    let backupFolderToZipPath = NSHomeDirectory() + "/Documents/\(Cache_Inspector?.appUserName ?? "")/Tasks/%@"
    let tempZipFolderPath = NSHomeDirectory() + "/Documents/\(Cache_Inspector?.appUserName ?? "")/TempZipFiles"
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
    let typeTaskFolderBackup = "T"
    let typeTaskFolderDownload = "TFD"
    var typeNow = ""
    let keyValueDataHelper = KeyValueDataHelper()
    var errorMessage = ""
    var taskFolders: [String]? = nil
    var currentUploadTaskFolderName: String? = nil
    var taskFolderCount: Int = 0
    var serviceSession: String? = nil
    var taskZipFolderDownloadIndex = 1
    var taskFolderDownloadCount: Int = 0
    
    struct BackupFile {
        var appRealse: String
        var appVersion: String
        var backupProcessDate: String
        var backupRemarks: String
        var backupSyncId: String
        var deviceId: String
        var taskCount: String
    }

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
        
        updateLocalizedString()
        
        //bgSession = backgroundSession
        //fgSession = defaultSession
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1800
        configuration.timeoutIntervalForResource = 1800
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
            self.dataControlStatusDetailButton?.isHidden = isHidden
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
        self.backupRetryButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Retry"), for: .normal)
        
        self.lastUpdateInput.text = keyValueDataHelper.getLastBackupDatetimeByUserId(String(describing: Cache_Inspector?.inspectorId))
        self.lastDownloadInput.text = keyValueDataHelper.getLastRestoreDatetimeByUserId(String(describing: Cache_Inspector?.inspectorId))
        self.loginUserInput.text = Cache_Inspector?.appUserName!
        
        self.view.setButtonCornerRadius(self.backupBtn)
        self.view.setButtonCornerRadius(self.restoreDataBtn)
        self.view.setButtonCornerRadius(self.restoreBtn)
        self.view.setButtonCornerRadius(self.clearBtn)
        self.view.setButtonCornerRadius(self.removeBtn)
        self.view.setButtonCornerRadius(self.backupRetryButton)
        self.activityActor.isHidden = true
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        zipPath5 = path + "/\(dbBackupFileName)"

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
        self.backupTaskCountLabel.text = ""
        self.backupTaskCountLabel.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocalizedString(){
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Control")
        
    }
    
    //在Caches文件夹下随机创建一个文件夹，并返回路径
    func tempDestPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
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
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data")+"?",parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            self.updateDataControlStatusDetailButton(true)
            self.backupRetryButton.isHidden = true
            self.passwordLabel.text = ""
            self.typeNow = self.typeBackup
            
            // clear temp zip folder before backup
            DataControlHelper.clearTempZipFolders(tempZipFolderPath: self.tempZipFolderPath)
            
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
                self.backupTaskCountLabel.isHidden = false
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Compressing Data...")
                
                DispatchQueue.main.async(execute: {
                    self.activityActor.isHidden = true
                    self.activityActor.stopAnimating()
                    //---------------------------- Backup Data First ------------------------------
                    //需要压缩的文件夹啊
                    do {
                        if let filePath = URL(string: self.filePath), let appInfoFilePath = URL(string: self.appInfofilePath), let zipFilePath = URL(string: self.zipPath5) {
                            try Zip.zipFiles(paths: [filePath, appInfoFilePath], zipFilePath: zipFilePath, password: nil, progress: nil)
                            
                            var param = _DS_UPLOADDBBACKUP["APIPARA"] as! [String:String]
                            param["service_token"] = _DS_SERVICETOKEN
                            param["db_filename"] = "\(dbBackupFileName)"
                            param["db_file"] = self.zipPath5
                            param["backup_remarks"] = self.backupDesc.text
                            param["app_version"] = String(_VERSION)
                            param["app_release"] = _RELEASE
                            if let taskCount = DataControlHelper.getInspectorTaskFolderCount(inspectorName: Cache_Inspector?.appUserName?.lowercased() ?? "") {
                                if let message = taskCount.1 {
                                    DispatchQueue.main.async(execute: {
                                        self.errorMessage = message
                                        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to get task folder count.")
                                        self.updateDataControlStatusDetailButton()
                                    })
                                    return
                                } else if let count = taskCount.0 {
                                    param["task_count"] = "\(count)"
                                }
                            } else {
                                DispatchQueue.main.async(execute: {
                                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("No task folder found.")
                                    self.updateDataControlStatusDetailButton()
                                })
                                return
                            }
                            
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
                        }
                    }
                    catch {
                        self.errorMessage = "\(error.localizedDescription)"
                        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Error in zipping files.")
                        self.updateDataControlStatusDetailButton()
                    }
                    //-----------------------------------------------------------------------------
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
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(dbBackupFileName)\"\r\n")
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
                                self.errorMessage = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to clear temp folder")) \(error.localizedDescription)"
                                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to clear temp folder")
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
        backupTaskCountLabel.isHidden = true
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
                if self.typeNow == self.typeRestore {
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Downloading Backup File:")) \(String(lroundf(100*percentageUploaded)))%"
                }else if self.typeNow == self.typeBackup {
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Uploading Backup File:")) \(String(lroundf(100*percentageUploaded)))%"
                }
                
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
            do {                
                //rename folder before restortion
                let filemgr = FileManager.default
                let filePathToRanme = self.backupFilePathBeforeRestore
                let filePathToRollback = self.rollbackFilePath
                do {
                    if filemgr.fileExists(atPath: filePathToRanme) {
                        try filemgr.moveItem(atPath: filePathToRanme, toPath: filePathToRollback)
                    }
                        
                } catch {
                    self.errorMessage = "\(error.localizedDescription)"
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to rename original folder before restore")
                    self.updateDataControlStatusDetailButton()
                }
                
                DispatchQueue.main.async(execute: {
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore In Progress...")
                })
            
                //begin restore
                do {
                    if let zipFilePath = URL(string: location.path), let destinationPath = URL(string: self.restoreDBFilePath) {
                        Zip.addCustomFileExtension("tmp")
                        try Zip.unzipFile(zipFilePath, destination: destinationPath, overwrite: true, password: nil, progress: { (progress) -> () in
                            DispatchQueue.main.async(execute: {
                                
                                self.progressBar.progress = Float(progress)
                                
                                if progress >= 1.0 {
                                    
                                    // Handle Task zip folders download one by one.
                                    
                                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("DB restore complete, proceed task folders restore.")
                                    
                                    self.keyValueDataHelper.updateLastRestoreDatetime(String(describing: Cache_Inspector?.inspectorId), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                                    
                                    self.lastDownloadInput.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                                    self.updateButtonsStatus(true)
                                    self.backupListTableView.isHidden = true
                                    self.backupHistoryLabel.isHidden = true
                                    self.restoreBtn.isHidden = true
                                    self.upperLine.isHidden = true
                                    self.downLine.isHidden = true
                                    self.taskZipFolderDownloadIndex = 1
                                    
                                    // remove all files under tmp folder
                                    do {
                                        let filemgr = FileManager.default
                                        if filemgr.fileExists(atPath: self.tmpPath) {
                                            let fileNames = try filemgr.contentsOfDirectory(atPath: "\(self.tmpPath)")
                                            for fileName in fileNames {
                                                let filePathName = "\(self.tmpPath)/\(fileName)"
                                                try filemgr.removeItem(atPath: filePathName)
                                            }
                                        }
                                    } catch {
                                        self.errorMessage = "\(error.localizedDescription)"
                                        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to remove all files under download temp folder")
                                    }
                                } else {
                                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Download completed, decompressing")) \(String(lroundf(100*Float(progress))))%"
                                }
                            })
                        })
                        // Check DB version if low, then upgrade
                        DispatchQueue.main.async(execute: {
                            let currDBVersion = self.keyValueDataHelper.getDBVersionNum()
                            if Int(currDBVersion) ?? 0 < Int(_BUILDNUMBER) ?? 0 {
                                let appUpgradeDataHelper = AppUpgradeDataHelper()
                                appUpgradeDataHelper.appUpgradeCode(_BUILDNUMBER, parentView: self.view, completion: { (result) in
                                    if result {
                                        self.keyValueDataHelper.updateDBVersionNum(_BUILDNUMBER)
                                    }
                                })
                            }
                            
                            // Proceed Task Folders Download
                            self.backupTaskCountLabel.isHidden = false
                            self.proceedTaskFoldersDownload()
                        })
                    }
                  
                } catch {
                    DispatchQueue.main.async(execute: {
                        self.errorMessage = "\(error.localizedDescription)"
                        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to unzip database file from server")
                        self.updateDataControlStatusDetailButton()
                    
                        // proceed rollback if restore fail rename folder to rollback
                        self.rollbackIfHitErrorWhenRestore()
                    
                        print(error)
                        self.passwordLabel.text = "\(error)"
                    })
                }
            
                self.updateButtonsStatus(true)
                //Send local notification for Task Done.
                self.presentLocalNotification("Data Restore Complete.")
            }
        } else if self.typeNow == self.typeTaskFolderDownload {
            print("Download task zip folder completed.")
            do {
                if let zipFilePath = URL(string: location.path), let destinationPath = URL(string: self.restoreFolderPath) {
                    Zip.addCustomFileExtension("tmp")
                    try Zip.unzipFile(zipFilePath, destination: destinationPath, overwrite: true, password: nil, progress: { (progress) -> () in
                        DispatchQueue.main.async(execute: {
                            
                            self.progressBar.progress = Float(progress)
                            
                            if progress >= 1.0 {
                                
                                // Handle Task zip folders download one by one.
                                // Completed.
                                if self.taskZipFolderDownloadIndex == Int(self.selectedBackupFile.taskCount) {
                                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Complete")
                                    
                                    self.keyValueDataHelper.updateLastRestoreDatetime(String(describing: Cache_Inspector?.inspectorId), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                                    
                                    self.lastDownloadInput.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                                    self.updateButtonsStatus(true)
                                    self.backupListTableView.isHidden = true
                                    self.backupHistoryLabel.isHidden = true
                                    self.restoreBtn.isHidden = true
                                    self.upperLine.isHidden = true
                                    self.downLine.isHidden = true
                                    
                                    //Remove Zip File Here
                                    self.removeLocalBackupZipFile(filePath: self.rollbackFilePath)
                                    
                                    // remove all files under tmp folder
                                    do {
                                        let filemgr = FileManager.default
                                        if filemgr.fileExists(atPath: self.tmpPath) {
                                            let fileNames = try filemgr.contentsOfDirectory(atPath: "\(self.tmpPath)")
                                            for fileName in fileNames {
                                                let filePathName = "\(self.tmpPath)/\(fileName)"
                                                try filemgr.removeItem(atPath: filePathName)
                                            }
                                        }
                                    } catch {
                                        self.errorMessage = "\(error.localizedDescription)"
                                        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to remove all files under download temp folder")
                                    }
                                } else {
                                    self.taskZipFolderDownloadIndex = self.taskZipFolderDownloadIndex + 1
                                    self.proceedTaskFoldersDownload()
                                }
                            } else {
                                self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Download completed, decompressing")) \(String(lroundf(100*Float(progress))))%"
                            }
                        })
                    })
                }
            } catch {
                // proceed rollback if restore fail rename folder to rollback
                rollbackIfHitErrorWhenRestore()
                
                self.errorMessage = "\(error.localizedDescription)"
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to unzip task zip file from server")
                self.updateButtonsStatus(true)
                self.updateDataControlStatusDetailButton()
                self.taskZipFolderDownloadIndex = 1
                DispatchQueue.main.async(execute: {
                    self.passwordLabel.text = "\(error)"
                })
            }
        }
    }
    
    private func proceedTaskFoldersDownload() {
        if let backupFile = self.selectedBackupFile {
            // Update UI
            DispatchQueue.main.async(execute: {
                self.backupTaskCountLabel.text = "(\(self.taskZipFolderDownloadIndex)/\(backupFile.taskCount))"
            })
            
            if self.taskZipFolderDownloadIndex <= Int(backupFile.taskCount) ?? 0 {
                self.typeNow = self.typeTaskFolderDownload
                let request = self.createRequest(DataControlHelper.getZipTaskFolderDownloadSessionParamByIndex(backupSyncId: backupFile.backupSyncId, taskIndex: String(self.taskZipFolderDownloadIndex)), url: URL(string: _DS_DOWNLOAD_BACKUP_TASK_FOLDER["APINAME"] as! String)!)
                print("task folder download request: \(request)")
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
                
            }
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
    
    private func resetAfterFail(errorMsg: String) {
        DispatchQueue.main.async(execute: {
            self.updateButtonsStatus(true)
            self.updateDataControlStatusDetailButton()
            
            self.progressBar.progress = 0
            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(errorMsg)
            
            //Remove Zip File Here
            self.removeLocalBackupZipFile()
            
            if self.typeNow == self.typeTaskFolderBackup {
                self.backupRetryButton.isHidden = false
            }
        })
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let httpResponse = task.response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            
            // handle http errors
            self.errorMessage = "http response error with status code: \(httpResponse.statusCode)"
            resetAfterFail(errorMsg: "Http gateway error, please click error info button for detail.")
            
        } else if error != nil {
            DispatchQueue.main.async(execute: {
                
                self.buffer.setData(NSMutableData() as Data)
                var errorMsg = ""
                
                if error?._code == NSURLErrorTimedOut {
                    errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sync Failed due to Network Issue")
                    self.updateButtonsStatus(true)
                }else if error?._code == NSURLErrorNotConnectedToInternet || error?._code == NSURLErrorCannotConnectToHost {
                    errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("App is in Offline Mode and unable to proceed Data Download.")
                }else{
                    errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("Network Request Failed with Unknown Reason!")
                }
                self.errorMessage = "\(error?.localizedDescription ?? "") with code: \(String(describing: error?._code))"
                
                if UIApplication.shared.applicationState != .active {
                    errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sync Failed when iPad in Sleep Mode")
                    self.errorMessage = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please avoid to press home/power button or show up control center when data sync in progress.")
                }
                
                self.resetAfterFail(errorMsg: errorMsg)
            })
        } else if self.typeNow == self.typeListBackupFiles {
            
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: buffer as Data, options: []) as? NSDictionary {
                    print("success == \(responseDictionary)")
                    
                    if responseDictionary.count > 0 {
                        print("Name: \(responseDictionary["app_db_backup_list"])")
                        self.backupFileList = [BackupFile]()
                        let appBackupList = responseDictionary["app_db_backup_list"] as! [[String : String]]
                        for info in appBackupList {
                            
                            let backupFile = BackupFile(appRealse: info["app_release"] ?? "", appVersion: info["app_version"] ?? "", backupProcessDate: info["backup_process_date"] ?? "", backupRemarks: info["backup_remarks"] ?? "", backupSyncId: info["backup_sync_id"] ?? "", deviceId: info["device_id"] ?? "", taskCount: info["task_count"] ?? "")
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
                    self.errorMessage = "\(error.localizedDescription)"
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to parse json response from server")
                    self.updateDataControlStatusDetailButton()
                })
            }
            buffer.setData(NSMutableData() as Data)
        } else if self.typeNow == self.typeBackup {
            
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: buffer as Data, options: []) as? NSDictionary {
                    
                    if responseDictionary.count > 0 {
                        
                        if let result = responseDictionary["ul_result"] as? String, let session = responseDictionary["service_session"] as? String {
                            //Remove database Zip File Here
                            self.removeLocalBackupZipFile()
                            
                            // Remove all remaining zip task folders
                            DataControlHelper.removeAllRemainZipTaskFolders()
                            
                            if result == "OK" {
                                self.serviceSession = session
                                self.typeNow = typeTaskFolderBackup
                                let taskFolders = DataControlHelper.getInspectorTaskFolders(inspectorName: Cache_Inspector?.appUserName?.lowercased() ?? "")
                                self.taskFolderCount = taskFolders.count
                                
                                let backupHelper = BackupHelper()
                                if backupHelper.clearBackupLog() {
                                    if DataControlHelper.setTaskFoldersToBackupLog(taskFolders: taskFolders) {
                                        self.taskFolders = taskFolders.reversed()
                                        uploadTaskFolder()
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async(execute: {
                    
                    self.errorMessage = "\(error.localizedDescription)"
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Failed!"))\(MylocalizedString.sharedLocalizeManager.getLocalizedString(error.localizedDescription))"
                    
                    self.removeLocalBackupZipFile()
                    let responseString = NSString(data: self.buffer as Data, encoding: String.Encoding.utf8.rawValue)
                    
                    self.updateDataControlStatusDetailButton()
                    self.updateButtonsStatus(true)
                })
            }
            
            buffer.setData(NSMutableData() as Data)
            
        } else if self.typeNow == self.typeTaskFolderBackup {
            // Update UI
            DispatchQueue.main.async(execute: {
                if let taskFolders = self.taskFolders {
                    self.backupTaskCountLabel.text = "(\(self.taskFolderCount - taskFolders.count)/\(self.taskFolderCount))"
                }
            })
            
            let inspectorName = Cache_Inspector?.appUserName?.lowercased() ?? ""
            if let taskFolder = self.currentUploadTaskFolderName {
                // Set upload date in backup log
                let backupHelper = BackupHelper()
                backupHelper.updateTaskFolderWithUploadDate(taskFolder: taskFolder)
                
                // remove local zip file
                DataControlHelper.removeZipTaskFolderAfterUpload(inspectorName: inspectorName, zipFilePath: "\(self.tempZipFolderPath)/\(taskFolder)")
                
                // update backup log in database
                backupHelper.updateTaskFolderWithDeletedDate(taskFolder: taskFolder)
            }
            
            // Loop zip files to backup
            uploadTaskFolder()
        }
    }
    
    func uploadTaskFolder() {
        if let taskFolder = taskFolders?.popLast() {
            self.currentUploadTaskFolderName = taskFolder
            uploadBackupTaskZipFolder(taskFolder: taskFolder)
        } else {
            // completed task folder backup
            DispatchQueue.main.async(execute: {
                let keyValueDataHelper = KeyValueDataHelper()
                _ = keyValueDataHelper.updateLastBackupDatetime(String(describing: Cache_Inspector?.inspectorId), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                self.lastUpdateInput.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Complete")
                self.progressBar.progress = 100
                self.updateButtonsStatus(true)
                self.backupDesc.text = ""
                self.backupListTableView.isHidden = true
                self.backupHistoryLabel.isHidden = true
                self.upperLine.isHidden = true
                self.taskFolders = nil
                self.currentUploadTaskFolderName = nil
                DataControlHelper.clearTempZipFolders(tempZipFolderPath: self.tempZipFolderPath)
                
                //Send local notification for Task Done.
                self.presentLocalNotification("Data Backup Complete.")
            })
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
        cell.taskCountInput.text = backupFile.taskCount.isEmpty ? "0" : backupFile.taskCount
        
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
            self.backupTaskCountLabel.isHidden = false
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
    
    func removeLocalBackupZipFile(filePath: String? = nil) {
        //Remove Zip File Here
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            print("Remove Zip File Here on the Background Queue.")
            let filemgr = FileManager.default
            do {
                
                if filemgr.fileExists(atPath: filePath ?? self.zipPath5) {
                    try filemgr.removeItem(atPath: filePath ?? self.zipPath5)
                }
                
            } catch {
                self.errorMessage = "\(error.localizedDescription)"
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to remove zip file after backup/restore")
                self.updateDataControlStatusDetailButton()
            }
        })
    }
    
    @IBAction func dataControlStatusDetailButtonDidPress(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 640, height: 320)
        
        popoverContent.dataType = _DOWNLOADTASKSTATUSDESC
        popoverContent.selectedValue = self.errorMessage
        
        let nav = CustomNavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.tintColor = UIColor.black
        
        let popover = nav.popoverPresentationController
        popover?.delegate = sender.parentVC as? PopoverMaster
        popover?.sourceView = sender
        popover?.sourceRect = sender.bounds
        
        sender.parentVC?.present(nav, animated: true, completion: nil)
    }
    
    
    @IBAction func backupRetryButtonDidPress(_ sender: UIButton) {
        // Handle re-try after fail while backup
        self.passwordLabel.text = ""
        updateDataControlStatusDetailButton(true)
        self.backupRetryButton.isHidden = true
        
        // clear temp folder
        DataControlHelper.clearTempZipFolders(tempZipFolderPath: self.tempZipFolderPath)
        
        // restart task
        if let taskFolder = self.currentUploadTaskFolderName {
            uploadBackupTaskZipFolder(taskFolder: taskFolder)
        }
    }
    
    private func rollbackIfHitErrorWhenRestore() {
        let filemgr = FileManager.default
        let filePath = self.backupFilePathBeforeRestore
        let filePathToRollback = self.rollbackFilePath
        do {
            if filemgr.fileExists(atPath: filePath) {
                try filemgr.removeItem(atPath: filePath)
                if filemgr.fileExists(atPath: filePathToRollback) {
                    try filemgr.moveItem(atPath: filePathToRollback, toPath: filePath)
                }
            }
        } catch {
            DispatchQueue.main.async(execute: {
                self.errorMessage = "\(error.localizedDescription)"
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail to clear local files after rollback fail")
                self.updateDataControlStatusDetailButton()
            })
        }
    }
    
    private func uploadBackupTaskZipFolder(taskFolder: String) {
        let inspectorName = Cache_Inspector?.appUserName?.lowercased() ?? ""
        let zipFilePath = String(format: backupFolderToZipPath, taskFolder)
        let tempZipFilePath = "\(tempZipFolderPath)/\(taskFolder)"
        
        // check if folder is empty, then skip
        if DataControlHelper.isEmptyFolder(folderPath: zipFilePath) {
            uploadTaskFolder()
            return
        }
        
        if let result = DataControlHelper.zipTaskFolder(folderPath: zipFilePath, tempPath: tempZipFilePath, tempFolder: tempZipFolderPath) {
            if let message = result.1 {
                // handle error message
                DispatchQueue.main.async(execute: {
                    self.errorMessage = message
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Error in zip file processing.")
                    self.updateDataControlStatusDetailButton()
                    self.updateButtonsStatus(true)
                })
            } else {
                // proceed task folder upload
                DispatchQueue.main.async(execute: {
                    if UIApplication.shared.applicationState == .active, let request = DataControlHelper.getTaskFolderUploadURLRequest(serviceSession: self.serviceSession ?? "", taskFileName: "\(taskFolder).zip", taskFile: "\(taskFolder).zip", destinationPath: self.tempZipFolderPath, inspectorName: inspectorName) {
                    
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
            }
        }
    }
}
