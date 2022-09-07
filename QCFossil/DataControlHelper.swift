//
//  DataControlHelper.swift
//  QCFossil
//
//  Created by pacmobile on 4/9/2022.
//  Copyright © 2022 kira. All rights reserved.
//

import Foundation
import Zip

class DataControlHelper {
    static func getInspectorTaskFolderCount(inspectorName: String) -> (Int?, String?)? {
        do {
            let path = "\(NSHomeDirectory())/Documents/\(inspectorName)/Tasks"
            let filemgr = FileManager.default
            
            if filemgr.fileExists(atPath: path) {
                let folders = try filemgr.contentsOfDirectory(atPath: "\(path)")
                return (folders.count, nil)
            }
            return nil
        } catch {
            return (nil, "\(error.localizedDescription)")
        }
    }
    
    static func getInspectorTaskFolders(inspectorName: String) -> [String] {
        do {
            let path = "\(NSHomeDirectory())/Documents/\(inspectorName)/Tasks"
            let filemgr = FileManager.default
            
            if filemgr.fileExists(atPath: path) {
                let folders = try filemgr.contentsOfDirectory(atPath: "\(path)")
                return folders.filter { $0 != ".DS_Store" && $0 != ".DS_Store.zip" }
            }
            return []
        } catch {
            return []
        }
    }
    
    static func zipTaskFolder(folderPath: String) -> (Bool, String?)? {
        do {
            if let filePath = URL(string: "\(folderPath)"), let zipFilePath = URL(string: "\(folderPath).zip") {
                try Zip.zipFiles(paths: [filePath], zipFilePath: zipFilePath, password: nil, progress: nil)
                return (true, nil)
            }
            return nil
        } catch {
            return (false, "\(error.localizedDescription)")
        }
    }
    
    static func getTaskFolderUploadURLRequest(serviceSession: String, taskFileName: String, taskFile: String, inspectorName: String) -> URLRequest? {
        guard let API = _DS_UPLOAD_BACKUP_TASK_FOLDER["APINAME"] as? String else { return nil }
        let boundary = "Boundary-\(UUID().uuidString)"
        let request = NSMutableURLRequest(url: URL(string: API)!)
        
        var param = _DS_UPLOAD_BACKUP_TASK_FOLDER["APIPARA"] as! [String:String]
        param["service_token"] = _DS_SERVICETOKEN
        param["service_session"] = serviceSession
        param["task_filename"] = taskFileName
        param["task_file"] = taskFile
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let requestBody = createBackupBodyWithParameters(param, boundary: boundary, inspectorName: inspectorName)
        request.httpBody = requestBody
        
        return request as URLRequest
    }
    
    static func createBackupBodyWithParameters(_ parameters: [String: String], boundary: String, inspectorName: String) -> Data {
        let body = NSMutableData()
        for (key, value) in parameters {
            if key != "task_file" {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            } else {
                
                let url = URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/\(inspectorName)/Tasks/\(value)")
                let data = try? Data(contentsOf: url)
                 
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(value)\"\r\n")
                body.appendString("Content-Type: application/zip\r\n\r\n")
                body.append(data!)
                body.appendString("\r\n")
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    @discardableResult
    static func removeZipTaskFolderAfterUpload(inspectorName: String, zipFileName: String) -> Bool {
        do {
            let filemgr = FileManager.default
            if filemgr.fileExists(atPath: "\(NSHomeDirectory())/Documents/\(inspectorName)/Tasks/\(zipFileName).zip") {
                try filemgr.removeItem(atPath: "\(NSHomeDirectory())/Documents/\(inspectorName)/Tasks/\(zipFileName).zip")
            }
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func setTaskFoldersToBackupLog(taskFolders: [String]) -> Bool {
        let backupHelper = BackupHelper()
        return backupHelper.insertTaskFoldersToUpload(taskFolders: taskFolders)
    }
    
    @discardableResult
    static func removeAllRemainZipTaskFolders() -> Bool {
        do {
            let backupHelper = BackupHelper()
            let taskFolders = backupHelper.getRemainZipTaskFolders()
            
            for taskFolder in taskFolders {
                let filemgr = FileManager.default
                if filemgr.fileExists(atPath: "\(NSHomeDirectory())/Documents/\(Cache_Inspector?.appUserName?.lowercased() ?? "")/Tasks/\(taskFolder).zip") {
                    try filemgr.removeItem(atPath: "\(NSHomeDirectory())/Documents/\(Cache_Inspector?.appUserName?.lowercased() ?? "")/Tasks/\(taskFolder).zip")
                }
            }
            return true
        } catch {
            return false
        }
    }
}
