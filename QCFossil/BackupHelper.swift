//
//  BackupHelper.swift
//  QCFossil
//
//  Created by pacmobile on 6/9/2022.
//  Copyright © 2022 kira. All rights reserved.
//

import Foundation
import UIKit

class BackupHelper: DataHelperMaster {
    func insertTaskFoldersToUpload(taskFolders: [String]) -> Bool {
        let sql = "INSERT INTO backup_log_task_folder_upload_status ('task_folder_name') VALUES (?)"
        
        if db.open() {
            db.beginTransaction()
            
            for taskFolder in taskFolders {
                if !db.executeUpdate(sql, withArgumentsIn: [taskFolder]) {
                    db.rollback()
                    db.close()
                    return false
                }
            }
            
            db.commit()
            db.close()
        }
        return true
    }
    
    @discardableResult
    func updateTaskFolderWithUploadDate(taskFolder: String) -> Bool {
        let sql = "UPDATE backup_log_task_folder_upload_status SET upload_date = datetime('now') WHERE task_folder_name = ?"
        
        if db.open() {
            if !db.executeUpdate(sql, withArgumentsIn: [taskFolder]) {
                db.rollback()
                db.close()
                return false
            }
            db.close()
        }
        return true
    }
    
    @discardableResult
    func updateTaskFolderWithDeletedDate(taskFolder: String) -> Bool {
        let sql = "UPDATE backup_log_task_folder_upload_status SET local_zip_delete_date = datetime('now') WHERE task_folder_name = ?"
        
        if db.open() {
            if !db.executeUpdate(sql, withArgumentsIn: [taskFolder]) {
                db.rollback()
                db.close()
                return false
            }
            db.close()
        }
        return true
    }
    
    @discardableResult
    func clearBackupLog() -> Bool {
        let sql = "DELETE FROM backup_log_task_folder_upload_status"
        if db.open(){
            if !db.executeUpdate(sql, withArgumentsIn: []) {
                db.close()
                return false
            }
            db.close()
        }
        return true
    }
    
    func getRemainZipTaskFolders() -> [String] {
        let sql = "SELECT task_folder_name FROM backup_log_task_folder_upload_status WHERE local_zip_delete_date IS NULL"
        var taskFolders = [String]()
        if db.open(){
            if let rs = db.executeQuery(sql, withArgumentsIn: []) {
                while rs.next() {
                    if let taskFolderName = rs.string(forColumn: "task_folder_name") {
                        taskFolders.append(taskFolderName)
                    }
                }
            }
            db.close()
        }
        return taskFolders
    }
}
