//
//  CustomExtensionObjects.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit
import AssetsLibrary
import ImageIO
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


/* Input Mode 04 */
extension InputMode04View {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode04View? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode04View
    }
}

extension InputMode04CellView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode04CellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode04CellView
    }
}

extension DefectHeaderView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> DefectHeaderView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? DefectHeaderView
    }
}

extension InputMode04DefectCellView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode04DefectCellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode04DefectCellView
    }
}

extension CreateTaskView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> CreateTaskView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? CreateTaskView
    }
}

extension POSearchView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> POSearchView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? POSearchView
    }
}

extension PopoverViewsInput {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> PopoverViewsInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? PopoverViewsInput
    }
}

extension InptCategoryCell {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InptCategoryCell? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InptCategoryCell
    }
}

extension TaskDetailViewInput {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> TaskDetailViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? TaskDetailViewInput
    }
}

extension TaskQCInfoView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> TaskQCInfoView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? TaskQCInfoView
    }
}

extension POInfoView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> POInfoView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? POInfoView
    }
}

/* Input Mode 01 */
extension InputMode01View {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode01View? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode01View
    }
}

extension InputMode01CellView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode01CellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode01CellView
    }
}

extension InputMode01DefectCellView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode01DefectCellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode01DefectCellView
    }
}


/* Input Mode 02 */
extension InputMode02View {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode02View? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode02View
    }
}

extension InputMode02CellView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode02CellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode02CellView
    }
}

extension InputMode02DefectCellView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode02DefectCellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode02DefectCellView
    }
}


/* Input Mode 03 */
extension InputMode03View {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode03View? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode03View
    }
}

extension InputMode03CellView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode03CellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode03CellView
    }
}

extension InputMode03DefectCellView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InputMode03DefectCellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InputMode03DefectCellView
    }
}

extension DropdownListViewControl {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> DropdownListViewControl? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? DropdownListViewControl
    }
}

extension InspectionViewInput {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> InspectionViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InspectionViewInput
    }
}

extension POCellViewInput {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> POCellViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? POCellViewInput
    }
}

extension ImagePreviewViewInput {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> ImagePreviewViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? ImagePreviewViewInput
    }
}

extension CalenderPickerViewInput {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> CalenderPickerViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? CalenderPickerViewInput
    }
}

extension DataControlView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> DataControlView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? DataControlView
    }
}

extension ShapePreviewViewInput {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> ShapePreviewViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? ShapePreviewViewInput
    }
}

class DownloadRequester:NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var session: Foundation.URLSession?
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var dsDataObj:AnyObject?
    var dataSet = [Dictionary<String, String>]()
    
    override init() {
        
        super.init()
        
        /*let imageURL = NSURL(string: "http://tw.mjjq.com/pic/20070510/20070510032908935.jpg")!
        session = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("taask"), delegate: self, delegateQueue: nil)
        
        session?.downloadTaskWithURL(imageURL).resume()
        */
        
        session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
    }
    
    func makeDLRequest(_ dsData:AnyObject) {
        let task = session?.dataTask(with: createDLRequest(dsData))
        task!.resume()
    }
    
    func createDLRequest(_ dsData:AnyObject) -> URLRequest {
        self.dsDataObj = dsData
        
        var param = "\(_DS_PREFIX){"
        for (key, value) in dsData["APIPARA"] as! Dictionary<String,String> {
            param += "\"\(key)\":\"\(value)\","
        }
        param += "}"
        param = param.replacingOccurrences(of: ",}", with: "}")
        
        let request = NSMutableURLRequest(url: URL(string: dsData["APINAME"] as! String)!)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.httpBody = param.data(using: String.Encoding.utf8)
        request.httpShouldHandleCookies = false
        
        return request as URLRequest
    }
    
    //------------------------------------- Delegate Funcs --------------------------------------------------------
    func URLSession(_ session: Foundation.URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        
        buffer.append(data)
        
        let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
        print("progress: \(Float(buffer.length)) \(percentageDownloaded)")
        //progress.progress =  percentageDownloaded
    }
    
    func URLSession(_ session: Foundation.URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (Foundation.URLSession.ResponseDisposition) -> Void) {
        
        //here you can get full lenth of your content
        expectedContentLength = Int(response.expectedContentLength)
        print("expectedContentLength: \(expectedContentLength)")
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        //use buffer here.Download is done
        //progress.progress = 1.0   // download 100% complete
        
        if(error != nil) {
            print(error!.localizedDescription)
            let jsonStr = NSString(data: buffer as Data, encoding: String.Encoding.utf8.rawValue)
            print("Error could not parse JSON: '\(jsonStr)'")
        }
        else {
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: buffer as Data, options: .allowFragments) as! NSDictionary
                let actionNames = self.dsDataObj!["ACTIONNAMES"] as! [String]
                let actionFields:Dictionary<String, [String]> = self.dsDataObj!["ACTIONFIELDS"] as! Dictionary
            
                if actionNames.count > 0 {
                    for idx in 0...actionNames.count-1 {
                        var dataObj = Dictionary<String, String>()
                        dataObj["tableName"] = actionNames[idx]
                    
                        if let mstrData = jsonData[actionNames[idx]] as? [[String: AnyObject]] {
                            for data in mstrData {
                                for idx2 in 0...actionFields[actionNames[idx]]!.count-1 {
                                    if let value = data[actionFields[actionNames[idx]]![idx2]] as? String {
                                        dataObj[actionFields[actionNames[idx]]![idx2]] = value
                                    }
                                
                                }
                            
                                dataSet.append(dataObj)
                            }
                        
                        }else if let mstrData = jsonData[actionNames[idx]] as? [String: AnyObject] {
                            for (key, value) in mstrData {
                                
                                dataObj[key] = value as? String
                            }
                        
                            dataSet.append(dataObj)
                        }
                    }
                    
                    print("records: \(dataSet)")
                    
                    print("下载完成!")
                    
                } else{
                
                }
            }
            catch {
                    print("error serializing JSON: \(error)")
            }
            
        }
        
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
}

