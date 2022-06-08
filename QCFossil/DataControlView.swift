//
//  DataControlView.swift
//  QCFossil
//
//  Created by Yin Huang on 6/5/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DataControlView: UIView, URLSessionDelegate, URLSessionDownloadDelegate, SSZipArchiveDelegate, UITableViewDelegate, UITableViewDataSource {

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
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var backupDesc: UITextView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var btnsPanel: UIView!
    @IBOutlet weak var activityActor: UIActivityIndicatorView!
    
    
    typealias CompletionHandler = (_ obj:AnyObject?, _ success: Bool?) -> Void
    let filePath = NSHomeDirectory() + "/Documents"
    var zipPath5 = NSHomeDirectory() + "/task.zip"
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var session: Foundation.URLSession?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        initPage()
        
    }
    
    func initPage() {
        
        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please input description for backup data.")
        self.descLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Description")
        self.loginUserLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Login User")
        self.lastLoginDate.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Login Date")
        self.lastDownload.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Rstore Date")
        self.lastUpdate.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Backup Date")
        self.passwordLabel.text = ""
        self.backupBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data"), for: UIControl.State())
        self.restoreDataBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Data"), for: UIControl.State())
        self.lastLoginDateInput.text = Cache_Inspector?.lastLoginDate
        
        let keyValueDataHelper = KeyValueDataHelper()
        self.lastUpdateInput.text = keyValueDataHelper.getLastBackupDatetimeByUserId(String(describing: Cache_Inspector?.inspectorId))
        self.lastDownloadInput.text = keyValueDataHelper.getLastRestoreDatetimeByUserId(String(describing: Cache_Inspector?.inspectorId))
        
        self.setButtonCornerRadius(self.backupBtn)
        self.setButtonCornerRadius(self.restoreDataBtn)
        self.activityActor.isHidden = true
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                       .userDomainMask, true)[0]
        zipPath5 = path + "/task.zip"
        
    }
    
    func zipArchiveProgressEvent(_ loaded: UInt64, total: UInt64) {
        print("loaded: \(loaded) total: \(total)")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let percentageUploaded = Float(loaded) / Float(total)
            
            DispatchQueue.main.async(execute: {
                
                self.progressBar.progress = percentageUploaded
                
                if lroundf(100*percentageUploaded) == 100 {
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Complete")
                    let keyValueDataHelper = KeyValueDataHelper()
                    keyValueDataHelper.updateLastRestoreDatetime(String(describing: Cache_Inspector?.inspectorId), datetime: self.getCurrentDateTime())
                    
                    self.lastDownloadInput.text = self.getCurrentDateTime()
                    
                }else{
                    self.passwordLabel.text = "Decompressing \(String(lroundf(100*percentageUploaded)))%"
                }
            })
        }
    }
    
    //在Caches文件夹下随机创建一个文件夹，并返回路径
    func tempDestPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
            .userDomainMask, true)[0]
        path += "/\(UUID().uuidString)"
        let url = URL(fileURLWithPath: path)
        
        do {
            try FileManager.default.createDirectory(at: url,
                withIntermediateDirectories: true, attributes: nil)
            
            return url.path
        } catch {
            return nil
        }
    }
    
    @IBAction func backupDataClick(_ sender: UIButton) {
        /*UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.btnsPanel.center.y += 90
            self.descLabel.alpha = 1
            self.backupDesc.alpha = 1
            self.layoutIfNeeded()
            
            }, completion: {(action:UIAlertAction!) in
        
        })*/
        
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data")+"?",parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
        
            if self.backupDesc.text == "" {
                self.errorMsg.isHidden = false
                return
                
            }else{
                self.errorMsg.isHidden = true
            }
            
            DispatchQueue.main.async(execute: {
                self.activityActor.isHidden = false
                self.activityActor.startAnimating()
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
                    param["db_filename"] = "task.zip"
                    param["db_file"] = self.zipPath5
                    param["backup_remarks"] = self.backupDesc.text
                    param["app_version"] = String(_VERSION)
                    param["app_release"] = _RELEASE
                    
                    let request = self.createRequest(param, url: URL(string: _DS_UPLOADDBBACKUP["APINAME"] as! String)!)
                
                    let task = self.session!.dataTask(with: request, completionHandler: { data, response, error in
                        if error != nil {
                        
                            print(error)
                            self.passwordLabel.text = "\(error)"
                            return
                        }
                    
                        do {
                            if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                                print("success == \(responseDictionary)")
                                
                                if responseDictionary.count > 0 {
                                    
                                    if let result = responseDictionary["ul_result"] as? String, result == "OK" {
                                        let keyValueDataHelper = KeyValueDataHelper()
                                        _ = keyValueDataHelper.updateLastBackupDatetime(String(describing: Cache_Inspector?.inspectorId), datetime: self.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                                        self.lastUpdateInput.text = self.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Complete")
                                        })
                                        
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
                                            }
                                            
                                            DispatchQueue.main.async(execute: { () -> Void in
                                                print("Zip File has been Removed Successfully!")
                                            })
                                        })
                                    }
                                }
                        }
                        
                        } catch {
                            DispatchQueue.main.async(execute: {
                                print(error)
                                self.passwordLabel.text = "\(error)"
                                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                print("responseString = \(responseString)")
                            })
                        }
                    }) 
                
                    task.resume()
                })
            })
        })
    }
    
    func createRequest (_ param: [String: String], url:URL) -> URLRequest {
   
        let boundary = self.generateBoundaryString()
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(param, boundary: boundary)
        
        return request as URLRequest
    }
    
    func createBodyWithParameters(_ parameters: [String: String], boundary: String) -> Data {
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
                        self.alertView("No Zip File Found!")
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
    
    func createBackupListRequest () -> URLRequest {
        
        let boundary = self.generateBoundaryString()
        let body = NSMutableData()
        
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
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"req_msg\"\r\n\r\n")
        body.appendString("\(param)\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        let request = NSMutableURLRequest(url: URL(string: _DS_LISTDBBACKUP["APINAME"] as! String)!)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.httpBody = body as Data
        request.httpShouldHandleCookies = false
        
        return request as URLRequest
    }
    
    @IBAction func removeOnClick(_ sender: UIButton) {
        
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete?"),parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
            
            if "12" != "123" {
                self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Password Not Correct!"))
                return
                
            }else{
                self.removeFromSuperview()
            }
        })
    }
    
    @IBAction func restoreDataOnClick(_ sender: UIButton) {
        
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Data")+"?",parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
            
            let request = self.createBackupListRequest()
            let task = self.session!.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    
                    print(error)
                    self.passwordLabel.text = "\(error)"
                    return
                }
                
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        print("success == \(responseDictionary)")
                        
                        if responseDictionary.count > 0 {
                            print("Name: \(responseDictionary["app_db_backup_list"])")
                            
                            let appBackupList = responseDictionary["app_db_backup_list"] as! [[String : String]]
                            for info in appBackupList {
                                print("\(info["app_release"])")
                                print("\(info["app_version"])")
                                print("\(info["backup_process_date"])")
                                print("\(info["backup_remarks"])")
                                print("\(info["backup_sync_id"])")
                                print("\(info["device_id"])")
                            }
                        }
                    }
                    
                } catch {
                    DispatchQueue.main.async(execute: {
                        print(error)
                        self.passwordLabel.text = "\(error)"
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("responseString = \(responseString)")
                    })
                }
            }) 
            
            task.resume()
            
            /*
            do {
                
                try SSZipArchive.unzipFileAtPath(self.zipPath5, toDestination: self.filePath, overwrite: true, password: "", delegate: self)
                
                /*
                // 服务器上zip文件地址
                let url = NSURL(string: "http://localhost:8080/MJServer/resources/videos/videos.zip")
                // 发送请求，下载文件
                let task = NSURLSession.sharedSession().downloadTaskWithURL(url!) { (location, response, error) -> Void in
            
                // 解压缩zip文件
                SSZipArchive.unzipFileAtPath((location?.path)!, toDestination: self.filePath)
                }
            
                // 开始下载
                task.resume()
                */
                
            }catch {
                print(error)
                self.passwordLabel.text = "\(error)"
            }
            */
        })
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
                self.passwordLabel.text = "\(String(lroundf(100*percentageUploaded)))%"
                self.progressBar.progress = percentageUploaded
            })
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        self.session!.finishTasksAndInvalidate()
        print("Complete, Clear Session")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下载完成")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("正在下载 \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("从 \(fileOffset) 处恢复下载，一共 \(expectedTotalBytes)")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        
        return cell
    }
}
