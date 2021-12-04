//
//  DatabaseManager.swift
//  QCFossil
//
//  Created by pacmobile on 25/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

private let sharedDbMgr = DatabaseManager()

class DatabaseManager {
    var db = FMDatabase()
    
    func initDbObj(_ inspectorName:String = "")  {
        var database = _DBNAME_USING
        
        if inspectorName != "" {
            database = _DBNAME_USING + "_" + inspectorName
            _TASKSPHYSICALPATH = "\(_TASKSPHYSICALPATHPREFIX + inspectorName + "/\(_TASKSPHYSICALFOLDERNAME)")/"
            
        }
        
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print("path: \(dirPaths)")
        let dbDir = dirPaths[0] as String
        
        let foderPath = _TASKSPHYSICALPATHPREFIX + inspectorName
        let databasePath = dbDir + "/\(inspectorName)\(database)"
        let databaseJourneyPath = "\(databasePath)-journal"
        
        if !filemgr.fileExists(atPath: databasePath) {
            print("Database File No Exist! Copy From Code")
            
            do {
                try FileManager.default.createDirectory(atPath: foderPath, withIntermediateDirectories: true, attributes: nil)
                
                let srcPath = Bundle.main.path(forResource: _DBNAME_USING, ofType: "sqlite")
                
                try filemgr.copyItem(atPath: srcPath!, toPath: databasePath)
            } catch let error as NSError {
                print("initDbObj: "+error.localizedDescription)
            }
        } else if filemgr.fileExists(atPath: databaseJourneyPath) {
            do {
                // remove dummy database
                try filemgr.removeItem(atPath: databaseJourneyPath)
            } catch let error as NSError {
                print("initDbObj-removeItem: "+error.localizedDescription)
            }
        }
        
        db = FMDatabase(path: databasePath)
        
        _INSPECTORWORKINGPATH = foderPath
    }
    
    func openLocalDB(_ inspectorName:String = "") ->Bool {
        var database = _DBNAME_USING
        
        if inspectorName != "" {
            database = _DBNAME_USING + "_" + inspectorName
            _TASKSPHYSICALPATH = "\(_TASKSPHYSICALPATHPREFIX + inspectorName + "/\(_TASKSPHYSICALFOLDERNAME)")/"
            
        }
        
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print("path: \(dirPaths)")
        let dbDir = dirPaths[0] as String
        
        let foderPath = _TASKSPHYSICALPATHPREFIX + inspectorName
        let databasePath = dbDir + "/\(inspectorName)\(database)"
        
        if !filemgr.fileExists(atPath: databasePath) {
            print("No this Username")
            
            return false
        }
        
        db = FMDatabase(path: databasePath)
        _INSPECTORWORKINGPATH = foderPath
        
        return true
    }
    
    class var sharedDatabaseManager : DatabaseManager {
        return sharedDbMgr
    }
}