extension UIViewController {
    func nullToNil(_ value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    /*
     Error Code: 
     kCFURLErrorUnknown   = -998,
     kCFURLErrorCancelled = -999,
     kCFURLErrorBadURL    = -1000,
     kCFURLErrorTimedOut  = -1001,
     kCFURLErrorUnsupportedURL = -1002,
     kCFURLErrorCannotFindHost = -1003,
     kCFURLErrorCannotConnectToHost    = -1004,
     kCFURLErrorNetworkConnectionLost  = -1005,
     kCFURLErrorDNSLookupFailed        = -1006,
     kCFURLErrorHTTPTooManyRedirects   = -1007,
     kCFURLErrorResourceUnavailable    = -1008,
     kCFURLErrorNotConnectedToInternet = -1009,
     kCFURLErrorRedirectToNonExistentLocation = -1010,
     kCFURLErrorBadServerResponse             = -1011,
     kCFURLErrorUserCancelledAuthentication   = -1012,
     kCFURLErrorUserAuthenticationRequired    = -1013,
     kCFURLErrorZeroByteResource        = -1014,
     kCFURLErrorCannotDecodeRawData     = -1015,
     kCFURLErrorCannotDecodeContentData = -1016,
     kCFURLErrorCannotParseResponse     = -1017,
     kCFURLErrorInternationalRoamingOff = -1018,
     kCFURLErrorCallIsActive               = -1019,
     kCFURLErrorDataNotAllowed             = -1020,
     kCFURLErrorRequestBodyStreamExhausted = -1021,
     kCFURLErrorFileDoesNotExist           = -1100,
     kCFURLErrorFileIsDirectory            = -1101,
     kCFURLErrorNoPermissionsToReadFile    = -1102,
     kCFURLErrorDataLengthExceedsMaximum   = -1103
     */
    func makePostRequest(_ urlPath:String, dataInJson:String, method:String="POST", actionNames:[String]=[], actionFields:Dictionary<String, [String]>, type:String="DL", handler:@escaping (_ result:[Dictionary<String, String>]?,_ response:String,_ totalRecords:Int)-> Void) {
        
        let urlPath = urlPath
        let url = URL(string: urlPath)
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = method
        let jsonStringPost = dataInJson
        let data = jsonStringPost.data(using: String.Encoding.utf8)
        
        request.timeoutInterval = 60
        request.httpBody = data
        request.httpShouldHandleCookies = false
        
        let queue:OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue, completionHandler:{
            (response, data, error) in
            
            if error != nil {
                //Handle Error here
                print("error data \(data) , response \(response)")
                
                if (error?._code)! == NSURLErrorCannotConnectToHost {
                    handler(nil, "Fail", 0)
                }else if (error?._code)! == NSURLErrorNotConnectedToInternet {
                    handler(nil, "Fail", 0)
                }else if (error?._code)! == NSURLErrorCannotFindHost {
                    handler(nil, "Fail", 0)
                }else if (error?._code)! == NSURLErrorNetworkConnectionLost {
                    handler(nil, "Fail", 0)
                }else{
                    handler(nil, "Fail", 0)
                    //self.view.alertView("Login Error: \(error) Error Code: \((error?.code)!)")
                }
            }else{
                
                if type == "UL" {
                    self.getULResponseData(actionNames, data: data!, handler: handler)
                }else{
                    self.getResponseData(actionNames, actionFields: actionFields, data: data!, handler: handler)
                }
            }
        })
    }
    
    func sendRequestData(_ actionNames:[String], actionFields:Dictionary<String, [String]>, data:Data, handler:(_ result:[Dictionary<String, String>]?,_ response:String)-> Void) {
    }
    
    func getResponseData(_ actionNames:[String], actionFields:Dictionary<String, [String]>, data:Data, handler:(_ result:[Dictionary<String, String>]?,_ response:String,_ totalRecords:Int)-> Void) {
        
        //Handle data in NSData type
        var dataSet = [Dictionary<String, String>]()
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            var recordCount = 0
            
            if actionNames.count > 0 {
                for idx in 0...actionNames.count-1 {
                    var dataObj = Dictionary<String, String>()
                    dataObj["tableName"] = actionNames[idx]
                    
                    if let mstrData = jsonData[actionNames[idx]] as? [[String: AnyObject]] {
                        for data in mstrData {
                            for idx2 in 0...actionFields[actionNames[idx]]!.count-1 {
                                if let value = data[actionFields[actionNames[idx]]![idx2]] as? String {
                                    dataObj[actionFields[actionNames[idx]]![idx2]] = value
                                }
                                
                            }
                            
                            recordCount += 1
                            dataSet.append(dataObj)
                        }
                        
                    }else if let mstrData = jsonData[actionNames[idx]] as? [String: AnyObject] {
                        for (key, value) in mstrData {
                            
                            dataObj[key] = value as? String
                            recordCount += 1
                        }
                        
                        dataSet.append(dataObj)
                    }
                }
                
                var session_result = jsonData["service_session"] as? String ?? ""
                session_result += jsonData["action_result"] as? String ?? ""
                
                handler(dataSet, session_result, recordCount)
            } else{
                var session_result = jsonData["action_result"] as? String ?? ""
                session_result += jsonData["ack_result"] as? String ?? ""
                
                handler(dataSet, session_result, 0)
            }
            
            //resultSet = dataSet
        } catch {
            print("error serializing JSON: \(error)")
        }
        
    }
    
    func getULResponseData(_ actionFields:[String], data:Data, handler:(_ result:[Dictionary<String, String>]?,_ response:String,_ totalRecords:Int)-> Void) {
        
        //Handle data in NSData type
        var dataSet = [Dictionary<String, String>]()
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            var recordCount = 0
            
            if jsonData.count > 0 {
                var dataObj = Dictionary<String, String>()
                
                for (key,value) in jsonData {
                    dataObj[key as! String] = value as? String
                    
                    recordCount += 1
                }
                
                dataSet.append(dataObj)
                
                var result = jsonData["service_session"] as? String ?? ""
                result += jsonData["action_result"] as? String ?? ""
                
                handler(dataSet, result, recordCount)
            } else{
                var result = jsonData["action_result"] as? String ?? ""
                result += jsonData["ack_result"] as? String ?? ""
                
                handler(dataSet, result, 0)
            }
            
            //resultSet = dataSet
        } catch {
            print("error serializing JSON: \(error)")
        }
        
    }
    
    func requestUrl(_ urlString: String){
        let url: URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler:{
            (response, data, error) -> Void in
            
            if error != nil {
                //Handle Error here
                print("error data \(data) , response \(response)")
            }else{
                //Handle data in NSData type
                print("data \(data) , response \(response)")
            }
            
        })
    }
    
    func presentLocalNotification(_ message:String) {
        //Send local notification for Task Done.
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date(timeIntervalSinceNow: 0)
        localNotification.alertBody = MylocalizedString.sharedLocalizeManager.getLocalizedString(message)
        localNotification.timeZone = TimeZone.current
        
        DispatchQueue.main.async(execute: {
            localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
            UIApplication.shared.presentLocalNotificationNow(localNotification)
        })
    }
}

