//
//  KeyValueDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 26/10/2016.
//  Copyright © 2016 kira. All rights reserved.
//


import Foundation
import UIKit

class KeyValueDataHelper:DataHelperMaster {
    
    func updateLastLoginDatetime(_ userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?,?,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: ["LastLoginDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastLoginDatetimeByUserId(_ userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["LastLoginDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.string(forColumn: "value") ?? ""
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastDownloadDatetime(_ userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: ["LastDownloadDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastDownloadDatetimeByUserId(_ userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["LastDownloadDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.string(forColumn: "value") ?? ""
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastUploadDatetime(_ userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: ["LastUploadDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastUploadDatetimeByUserId(_ userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["LastUploadDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.string(forColumn: "value") ?? ""
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastBackupDatetime(_ userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: ["LastBackupDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastBackupDatetimeByUserId(_ userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["LastBackupDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.string(forColumn: "value") ?? ""
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastRestoreDatetime(_ userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: ["LastRestoreDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastRestoreDatetimeByUserId(_ userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["LastRestoreDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.string(forColumn: "value") ?? ""
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastUploadTasksCount(_ userId:String, tasksCount:Int) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: ["LastUploadTasksCount-"+userId, tasksCount]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastUploadTasksCountByUserId(_ userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["LastUploadTasksCount-"+userId]) {
                if rs.next() {
                    datetime = rs.string(forColumn: "value") ?? ""
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func saveInspectorSignImage(_ userId:String, imageToBase64:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ?, datetime('now','localtime'))"
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsIn: ["InspectorSignImage-"+userId, imageToBase64]) {
                db.close()
                return false
            }
            
            db.close()
        }
        
        return true
    }
    
    func getInspectorSignImage(_ userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var inspectorSignImage = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["InspectorSignImage-"+userId]) {
                if rs.next() {
                    inspectorSignImage = rs.string(forColumn: "value") ?? ""
                }
            }
            
            db.close()
        }
        
        return inspectorSignImage
    }
    
    func getTaskRunningNoByDate(_ userId:String) ->String {
        var sql = "SELECT * FROM option_key_value WHERE key = ? AND date_added >= date('now','0 day')"
        var runningNo = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["TaskRunningNo-"+userId]) {
                if rs.next() {
                    runningNo = Int(rs.string(forColumn: "value") ?? "0")! + 1
                    
                    sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ?, datetime('now','localtime'))"
                    
                    if db.executeUpdate(sql, withArgumentsIn: ["TaskRunningNo-"+userId, runningNo]) {
                        
                    }
                    
                }else{
                    
                    sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ?, datetime('now','localtime'))"
                    
                    if db.executeUpdate(sql, withArgumentsIn: ["TaskRunningNo-"+userId, runningNo]) {
                       runningNo = 0
                    }
                    
                }
            }
            
            db.close()
        }
        
        return String(runningNo)
    }

    func updateDBVersionNum(_ versionNum:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsIn: ["version", versionNum]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getDBVersionNum() ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var version = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: ["version"]) {
                if rs.next() {
                    version = rs.string(forColumn: "value") ?? ""
                }
            }
            
            db.close()
        }
        
        return version
    }
}