extension UIView {
    weak var parentVC: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func getCurrentDate(_ dateFormat:String=_DATEFORMATTER) ->String {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
       // dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let locale:Locale = Locale(identifier: "en_US")
        let timezone:TimeZone = TimeZone(secondsFromGMT: 28800)!
        dateFormatter.locale = locale
        dateFormatter.timeZone = timezone
        
        return dateFormatter.string(from: todaysDate)
    }
    
    func getCurrentDateTime(_ dateFormat:String=_DATEFORMATTER + " hh:mm:ss a") ->String {
        
        
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        //dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = dateFormat //dateFormat + " HH:mm a"
        
        let locale:Locale = Locale(identifier: "en_US")
        let timezone:TimeZone = TimeZone(secondsFromGMT: 28800)!
        dateFormatter.locale = locale
        dateFormatter.timeZone = timezone

        return dateFormatter.string(from: todaysDate)
        
        /*
        var timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        
        //if !_ENGLISH {
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Jan", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Jan"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Feb", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Feb"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Mar", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Mar"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Apr", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Apr"))
            
            timestamp = timestamp.stringByReplacingOccurrencesOfString("May", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("May"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Jun", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Jun"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Jul", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Jul"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Aug", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Aug"))
            
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Sep", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Sep"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Oct", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Oct"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Nov", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Nov"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Dec", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Dec"))
            
            timestamp = timestamp.stringByReplacingOccurrencesOfString("AM", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("am"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("PM", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("pm"))
        //}
        
        return timestamp*/
    }
    
    func getFormattedStringByDateString(_ dateString: String) ->String {
        
        let dateFormatter = DateFormatter()
        var localeId = dateFormatter.locale.identifier
        if !localeId.hasSuffix("_POSIX") {
            localeId = localeId + ("_POSIX")
            dateFormatter.locale = Locale(identifier: localeId)
        }
        dateFormatter.dateFormat = "\(_DATEFORMATTER) hh:mm:ss a"
        
        let formattedDate = dateFormatter.date(from: dateString)
        /*
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "\(_DATEFORMATTER) hh:mm:ss a"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_HK_POSIX")
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0)
        
        dateFormatter.dateFormat = "\(_DATEFORMATTER) hh:mm:ss a"
        let formattedDate = dateFormatter.dateFromString(dateString)
        */
        let dfmatter2 = DateFormatter()
        dfmatter2.dateFormat = "\(_DATEFORMATTER) HH:mm:ss a"
 
        guard let newFormattedDate = formattedDate else{
            return ""
        }
        
        return dfmatter2.string(from: newFormattedDate)
    }
    
    func showActivityIndicator(_ title:String="Loading") {
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.isHidden = false
        container.frame = self.frame
        container.center = self.center
        container.backgroundColor = UIColor.clear
        container.alpha = 0.7
        //container.backgroundColor = UIColor.whiteColor()
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.center
        loadingView.backgroundColor = UIColor.black
        loadingView.alpha = 1.0
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(title)
        label.font =  label.font.withSize(14)
        label.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2+25)
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.style = UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(actInd)
        loadingView.addSubview(label)
        container.addSubview(loadingView)
        self.addSubview(container)
        actInd.startAnimating()
    }
    
    func removeActivityIndicator() {
        self.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
    }
    
    func alertView(_ title:String, handlerFun:((UIAlertAction)->Void)?=nil) {
        let alertController = UIAlertController(title: title, message:
            "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), style: UIAlertAction.Style.default,handler: handlerFun))
        
        self.parentVC?.present(alertController, animated: true, completion: nil)
    }
    
    func alertConfirmView(_ title:String, message:String="",parentVC:UIViewController, handlerFun:((UIAlertAction)->Void)?=nil, handlerFunCancel:((UIAlertAction)->Void)?=nil) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), style: UIAlertAction.Style.default, handler: handlerFun)
        let cancelButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), style: .cancel, handler: handlerFunCancel)
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        parentVC.present(alertController, animated: true, completion: nil)
    }
    
    func alertConfirmViewStyle3(_ title:String, message:String="",parentVC:UIViewController, handlerFunYes:((UIAlertAction)->Void)?=nil, handlerFunNo:((UIAlertAction)->Void)?=nil, handlerFunCancel:((UIAlertAction)->Void)?=nil) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertController.Style.alert)
        
        let yesButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Yes"), style: UIAlertAction.Style.default, handler: handlerFunYes)
        let noButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("No"), style: UIAlertAction.Style.default, handler: handlerFunNo)
        let cancelButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), style: UIAlertAction.Style.default/*.Cancel*/, handler: handlerFunCancel)
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        alertController.addAction(cancelButton)
        
        parentVC.present(alertController, animated: true, completion: nil)
    }
    
    func clearDropdownviewForSubviews(_ view:UIView) {
        Cache_Dropdown_Instance = nil
        
        // Get the subviews of the view
        let subviews = view.subviews
        
        // Return if there are no subviews
        if subviews.count < 1 {
            return
        }
        
        subviews.forEach({
            if $0.classForCoder == DropdownListViewControl.classForCoder() {
                ($0 as! DropdownListViewControl).myParentTextField?.endEditing(true)
                $0.removeFromSuperview()
                
            }else if $0.classForCoder == UITextField.classForCoder() /*|| $0.classForCoder == UITextView.classForCoder()*/ {
                $0.resignFirstResponder()
            }
            
            clearDropdownviewForSubviews($0)
        })
    }
    
    func ifExistingSubviewByViewTag(_ view:UIView, tag:Int) ->Bool {
        
        if (view.viewWithTag(tag) != nil) {
            return true
        }
        
        return false
    }
    
    func resignFirstResponderByTextField(_ view:UIView) {
        
        // Get the subviews of the view
        let subviews = view.subviews
        
        // Return if there are no subviews
        if subviews.count < 1 {
            return
        }
        
        subviews.forEach({
            if $0.classForCoder == UITextField.classForCoder() || $0.classForCoder == UITextView.classForCoder() {
                $0.resignFirstResponder()
            }
            
            resignFirstResponderByTextField($0)
        })
    }
    
    func disableAllFunsForView(_ view:UIView) {
        // Get the subviews of the view
        let subviews = view.subviews
        
        // Return if there are no subviews
        if subviews.count < 1 {
            return
        }
        
        subviews.forEach({
            
            if $0.classForCoder == CustomControlButton.classForCoder() || $0.classForCoder == UIButton.classForCoder() || $0.classForCoder == UITextField.classForCoder() || $0.classForCoder == SignoffView.classForCoder() || $0.classForCoder == CustomTextView.classForCoder() {
                disableFuns($0)
            }
            
            disableAllFunsForView($0)
        })
    }
    
    func disableFuns(_ obj:AnyObject = UIButton()) ->Bool {
        return Cache_Task_On?.confirmUploadDate != nil
    }
    
    func setButtonCornerRadius(_ button:UIButton) {
        button.layer.cornerRadius = 6
    }
    
    @objc func btnFunDisble() {
        self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Confirmed or Cancelled Task!"))
    }
    
    @objc func btnFunDisbleForUploaded() {
        self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Uploaded, Reviewed or Refused Task!"))
    }
    
    func createTaskFolderById(_ bookingNo:String) ->Bool {
        
        let taskPath = _TASKSPHYSICALPATH+bookingNo
        
        do {
            try FileManager.default.createDirectory(atPath: taskPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        let taskThumbsPath = taskPath + "/" + _THUMBSPHYSICALNAME
        
        do {
            try FileManager.default.createDirectory(atPath: taskThumbsPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        return true
    }
    
    func deleteTask(_ taskId:Int){
        
        let taskDataHelper = TaskDataHelper()
        
        let taskFderName = taskDataHelper.getBookingNoByTaskId(taskId)
        
        if taskFderName == "" {
            print("No task Fder found for taskId: \(taskId)")
            return
        }
        
        let filemgr = FileManager.default
        let taskFilePath = _TASKSPHYSICALPATH+"\(taskFderName)"
        let taskThumbFilePath = taskFilePath+"/Thumbs"
        do {
            
            if filemgr.fileExists(atPath: taskFilePath) {
                let fileNames = try filemgr.contentsOfDirectory(atPath: "\(taskFilePath)")
                print("all files in folder: \(fileNames)")
                for fileName in fileNames {
                    
                    if (fileName.hasSuffix(".jpg"))
                    {
                        let filePathName = "\(taskFilePath)/\(fileName)"
                        try filemgr.removeItem(atPath: filePathName)
                    }
                }
                //delete folder
                try filemgr.removeItem(atPath: taskFilePath)
            }
            
            if filemgr.fileExists(atPath: taskThumbFilePath) {
                let fileThumbs = try filemgr.contentsOfDirectory(atPath: "\(taskThumbFilePath)")
                for fileName in fileThumbs {
                
                    if (fileName.hasSuffix(".jpg"))
                    {
                        let filePathName = "\(taskThumbFilePath)/\(fileName)"
                        try filemgr.removeItem(atPath: filePathName)
                    }
                }
                //delete folder
                try filemgr.removeItem(atPath: taskThumbFilePath)
            }
            
            let taskDataHelper = TaskDataHelper()
            if !taskDataHelper.deleteTaskById(taskId) {
                UIView.init().alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Delete Fail!"))
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
    }
    
    //Get File in Preferences
    func getPreferencesFilePath() ->String? {
        let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] + "/Preferences"
        let url = URL(fileURLWithPath: path)
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return url.path
        } catch {
            return nil
            
        }
    }
    
    func sortStringArrayByName(_ arrayString:[String]) ->[String] {
        let locale = MylocalizedString.sharedLocalizeManager.getCurrentLocale()
        return arrayString.sorted(by: {$0.compare($1, locale: locale) == .orderedAscending})
    }
}

extension UIImageView {
    func previewImage(_ index:Int,imageName:String,senderImageView:UIImageView,parentItem:InputModeDFMaster2) {
        let container = UIScrollView()
        container.tag = _MASKVIEWTAG
        container.isHidden = false
        container.frame = self.parentVC!.view.frame
        container.center = self.parentVC!.view.center
        container.backgroundColor = UIColor.clear
        
        let layer = UIView()
        layer.frame = self.parentVC!.view.frame
        layer.center = self.parentVC!.view.center
        layer.backgroundColor = UIColor.black
        layer.alpha = 0.7
        container.addSubview(layer)
        
        let preview = ImagePreviewViewInput.loadFromNibNamed("ImagePreviewView")
        preview!.frame = CGRect(x: 0,y: 0,width: 600,height: 850)
        preview?.center = container.center
        preview?.photoIndex = index
        preview?.parentView = container
        preview?.parentImageView = senderImageView
        preview?.parentDefectItem = parentItem
        preview?.imageName = imageName
        
        //Use the Regular Size Image
        let path = Cache_Task_Path!+"/"+imageName
        preview?.imageView.image = UIImage(contentsOfFile: path)
        
        preview?.imageView.frame = CGRect(x: 0,y: 0,width: 600,height: 800)
        //preview?.imageView.frame = CGRect(x: 0,y: 0.5*(preview!.frame.size.height - (preview?.imageView.image?.size.height)!)-25,width: (preview?.imageView.image?.size.width)!,height: (preview?.imageView.image!.size.height)!)
        
        preview?.BackgroundView.addSubview((preview?.imageView)!)
        
        container.addSubview(preview!)
        
        self.parentVC?.view.addSubview(container)
    }
    
    func saveEndEditImage(_ image:UIImage) ->UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
}

extension UIImage {
    
    func initPhotoObj(_ image:UIImageView?, photoId:Int=0, taskId:Int, refPhotoId:Int?, orgFileName:String?, imageName:String, photoDesc:String?,dataRecordId:Int?,createUser:String?,createDate:String?,modifyUser:String?,modifyDate:String?,dataType:Int?) ->Photo? {
        
        let photo = Photo(photo: image,photoFilename: imageName,taskId: taskId, photoFile: imageName)
        
        photo?.refPhotoId = refPhotoId
        photo?.orgFileName = orgFileName
        photo?.thumbFile = imageName
        photo?.photoDesc = photoDesc
        photo?.dataRecordId = dataRecordId
        photo?.createUser = createUser
        photo?.createDate = createDate
        photo?.modifyUser = modifyUser
        photo?.modifyDate = modifyDate
        photo?.dataType = dataType
        
        return photo
    }
    /*
    func processImage(image: UIImage, size: CGSize, completion: (image: UIImage) -> Void) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            image.drawInRect(CGRect(origin: CGPoint.zero, size: size))
            let tempImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completion(image: tempImage)
        }
    }*/
    /*
    func resizeImage(image:UIImage, imageWidth:CGFloat=_RESIZEIMAGEWIDTH, imageHeight:CGFloat=_RESIZEIMAGEHEIGHT, completion: (image: UIImage) -> Void)/* ->UIImage*/ {
        
        let widthRatio = imageWidth / image.size.width
        let heightRatio = imageHeight / image.size.height
        let scale = min(widthRatio, heightRatio)
        let newWidth = scale * image.size.width
        let newHeight = scale * image.size.height
    
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //return newImage
        completion(image: newImage)
        
    }*/
    
    func rotateImage(_ image:UIImage, angle:CGFloat, flipVertical:CGFloat, flipHorizontal:CGFloat) -> UIImage? {
        let ciImage = CoreImage.CIImage(image: image)
        
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setDefaults()
        
        let newAngle = angle * CGFloat(-1)
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipVertical) * M_PI), 0, 1, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipHorizontal) * M_PI), 1, 0, 0)
        
        let affineTransform = CATransform3DGetAffineTransform(transform)
        
        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")
        
        let contex = CIContext(options: convertToOptionalCIContextOptionDictionary([convertFromCIContextOption(CIContextOption.useSoftwareRenderer):true]))
        
        let outputImage = filter?.outputImage
        let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)
        
        let result = UIImage(cgImage: cgImage!)
        return result
    }
    
    func resizeImage(_ image:UIImage, imageWidth:CGFloat=_RESIZEIMAGEWIDTH, imageHeight:CGFloat=_RESIZEIMAGEHEIGHT) ->UIImage {
        var sourceImage = image
        sourceImage = sourceImage.fixOrientation()
        
        if sourceImage.size.width > sourceImage.size.height/* || image.imageOrientation == UIImageOrientation.Left || image.imageOrientation == UIImageOrientation.Right */{
            sourceImage = sourceImage.rotateImage(sourceImage, angle: (CGFloat)(90*M_PI / 180), flipVertical: 0, flipHorizontal: 0)!
        }
        
        let widthRatio = imageWidth / sourceImage.size.width
        let heightRatio = imageHeight / sourceImage.size.height
        let scale = min(widthRatio, heightRatio)
        let newWidth = scale * sourceImage.size.width
        let newHeight = scale * sourceImage.size.height
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func rotateImage(_ image:UIImage) ->UIImage {
        var sourceImage = image
        sourceImage = sourceImage.fixOrientation()
        
        if sourceImage.size.width > sourceImage.size.height{
            sourceImage = sourceImage.rotateImage(sourceImage, angle: (CGFloat)(90*M_PI / 180), flipVertical: 0, flipHorizontal: 0)!
        }
        
        return sourceImage
    }
    
    func cropToBounds(_ image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func saveImageToLocal(_ sourceImage:UIImage, photoFileName:String="",photoId:Int?=0, savePath:String, taskId:Int, bookingNo:String, inspectorName:String, dataRecordId:Int?=0, dataType:Int, currentDate:String, originFileName:String="", sourceThumbImage:UIImage = UIImage.init()) ->Photo {
        
        //Resize Image
        var image = sourceImage
        if _NEEDRESIZEIMAGE {
            image = resizeImage(sourceImage)
            
        }else{
            image = rotateImage(sourceImage)
            
        }
        
        let thumbImageBefore = cropToBounds(image, width: _THUMBNAILWIDTH, height: _THUMBNAILHEIGHT)
        let thumbImage = resizeImage(thumbImageBefore, imageWidth: _THUMBNAILWIDTH, imageHeight: _THUMBNAILHEIGHT)
        
        let dataInPNG:Data = image.jpegData(compressionQuality: 1.0)!
        let dataInPNG_thumb:Data = thumbImage.jpegData(compressionQuality: 0.1)!
        
        var imageName = ""
        var saveObjFullPath = ""
        var saveObjFullThumbPath = ""
        
        //let fileManager:NSFileManager = NSFileManager.defaultManager()
        let photoDataHelper = PhotoDataHelper()
        
        //Photo Status From Task to Defect
        if photoFileName != "" {
            saveObjFullPath = savePath+"/"+photoFileName
            saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+photoFileName
            
            try? dataInPNG.write(to: URL(fileURLWithPath: saveObjFullPath), options: [.atomic])
            try? dataInPNG_thumb.write(to: URL(fileURLWithPath: saveObjFullThumbPath), options: [.atomic])
            
            let photo =  photoDataHelper.updatePhotoDatas(photoId!, dataType: dataType, dataRecordId: dataRecordId!)!
            
            return photo
        }else{
            //Update db and Get the photo Id, then using the photo id as name
            //Update DB
            var photo = initPhotoObj(nil,taskId: taskId, refPhotoId: 0, orgFileName: "", imageName: "", photoDesc: "",dataRecordId:dataRecordId,createUser:inspectorName,createDate:currentDate,modifyUser:Cache_Inspector?.appUserName,modifyDate:currentDate, dataType: dataType)
            
            photo = photoDataHelper.savePhoto(photo!)
            
            //Update Photo Name
            imageName = String((photo?.photoId)!)+".jpg"
            var prefixs = 14
            let nameLen = imageName.characters.count
            
            while prefixs - nameLen > 0 {
                imageName = "0"+imageName
                prefixs -= 1
            }
            
            photo?.orgFileName = originFileName
            photo?.photoFilename = imageName
            photo?.photoFile = imageName
            photo?.thumbFile = imageName
            photo = photoDataHelper.savePhoto(photo!)
            
            saveObjFullPath = savePath+"/"+imageName
            saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+imageName
            
            try? dataInPNG.write(to: URL(fileURLWithPath: saveObjFullPath), options: [.atomic])
            try? dataInPNG_thumb.write(to: URL(fileURLWithPath: saveObjFullThumbPath), options: [.atomic])
            
            return photo!
        }
    }

    
    func getNameBySaveImageToLocal(_ sourceImage:UIImage, photoFileName:String="",photoId:Int?=0, savePath:String, taskId:Int, bookingNo:String, inspectorName:String, dataRecordId:Int?=0, dataType:Int, currentDate:String, originFileName:String="", sourceThumbImage:UIImage = UIImage.init()) ->String {
    
        //Resize Image
        var image = sourceImage
        if _NEEDRESIZEIMAGE {
            image = resizeImage(sourceImage)
        
        }else{
            image = rotateImage(sourceImage)
            
        }
        
        let thumbImageBefore = cropToBounds(image, width: _THUMBNAILWIDTH, height: _THUMBNAILHEIGHT)
        let thumbImage = resizeImage(thumbImageBefore, imageWidth: _THUMBNAILWIDTH, imageHeight: _THUMBNAILHEIGHT)
        
        let dataInPNG:Data = image.jpegData(compressionQuality: 1.0)!
        let dataInPNG_thumb:Data = thumbImage.jpegData(compressionQuality: 0.1)!
        
        var imageName = ""
        var saveObjFullPath = ""
        var saveObjFullThumbPath = ""
        
        //let fileManager:NSFileManager = NSFileManager.defaultManager()
        let photoDataHelper = PhotoDataHelper()
        
        //Photo Status From Task to Defect
        if photoFileName != "" {
            saveObjFullPath = savePath+"/"+photoFileName
            saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+photoFileName
            
            try? dataInPNG.write(to: URL(fileURLWithPath: saveObjFullPath), options: [.atomic])
            try? dataInPNG_thumb.write(to: URL(fileURLWithPath: saveObjFullThumbPath), options: [.atomic])
            
            if (photoDataHelper.updatePhotoDatas(photoId!, dataType: dataType, dataRecordId: dataRecordId!) != nil) {
                
                return photoFileName
            }else{
                return ""
            }
            
        }else{
            //Update db and Get the photo Id, then using the photo id as name
            //Update DB
            var photo = initPhotoObj(nil,taskId: taskId, refPhotoId: 0, orgFileName: "", imageName: "", photoDesc: "",dataRecordId:dataRecordId,createUser:inspectorName,createDate:currentDate,modifyUser:Cache_Inspector?.appUserName,modifyDate:currentDate, dataType: dataType)
            
            photo = photoDataHelper.savePhoto(photo!)
            
            //Update Photo Name
            imageName = String((photo?.photoId)!)+".jpg"
            var prefixs = 14
            let nameLen = imageName.characters.count
            
            while prefixs - nameLen > 0 {
                imageName = "0"+imageName
                prefixs -= 1
            }
            
            photo?.orgFileName = originFileName
            photo?.photoFilename = imageName
            photo?.photoFile = imageName
            photo?.thumbFile = imageName
            if (photoDataHelper.savePhoto(photo!) != nil) {
            
                saveObjFullPath = savePath+"/"+imageName
                saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+imageName
            
                try? dataInPNG.write(to: URL(fileURLWithPath: saveObjFullPath), options: [.atomic])
                try? dataInPNG_thumb.write(to: URL(fileURLWithPath: saveObjFullThumbPath), options: [.atomic])
            
                return imageName
            }else{
                return ""
            }
        }
    }
    
    func getNamesBySaveImageToLocal(_ sourceImages:[Photo], savePath:String, taskId:Int, bookingNo:String, inspectorName:String, dataRecordId:Int?=0, dataType:Int, currentDate:String, originFileName:String="", sourceThumbImage:UIImage = UIImage.init()) ->[String] {
        
        var images = [String]()
        for sourceImage in sourceImages {
        
        //Resize Image
        guard let imageOrigin = sourceImage.photo?.image else {
            return images
        }
        var image = imageOrigin
        if _NEEDRESIZEIMAGE {
            image = resizeImage(imageOrigin)
            
        }else{
            image = rotateImage(imageOrigin)
            
        }
        
        let thumbImageBefore = cropToBounds(image, width: _THUMBNAILWIDTH, height: _THUMBNAILHEIGHT)
        let thumbImage = resizeImage(thumbImageBefore, imageWidth: _THUMBNAILWIDTH, imageHeight: _THUMBNAILHEIGHT)
        
        let dataInPNG:Data = image.jpegData(compressionQuality: 1.0)!
        let dataInPNG_thumb:Data = thumbImage.jpegData(compressionQuality: 0.1)!
        
        var imageName = ""
        var saveObjFullPath = ""
        var saveObjFullThumbPath = ""
        
        //let fileManager:NSFileManager = NSFileManager.defaultManager()
        let photoDataHelper = PhotoDataHelper()
        
       
            //Update db and Get the photo Id, then using the photo id as name
            //Update DB
            var photo = initPhotoObj(nil,taskId: taskId, refPhotoId: 0, orgFileName: "", imageName: "", photoDesc: "",dataRecordId:dataRecordId,createUser:inspectorName,createDate:currentDate,modifyUser:Cache_Inspector?.appUserName,modifyDate:currentDate, dataType: dataType)
            
            photo = photoDataHelper.savePhoto(photo!)
            
            
            
            //Update Photo Name
            imageName = String((photo?.photoId)!)+".jpg"
            var prefixs = 14
            let nameLen = imageName.characters.count
            
            while prefixs - nameLen > 0 {
                imageName = "0"+imageName
                prefixs -= 1
            }
            
            photo?.orgFileName = originFileName
            photo?.photoFilename = imageName
            photo?.photoFile = imageName
            photo?.thumbFile = imageName
            if (photoDataHelper.savePhoto(photo!) != nil) {
                
                saveObjFullPath = savePath+"/"+imageName
                saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+imageName
                
                try? dataInPNG.write(to: URL(fileURLWithPath: saveObjFullPath), options: [.atomic])
                try? dataInPNG_thumb.write(to: URL(fileURLWithPath: saveObjFullThumbPath), options: [.atomic])
                
                images.append(imageName)
            }
        }
        
        return images
    }

    func removeImageFromLocalByPath(_ path:String) ->Bool {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
                return true
            }catch _ as NSError {
                return false
            }
        }
        
        return false
    }
    
    func removeImageFromLocal(_ photo:Photo, path:String) ->Bool {
        //Remove From DB
        let photoDataHelper = PhotoDataHelper()
        photoDataHelper.deletePhotoByPhotoId(photo.photoId!)
        
        //Remove From Local
        let fileManager = FileManager.default
        
        do {
            let fullImagePath = path+"/"+photo.photoFile
            try fileManager.removeItem(atPath: fullImagePath)
            
            print("Removed Image With Path: \(fullImagePath)")
        }
        catch let error as NSError {
            print("Removing Image... Something went wrong: \(error)")
        }
        
        do {
            let fullImagePath = path+"/"+_THUMBSPHYSICALNAME+"/"+photo.photoFile
            try fileManager.removeItem(atPath: fullImagePath)
            
            print("Removed Thumb Image With Path: \(fullImagePath)")
        }
        catch let error as NSError {
            print("Removing Thumb Image... Something went wrong: \(error)")
        }
        
        return true
    }
    
    func toBase64()->String{
        
        if let imageData = self.pngData() {
            let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
            return base64String
        }
        
        return ""
    }
    
    func fromBase64(_ base64String:String) ->UIImage {
        
        if let decodedData = Data(base64Encoded: base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            if let decodedimage = UIImage(data: decodedData) {
                return decodedimage
            }
        }
        
        return UIImage.init()
    }
    
    func saveImageToLocal(_ savePath:String, image:UIImage, imageName:String) {
        let dataInPNG:Data = image.jpegData(compressionQuality: 1.0)!
        let path = savePath+imageName
        let filemgr = FileManager.default
        
        if !filemgr.fileExists(atPath: savePath) {
            
            do {
                try filemgr.createDirectory(atPath: savePath, withIntermediateDirectories: true, attributes: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        try? dataInPNG.write(to: URL(fileURLWithPath: path), options: [.atomic])
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImage.Orientation.up ) {
            return UIImage(cgImage: cgImage!, scale: scale, orientation: imageOrientation)
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        }
        
        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImage.Orientation.left ||
            self.imageOrientation == UIImage.Orientation.leftMirrored ||
            self.imageOrientation == UIImage.Orientation.right ||
            self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

extension Date {
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func returnDateForMonth(_ month:NSInteger, year:NSInteger, day:NSInteger)->Date{
        var comp = DateComponents()
        comp.month = month
        comp.year = year
        comp.day = day
        
        let grego = Calendar.current
        return grego.date(from: comp)!
    }
    
    func firstDateOfMonth(_ date:Date=Date()) -> String {
        let calendar = Calendar.current
        let dateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.month, NSCalendar.Unit.year], from: date)
        let firstDay = self.returnDateForMonth(dateComponents.month!, year: dateComponents.year!, day: 1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        return dateFormatter.string(from: firstDay)
    }
    
    func getWeekDateByDate(_ date:String) ->Int {
        let dateStyler = DateFormatter()
        dateStyler.dateFormat = _DATEFORMATTER
        
        let myDate = dateStyler.date(from: date)!
        
        let myWeekday = (Calendar.current as NSCalendar).components(NSCalendar.Unit.weekday, from: myDate).weekday
        
        return myWeekday!
    }
}

extension UITextView {
    
    func showListData(_ sender: UITextView, parent:UIView, handle:((UITextView)->(Void))?=nil, listData:NSArray, width:CGFloat=_DEVICE_WIDTH/3, height:CGFloat=250, allowMulpSel:Bool=false, tag:Int = 100000, allowManuallyInput:Bool=false, keyValues:[String:Int] = [String:Int](), selectedValues:[Int]=[Int]()) /*->DropdownListViewControl*/ {
        let width = sender.frame.size.width < 250 ? 250 : sender.frame.size.width
        if listData.count > 0 {

            Cache_Dropdown_Instance?.removeFromSuperview()
            
            if Cache_Dropdown_Instance == nil {
                Cache_Dropdown_Instance = DropdownListViewControl.loadFromNibNamed("DropdownListView")!
            }
            
            Cache_Dropdown_Instance!.dropdownData = listData as! [String]
            
            // for fix auto layout position in stackview
            let frame = sender.superview?.convert(sender.frame, to: parent)
            
            let actualHeight = CGFloat(listData.count*50)
            let adjustheight = actualHeight < height ? (actualHeight - 1) : (height - 1)
            var actualMinX = frame?.origin.x ?? 0
            
            if actualMinX + width > _DEVICE_WIDTH {
                actualMinX = _DEVICE_WIDTH - width
            }
            
//            var minY = sender.superview!.frame.minY+sender.frame.minY+sender.frame.size.height
            var minY = (frame?.origin.y ?? 0) + (frame?.size.height ?? 0)
            
            if String(describing: sender.superview!.classForCoder) != nil {
                let classCode = String(describing: sender.superview!.classForCoder)
                
                if classCode == "UITableViewCellContentView" {
//                    minY = sender.superview!.superview!.frame.minY+sender.superview!.frame.minY+sender.frame.minY+sender.frame.size.height
                    minY = sender.superview!.superview!.frame.minY+minY
                }
            }
            
            let absolutePoint = sender.convert(sender.bounds, to: nil)
            let adjustMinY = absolutePoint.origin.y + 80 + sender.frame.size.height + adjustheight
            if adjustMinY > _DEVICE_HEIGHT {
                minY -= adjustMinY - _DEVICE_HEIGHT
            }

            Cache_Dropdown_Instance!.frame = CGRect.init(x: actualMinX, y: minY, width: width, height: adjustheight)
            
            Cache_Dropdown_Instance!.sizeWidth = Int(width)
            Cache_Dropdown_Instance!.sizeHeight = Int(adjustheight) //Int(height)
            
            Cache_Dropdown_Instance!.myParentTextView = sender
            Cache_Dropdown_Instance!.layer.cornerRadius = 5.0
            Cache_Dropdown_Instance!.tableView.allowsMultipleSelection = allowMulpSel
            Cache_Dropdown_Instance?.allowManuallyInput = allowManuallyInput
            Cache_Dropdown_Instance!.tableView.rowHeight = 50
            Cache_Dropdown_Instance!.handleFunTextView = handle
            Cache_Dropdown_Instance?.tag = tag
            Cache_Dropdown_Instance?.keyValues = keyValues
            Cache_Dropdown_Instance?.selectedValues = selectedValues
            
            parent.addSubview(Cache_Dropdown_Instance!)
        }else{
            Cache_Dropdown_Instance?.removeFromSuperview()
        }
    }
}

extension UITextField {
    
    func showListData(_ sender: UITextField, parent:UIView, handle:((UITextField)->(Void))?=nil, listData:NSArray, width:CGFloat=_DEVICE_WIDTH/3, height:CGFloat=500, allowMulpSel:Bool=false, tag:Int = 100000, allowManuallyInput:Bool=false, keyValues:[String:Int] = [String:Int](), selectedValues:[Int]=[Int]()) /*->DropdownListViewControl*/ {
        let width = sender.frame.size.width < 250 ? 250 : sender.frame.size.width
        let height = 500.0
        if listData.count > 0 {

            Cache_Dropdown_Instance?.removeFromSuperview()
            
            if Cache_Dropdown_Instance == nil {
                Cache_Dropdown_Instance = DropdownListViewControl.loadFromNibNamed("DropdownListView")!
            }
            
            Cache_Dropdown_Instance!.dropdownData = listData as! [String]
            
            // for fix auto layout position in stackview
            let frame = sender.superview?.convert(sender.frame, to: parent)
            
            let actualHeight = CGFloat(listData.count*50)
            let adjustheight = actualHeight < height ? (actualHeight - 1) : (height - 1)
            var actualMinX = frame?.origin.x ?? 0
            
            if actualMinX + width > _DEVICE_WIDTH {
                actualMinX = _DEVICE_WIDTH - width
            }
            
//            var minY = sender.superview!.frame.minY+sender.frame.minY+sender.frame.size.height
            var minY = (frame?.origin.y ?? 0) + (frame?.size.height ?? 0)
            
            if String(describing: sender.superview!.classForCoder) != nil {
                let classCode = String(describing: sender.superview!.classForCoder)
                
                if classCode == "UITableViewCellContentView" {
//                    minY = sender.superview!.superview!.frame.minY+sender.superview!.frame.minY+sender.frame.minY+sender.frame.size.height
                    minY = sender.superview!.superview!.frame.minY+minY
                }
            }
            
            let absolutePoint = sender.convert(sender.bounds, to: nil)
            let adjustMinY = absolutePoint.origin.y + 80 + sender.frame.size.height + adjustheight
            if adjustMinY > _DEVICE_HEIGHT {
                minY -= adjustMinY - _DEVICE_HEIGHT
            }

            Cache_Dropdown_Instance!.frame = CGRect.init(x: actualMinX, y: minY, width: width, height: adjustheight)
            
            Cache_Dropdown_Instance!.sizeWidth = Int(width)
            Cache_Dropdown_Instance!.sizeHeight = Int(adjustheight) //Int(height)
            
            Cache_Dropdown_Instance!.myParentTextField = sender
            Cache_Dropdown_Instance!.layer.cornerRadius = 5.0
            Cache_Dropdown_Instance!.tableView.allowsMultipleSelection = allowMulpSel
            Cache_Dropdown_Instance?.allowManuallyInput = allowManuallyInput
            Cache_Dropdown_Instance!.tableView.rowHeight = 50
            Cache_Dropdown_Instance!.handleFun = handle
            Cache_Dropdown_Instance?.tag = tag
            Cache_Dropdown_Instance?.keyValues = keyValues
            Cache_Dropdown_Instance?.selectedValues = selectedValues
            
            parent.addSubview(Cache_Dropdown_Instance!)
        }else{
            Cache_Dropdown_Instance?.removeFromSuperview()
        }
    }
 
    func numberOnlyCheck(_ textField:UITextField, sourceText:String) ->Bool {
        if textField.text!.characters.count >= _MAXIMUNINT {
            textField.text = String(textField.text!.characters.dropLast())
            return false
        }
        
        var inputValue = ""
        if textField.text!.characters.count < 2 && sourceText == "" {
            inputValue = ""
        }else if sourceText == ""{
            inputValue = String(textField.text!.characters.dropLast())
        }else {
            inputValue = textField.text! + sourceText
        }
        
        if inputValue != "" && (Int(inputValue) == nil || Int(inputValue) < 1) {
            return false
        }
        
        let aSet = CharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = sourceText.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        return sourceText == numberFiltered
    }
    
    func showDatePicker(_ sender: UITextField) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 365, height: 350 + _NAVIBARHEIGHT+20)// CGSizeMake(320,350 + _NAVIBARHEIGHT)
        popoverContent.parentTextFieldView = sender
        popoverContent.sourceType = _BOOKINGDATEFROMDATETYPE
        popoverContent.dataType = _POPOVERDATETPYE
        
        let nav = CustomNavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        nav.view.translatesAutoresizingMaskIntoConstraints = false
        nav.navigationBar.barTintColor = .black

        let popover = nav.popoverPresentationController
        popover!.delegate = sender.parentVC as! PopoverMaster
        popover!.sourceView = sender
        popover!.sourceRect = sender.bounds
        
        sender.parentVC!.present(nav, animated: true, completion: nil)
    }
    
    func showMultiDropdownValues(_ dataSource: String, textField: UITextField, keyValues: [String:Int]) ->String {
        var dataSource = dataSource, textField = textField
        
        textField.text = ""
        var keys = [String]()
        var values = [Int]()
        
        if Cache_Dropdown_Instance?.selectedValues != nil {
            values = (Cache_Dropdown_Instance?.selectedValues)!
        } else {
            let defaultValues = dataSource.characters.split{$0 == ","}.map(String.init)
            defaultValues.forEach({
                if let v = Int($0) {
                    values.append(v)
                }
            })
        }
        
        dataSource = ""

        for value in values {
            dataSource += String(format: "%d,", value)
            let allKeys = keyValues.allKeysForValue(value)
            keys.append(allKeys.first ?? "")
            
        }
        
        keys.sort(by: { $0 < $1 })
        keys.forEach({ key in
            textField.text! += String(format: "%@,", key)
        })
        
        if let tempStr = textField.text {
            if tempStr.characters.count > 0 {
                textField.text = tempStr.substring(to: tempStr.characters.index(before: tempStr.endIndex))
            }
        }
        
        return dataSource
    }
}

extension String {
    func md5() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    // url encode
    var urlEncode:String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    
    // url decode
    var urlDecode :String? {
        return self.removingPercentEncoding
    }
}


extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}

extension Array where Element:Weak<AnyObject> {
    mutating func reap () {
        self = self.filter { nil != $0.value }
    }
}

extension UIBezierPath {
    
    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform )
        path.closeSubpath()
        return self.init(cgPath: path)
    }
    
}

extension Dictionary where Value : Equatable {
    func allKeysForValue(_ val : Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalCIContextOptionDictionary(_ input: [String: Any]?) -> [CIContextOption: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (CIContextOption(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCIContextOption(_ input: CIContextOption) -> String {
	return input.rawValue
}

extension UIView {
    func showTextFieldFullTextButton(textField: UITextField) {
        let detailButton = CustomButton()
        detailButton.setTitleColor(.systemBlue, for: .normal)
        detailButton.setTitle("+", for: .normal)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.addTarget(self, action: #selector(showDetailDidPress(_:)), for: .touchUpInside)
        detailButton.destinationTextField = textField
        self.addSubview(detailButton)
        
        NSLayoutConstraint.activate([
            detailButton.widthAnchor.constraint(equalToConstant: 20),
            detailButton.heightAnchor.constraint(equalToConstant: 20),
            detailButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            detailButton.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -8)
        ])
    }
    
    @objc func showDetailDidPress(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)
        popoverContent.dataType = _POPOVERNOTITLE
        if let customButton = sender as? CustomButton {
            popoverContent.selectedValue = customButton.destinationTextField?.text ?? ""
        } else {
            popoverContent.selectedValue = ""
        }
        
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

extension UITextField {
    func isTruncated() -> Bool {
        if let font = self.font, let text = self.text {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (text as NSString).size(withAttributes: fontAttributes)
            let textFieldWidth = self.frame.size.width - 24
            return size.width > textFieldWidth
        }
        return false
    }
}

extension UISegmentedControl {
    func updateSegmentWidthAtIndex(index: Int) {
        if let text = self.titleForSegment(at: index) {
            let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
            let size = (text as NSString).size(withAttributes: fontAttributes)
            let segmentWidth:CGFloat = self.frame.size.width / CGFloat(self.numberOfSegments)
            if size.width > (segmentWidth - 6) {
                let newSegmentWidth = (self.frame.size.width - size.width - 10.0) / CGFloat(self.numberOfSegments-1)
                for newIndex in 0...self.numberOfSegments-1 {
                    if newIndex != index {
                        self.setWidth(newSegmentWidth - 0.4, forSegmentAt: newIndex)
                    }
                }
                self.setWidth(size.width + 10.0, forSegmentAt: index)
            }
        }
    }
}

