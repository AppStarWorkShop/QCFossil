//
//  AppUpgradeDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 13/12/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class AppUpgradeDataHelper:DataHelperMaster {

    func appUpgradeCode(_ appVersionCode:String? = nil, parentView:UIView, completion:@escaping (_ result: Bool) -> ()) {
        
        DispatchQueue.main.async(execute: {
            parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("DB Updating"))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                var result = true
                var database = "\(_DBNAME_USING)_\((Cache_Inspector?.appUserName?.lowercased())!)"
                let filemgr = FileManager.default
                let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let dbDir = dirPaths[0] as String
                let databasePath = dbDir + "/\((Cache_Inspector?.appUserName?.lowercased())!)\(database)"
                let databasePathBakup = dbDir + "/\((Cache_Inspector?.appUserName?.lowercased())!)\(database)_bakup"
                
                //If Backup File Exist, Restore First...
                if filemgr.fileExists(atPath: databasePathBakup) {
                    print("DB Backup File Found, Restore Now...")
                    
                    do {
                        try filemgr.removeItem(atPath: databasePath)
                        try filemgr.moveItem(atPath: databasePathBakup, toPath: databasePath)
                        try filemgr.removeItem(atPath: databasePathBakup)
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        completion(result)
                    }
                }
                
                //Backup DB Here...
                parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("DB Backup"))
                
                if Cache_Inspector?.appUserName != "" {
                    database = _DBNAME_USING + "_" + (Cache_Inspector?.appUserName?.lowercased())!
                    _TASKSPHYSICALPATH = "\(_TASKSPHYSICALPATHPREFIX + (Cache_Inspector?.appUserName?.lowercased())! + "/\(_TASKSPHYSICALFOLDERNAME)")/"
                    
                }
                
                if filemgr.fileExists(atPath: databasePath) {
                    
                    do {
                        try filemgr.copyItem(atPath: databasePath, toPath: databasePathBakup)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                //End Backup DB...
                
                parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Updating"))
                if self.db.open() {
                    self.db.beginTransaction()
                    
                    //---------------------------- Vdr Location Mstr ----------------------------
                    var sql = "ALTER TABLE vdr_location_mstr ADD COLUMN vdr_sign_name varchar(100) DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(vdr_location_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "vdr_sign_name" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Inspect Mstr ----------------------------
                    sql = "ALTER TABLE inspector_mstr ADD COLUMN chg_pwd_req_date varchar(30) DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspector_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "chg_pwd_req_date" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Fgpo Line Item ----------------------------
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN prod_desc text DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "prod_desc" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    //-------------------------------- Task Inspect Photo File ----------------------------
                    sql = "ALTER TABLE task_inspect_photo_file ADD COLUMN upload_date datetime"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_inspect_photo_file)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "upload_date" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    sql = "UPDATE task_inspect_photo_file SET upload_date = datetime('now','localtime') WHERE task_id IN (SELECT task_id FROM inspect_task WHERE task_status = ? OR task_status = ?)"
                    
                    if !self.db.executeUpdate(sql, withArgumentsIn: [GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Uploaded").rawValue]) {
                        result = false
                    }
                    
                    //---------------------------- Inspect Task ----------------------------
                    sql = "ALTER TABLE inspect_task ADD COLUMN confirm_upload_date datetime"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "confirm_upload_date" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Add Trigger ----------------------------
                    sql = "DROP TRIGGER IF EXISTS t_task_inspect_photo_file_after_update;CREATE TRIGGER IF NOT EXISTS t_task_inspect_photo_file_after_update AFTER UPDATE ON task_inspect_photo_file FOR EACH ROW BEGIN UPDATE inspect_task SET task_status = 5 WHERE task_status = 4 AND (confirm_upload_date IS NOT NULL OR confirm_upload_date <> '') AND task_id IN ( SELECT DISTINCT it.task_id FROM inspect_task it WHERE it.task_id = NEW.task_id AND NOT EXISTS ( SELECT 1 FROM task_inspect_photo_file tipf WHERE tipf.task_id = it.task_id AND (tipf.upload_date IS NULL OR tipf.upload_date = '')));END;"
                    
                    if !self.db.executeStatements(sql) {
                        result = false
                    }
                    
                    //---------------------------- Inspect Position Mstr for 1.09 ----------------------------
                    sql = "ALTER TABLE inspect_position_mstr ADD COLUMN position_zone_set_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_position_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "position_zone_set_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    sql = "ALTER TABLE inspect_element_mstr ADD COLUMN inspect_defect_set_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_element_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "inspect_defect_set_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    sql = "ALTER TABLE inspect_element_mstr ADD COLUMN inspect_case_set_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_element_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "inspect_case_set_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    sql = "ALTER TABLE inspect_element_mstr ADD COLUMN inspect_case_set_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_element_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "inspect_case_set_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add table zone_value_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `zone_value_mstr` ( `value_id` VARCHAR ( 10 ), `value_code` VARCHAR ( 30 ) NOT NULL, `value_name_en` VARCHAR ( 60 ) NOT NULL, `value_name_cn` VARCHAR ( 60 ) NOT NULL, `display_order` VARCHAR ( 10 ) NOT NULL, `rec_status` VARCHAR ( 2 ) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, `deleted_flag` VARCHAR ( 1 ) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR ( 30 ), PRIMARY KEY(`value_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table zone_set_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `zone_set_mstr` ( `set_id` VARCHAR ( 10 ), `set_name` VARCHAR ( 60 ) NOT NULL, `rec_status` VARCHAR ( 2 ) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, `deleted_flag` VARCHAR ( 1 ) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR ( 30 ), PRIMARY KEY(`set_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table zone_set_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `zone_set_value` ( `set_id` VARCHAR ( 10 ), `value_id` VARCHAR ( 10 ), `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, PRIMARY KEY(`set_id`,`value_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table case_value_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `case_value_mstr` ( `value_id` VARCHAR ( 10 ), `value_code` VARCHAR ( 10 ) NOT NULL, `value_name_en` VARCHAR ( 60 ) NOT NULL, `value_name_cn` VARCHAR ( 60 ) NOT NULL, `display_order` VARCHAR ( 10 ) NOT NULL, `rec_status` VARCHAR ( 2 ) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, `deleted_flag` VARCHAR ( 1 ) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR ( 30 ), PRIMARY KEY(`value_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table case_set_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `case_set_mstr` ( `set_id` VARCHAR ( 10 ), `set_name` VARCHAR ( 60 ) NOT NULL, `rec_status` VARCHAR ( 2 ) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, `deleted_flag` VARCHAR ( 1 ) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR ( 30 ), PRIMARY KEY(`set_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table case_set_value
                    sql = "CREATE TABLE IF NOT EXISTS `case_set_value` ( `set_id` VARCHAR(10), `value_id` VARCHAR(10), `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table defect_value_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `defect_value_mstr` ( `value_id` VARCHAR(10), `value_code` VARCHAR(10) NOT NULL, `value_name_en` VARCHAR(60) NOT NULL, `value_name_cn` VARCHAR(60) NOT NULL, `display_order` VARCHAR(10) NOT NULL, `rec_status` VARCHAR(2) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, `deleted_flag` VARCHAR(1) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR(30), PRIMARY KEY(`value_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table defect_set_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `defect_set_mstr` ( `set_id` VARCHAR(30), `set_name` VARCHAR(60) NOT NULL, `rec_status` VARCHAR(2) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, `deleted_flag` VARCHAR(1) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR(30), PRIMARY KEY(`set_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table defect_set_value
                    sql = "CREATE TABLE IF NOT EXISTS `defect_set_value` ( `set_id` VARCHAR(10), `value_id` VARCHAR(10), `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, PRIMARY KEY(`value_id`,`set_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                
                    // Add table task_selection_option_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `task_selection_option_mstr` ( `option_id` NUMERIC(10,0) NOT NULL, `data_env` VARCHAR(30) NOT NULL, `selection_type` NUMERIC(2,0) NOT NULL, `result_code_match_list` VARCHAR(1000), `option_val` VARCHAR(100) NOT NULL, `option_text_en` VARCHAR(1000) NOT NULL, `option_text_zh` VARCHAR(1000) NOT NULL, `display_order` NUMERIC(10,0) NOT NULL, `rec_status` NUMERIC(2,0) NOT NULL, `create_user` VARCHAR(30) NOT NULL, `create_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `deleted_flag` NUMERIC(1,0) NOT NULL, `delete_user` VARCHAR(30), `delete_date` DATETIME, PRIMARY KEY(`option_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table inspect_task_qc_info
                    sql = "CREATE TABLE IF NOT EXISTS `inspect_task_qc_info` ( `ref_task_id` numeric(10,0) NOT NULL, `aql_qty` numeric(10,0), `product_class` varchar(50), `quality_standard` varchar(50), `adjust_time` varchar(50), `preinspect_detail` TEXT, `ca_form` varchar(50), `caseback_marking` varchar(50), `upc_orbid_status` varchar(50), `ts_report_no` varchar(50), `ts_submit_date` DATETIME, `ts_result` nvarchar(50), `qc_booking_ref_no` varchar(50), `ss_comment_ready`varchar(50), `ss_ready` varchar(50), `ss_photo_name` varchar(50), `battery_production_code` varchar(50), `with_quesiton_pending` varchar(50), `wth_same_po_rejected_bef` varchar(50), `assortment` varchar(50), `consigned_styles` varchar(50), `qc_inspect_type` varchar(50), `net_weight` varchar(50), `inspect_method` varchar(50), `length_requirement` varchar(50), `inspection_sample_ready` varchar(50), `fty_packing_info` varchar(50), `fty_droptest_info` varchar(50), `movt_origin` varchar(100), `battery_type` varchar(50), `pre_inspect_result` nvarchar(50), `pre_inspect_remark` TEXT, `reliability_remark` TEXT, `jwl_marking` varchar(50), `combine_qc_remarks` varchar(150), `links_remarks` nvarchar(50), `dusttest_remark` nvarchar(50), `smartlink_remark` nvarchar(50), `precise_report` nvarchar(50), `smartlink_report` nvarchar(50), `create_user` varchar(30) NOT NULL, `create_date` DATETIME NOT NULL, `modify_user` varchar(30) NOT NULL, `modify_date` DATETIME NOT NULL, inspector_names varchar(1000), PRIMARY KEY(`ref_task_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add table style_photo
                    sql = "CREATE TABLE IF NOT EXISTS `style_photo` ( `photo_id` numeric(10,0) NOT NULL, `data_env` varchar(30) NOT NULL, `style_no` varchar(30) NOT NULL, `ss_photo_name` varchar(50) NOT NULL, `create_date` datetime NOT NULL, `modify_date` datetime NOT NULL, `deleted_flag` numeric(1,0) NOT NULL, `delete_date` datetime, PRIMARY KEY(`photo_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsIn: []) {
                        result = false
                    }
                    
                    // Add new field to task_inspect_data_record
                    sql = "ALTER TABLE task_inspect_data_record ADD COLUMN inspect_position_zone_value_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_inspect_data_record)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "inspect_position_zone_value_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to task_defect_data_record
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN inspect_element_defect_value_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "inspect_element_defect_value_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to task_defect_data_record
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN inspect_element_case_value_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "inspect_element_case_value_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to qc_remarks_option_list
                    sql = "ALTER TABLE inspect_task ADD COLUMN qc_remarks_option_list TEXT"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "qc_remarks_option_list" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to additional_admin_item_option_list
                    sql = "ALTER TABLE inspect_task ADD COLUMN additional_admin_item_option_list TEXT"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "additional_admin_item_option_list" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to defect_remarks_option_list
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN defect_remarks_option_list TEXT"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "defect_remarks_option_list" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to defect_remarks_option_list
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN other_remarks TEXT"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "other_remarks" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to fgpo_line_item
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN market varchar(20)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "market" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to fgpo_line_item
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN material_category varchar(20)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "material_category" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to fgpo_line_item
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN ship_mode_name varchar(20)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "ship_mode_name" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_item
                    sql = "ALTER TABLE inspect_task_item ADD COLUMN item_barcode varchar(30)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "item_barcode" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_item
                    sql = "ALTER TABLE inspect_task_item ADD COLUMN retail_price NUMERIC(12,2)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "retail_price" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN inspector_names varchar(1000)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "inspector_names" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN wth_same_po_rejected_bef varchar(50)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "wth_same_po_rejected_bef" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to style_photo
                    sql = "ALTER TABLE style_photo ADD COLUMN ss_photo_avail_date datetime"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(style_photo)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "ss_photo_avail_date" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to style_photo
                    sql = "ALTER TABLE style_photo ADD COLUMN cb_photo_name varchar(50)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(style_photo)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "cb_photo_name" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to style_photo
                    sql = "ALTER TABLE style_photo ADD COLUMN cb_photo_avail_date datetime"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(style_photo)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "cb_photo_avail_date" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to style_photo
                    sql = "ALTER TABLE inspect_task_item ADD COLUMN currency currency"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "currency" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_item
                    sql = "ALTER TABLE inspect_task_item ADD COLUMN style_size text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "style_size" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_item
                    sql = "ALTER TABLE inspect_task_item ADD COLUMN substr_style_size text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_item)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_style_size" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_inspector_names text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_inspector_names" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_quality_standard text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_quality_standard" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_length_requirement text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_length_requirement" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_movt_origin text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_movt_origin" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_combine_qc_remarks text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_combine_qc_remarks" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_ss_ready text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_ss_ready" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_pre_inspect_remark text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_pre_inspect_remark" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_ss_comment_ready text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_ss_comment_ready" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_ca_form text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_ca_form" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_qc_info
                    sql = "ALTER TABLE inspect_task_qc_info ADD COLUMN substr_reliability_remark text"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_qc_info)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "substr_reliability_remark" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Update task_inspect_photo_file to add AUTOINCREMENT, UNIQUE to Primary Key to photo id
                    if Float(appVersionCode ?? "0") ?? 0 <= 1.16 {
                        sql = "CREATE TABLE `task_inspect_photo_file_temp` (`photo_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, `task_id` numeric(10,0) NOT NULL, `ref_photo_id` numeric(10,0), `org_filename` nvarchar(1000) NOT NULL, `photo_file` nvarchar(1000) NOT NULL, `thumb_file` nvarchar(1000), `photo_desc` nvarchar(1000), `data_record_id` numeric(10,0) DEFAULT (null), `create_user` varchar(30) NOT NULL, `create_date` datetime NOT NULL, `modify_user` varchar(30) NOT NULL, `modify_date` datetime NOT NULL,`data_type` NUMERIC(2,0) DEFAULT (0),`upload_date` DATETIME DEFAULT (null)); INSERT INTO task_inspect_photo_file_temp(photo_id, task_id, ref_photo_id, org_filename, photo_file, thumb_file, photo_desc, data_record_id, create_user, create_date, modify_user, modify_date, data_type, upload_date) SELECT photo_id, task_id, ref_photo_id, org_filename, photo_file, thumb_file, photo_desc, data_record_id, create_user, create_date, modify_user, modify_date, data_type, upload_date FROM task_inspect_photo_file; DROP TABLE task_inspect_photo_file;ALTER  TABLE task_inspect_photo_file_temp RENAME TO task_inspect_photo_file;"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                    
                        sql = "CREATE TRIGGER t_task_inspect_photo_file_after_update AFTER UPDATE ON task_inspect_photo_file FOR EACH ROW BEGIN UPDATE inspect_task SET task_status = 5 WHERE task_status = 4 AND (confirm_upload_date IS NOT NULL OR confirm_upload_date <> '') AND task_id IN ( SELECT DISTINCT it.task_id FROM inspect_task it WHERE it.task_id = NEW.task_id AND NOT EXISTS ( SELECT 1 FROM task_inspect_photo_file tipf WHERE tipf.task_id = it.task_id AND (tipf.upload_date IS NULL OR tipf.upload_date = '')));END"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                    
            
                        // Update task_inspect_field_value to add AUTOINCREMENT, UNIQUE to Primary Key to value id
                        sql = "CREATE TABLE `task_inspect_field_value_temp` (`value_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, `task_id` numeric(10,0) NOT NULL, `ref_value_id` numeric(10,0), `inspect_field_id` numeric(10,0) NOT NULL, `field_value` nvarchar(1000), `create_user` varchar(30) NOT NULL, `create_date` datetime NOT NULL, `modify_user` varchar(30) NOT NULL, `modify_date` datetime NOT NULL); INSERT INTO task_inspect_field_value_temp(value_id, task_id, ref_value_id, inspect_field_id, field_value, create_user, create_date, modify_user, modify_date) SELECT value_id, task_id, ref_value_id, inspect_field_id, field_value, create_user, create_date, modify_user, modify_date FROM task_inspect_field_value; DROP TABLE task_inspect_field_value;ALTER TABLE task_inspect_field_value_temp RENAME TO task_inspect_field_value;"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                    
                        // Update inspect_task_tmpl_position to add AUTOINCREMENT, UNIQUE to Primary Key to tmpl_id inspect_posotion_id
                        sql = "CREATE TABLE `inspect_task_tmpl_position_temp` (`tmpl_id` INTEGER NOT NULL, `inspect_position_id` INTEGER NOT NULL, `create_user` VARCHAR(30), `create_date` DATETIME, `modify_user` VARCHAR(30), `modify_date` DATETIME, PRIMARY KEY(`tmpl_id`,`inspect_position_id`)); INSERT INTO inspect_task_tmpl_position_temp(tmpl_id, inspect_position_id, create_user, create_date, modify_user, modify_date) SELECT tmpl_id, inspect_position_id, create_user, MIN(create_date), modify_user, modify_date FROM inspect_task_tmpl_position GROUP BY tmpl_id, inspect_position_id; DROP TABLE inspect_task_tmpl_position;ALTER TABLE inspect_task_tmpl_position_temp RENAME TO inspect_task_tmpl_position;"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                    
                        // Update inspect_position_element to add AUTOINCREMENT, UNIQUE to Primary Key to inspect_position_id inspect_element_id
                        sql = "CREATE TABLE `inspect_position_element_temp` (`inspect_position_id` INTEGER NOT NULL, `inspect_element_id` INTEGER NOT NULL, `create_user` VARCHAR(30), `create_date` DATETIME, `modify_user` VARCHAR(30), `modify_date` DATETIME, PRIMARY KEY(`inspect_position_id`,`inspect_element_id`)); INSERT INTO inspect_position_element_temp(inspect_position_id, inspect_element_id, create_user, create_date, modify_user, modify_date) SELECT inspect_position_id, inspect_element_id, create_user, MIN(create_date), modify_user, modify_date FROM inspect_position_element GROUP BY inspect_position_id, inspect_element_id; DROP TABLE inspect_position_element;ALTER TABLE inspect_position_element_temp RENAME TO inspect_position_element;"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                    
                        // Update inspect_task_tmpl_field to add AUTOINCREMENT, UNIQUE to Primary Key to tmpl_id inspect_field_id
                        sql = "CREATE TABLE `inspect_task_tmpl_field_temp` (`inspect_field_id` INTEGER, `create_user` VARCHAR(30) NOT NULL DEFAULT (null), `create_date` DATETIME, `modify_user` VARCHAR(30) DEFAULT (null), `modify_date` DATETIME, `tmpl_id` INTEGER, PRIMARY KEY(`inspect_field_id`,`tmpl_id`)); INSERT INTO inspect_task_tmpl_field_temp(inspect_field_id, create_user, create_date, modify_user, modify_date, tmpl_id) SELECT inspect_field_id, create_user, MIN(create_date), modify_user, modify_date, tmpl_id FROM inspect_task_tmpl_field GROUP BY inspect_field_id, tmpl_id; DROP TABLE inspect_task_tmpl_field;ALTER TABLE inspect_task_tmpl_field_temp RENAME TO inspect_task_tmpl_field;"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                    
                        // Update case_set_value to add AUTOINCREMENT, UNIQUE to Primary Key to set_id value_id
                        sql = "CREATE TABLE `case_set_value_temp` (`set_id` VARCHAR(10), `value_id` VARCHAR(10), `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, PRIMARY KEY(`set_id`,`value_id`)); INSERT INTO case_set_value_temp(set_id, value_id, create_user, create_date, modify_user, modify_date) SELECT set_id, value_id, create_user, MIN(create_date), modify_user, modify_date FROM case_set_value GROUP BY set_id, value_id; DROP TABLE case_set_value;ALTER TABLE case_set_value_temp RENAME TO case_set_value;"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                        
                        // Update inspect_task to add AUTOINCREMENT, UNIQUE to Primary Key to task_id
                        sql = "CREATE TABLE `inspect_task_temp` (`task_id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, `prod_type_id` numeric(10,0) NOT NULL, `inspect_type_id` numeric(10,0) NOT NULL, `booking_no` varchar(30), `booking_date` datetime, `vdr_location_id` numeric(10,0) NOT NULL, `report_inspector_id` numeric(10,0), `report_prefix` varchar(5), `report_running_no` numeric(10,0), `inspection_no` varchar(30), `inspection_date` datetime, `task_remarks` ntext, `vdr_notes` ntext, `inspect_result_value_id` numeric(10,0), `inspector_sign_image_file` text, `vdr_sign_name` varchar(60), `vdr_sign_image_file` text, `task_status` numeric(2,0) NOT NULL, `upload_inspector_id` numeric(10,0), `upload_device_id` varchar(100), `ref_task_id` numeric(10,0), `rec_status` numeric(2,0) NOT NULL, `create_user` varchar(30) NOT NULL, `create_date` datetime NOT NULL, `modify_user` varchar(30) NOT NULL, `modify_date` datetime NOT NULL, `deleted_flag` numeric(1,0) NOT NULL, `delete_user` varchar(30), `delete_date` datetime, `inspect_setup_id` NUMERIC(10,0) NOT NULL DEFAULT (null), `vdr_sign_date` datetime DEFAULT (null), `tmpl_id` INTEGER, `data_refuse_desc` VARCHAR(1000), `app_ready_purge_date` DATETIME, `review_remarks` ntext DEFAULT null, `review_user` VARCHAR(30) DEFAULT null, `review_date` DATETIME DEFAULT null, `cancel_date` DATETIME DEFAULT null, `confirm_upload_date` DATETIME DEFAULT null, `qc_remarks_option_list` TEXT, `additional_admin_item_option_list` TEXT); INSERT INTO inspect_task_temp(task_id, prod_type_id, inspect_type_id, booking_no, booking_date, vdr_location_id, report_inspector_id, report_prefix, report_running_no, inspection_no, inspection_date, task_remarks, vdr_notes, inspect_result_value_id, inspector_sign_image_file, vdr_sign_name, vdr_sign_image_file, task_status, upload_inspector_id, upload_device_id, ref_task_id, rec_status, create_user, create_date, modify_user, modify_date, deleted_flag, delete_user, delete_date, inspect_setup_id, vdr_sign_date, tmpl_id, data_refuse_desc, app_ready_purge_date, review_remarks, review_user, review_date, cancel_date, confirm_upload_date, qc_remarks_option_list, additional_admin_item_option_list) SELECT task_id, prod_type_id, inspect_type_id, booking_no, booking_date, vdr_location_id, report_inspector_id, report_prefix, report_running_no, inspection_no, inspection_date, task_remarks, vdr_notes, inspect_result_value_id, inspector_sign_image_file, vdr_sign_name, vdr_sign_image_file, task_status, upload_inspector_id, upload_device_id, ref_task_id, rec_status, create_user, create_date, modify_user, modify_date, deleted_flag, delete_user, delete_date, inspect_setup_id, vdr_sign_date, tmpl_id, data_refuse_desc, app_ready_purge_date, review_remarks, review_user, review_date, cancel_date, confirm_upload_date, qc_remarks_option_list, additional_admin_item_option_list FROM inspect_task; DROP TABLE inspect_task;ALTER TABLE inspect_task_temp RENAME TO inspect_task;"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                        
                        // add unique index
                        sql = "CREATE UNIQUE INDEX `inspect_task_index` ON `inspect_task` (`task_id`,`report_inspector_id`,`ref_task_id`);"
                        if !self.db.executeStatements(sql) {
                            result = false
                        }
                    }
                    
                    // Update vdr_brand_map table to remove unique key constraint
                    sql = "CREATE TABLE vdr_brand_map2 (data_env varchar(30) not null, vdr_id numeric(10,0) not null, brand_id numeric(10,0) not null, create_user varchar(30) not null, create_date datetime not null, modify_user varchar(30) not null, modify_date datetime not null);INSERT INTO vdr_brand_map2 (data_env, vdr_id, brand_id, create_user, create_date, modify_user, modify_date) SELECT data_env, vdr_id, brand_id, create_user, create_date, modify_user, modify_date FROM vdr_brand_map; DROP TABLE vdr_brand_map; ALTER TABLE vdr_brand_map2 RENAME TO vdr_brand_map;"
                    if !self.db.executeStatements(sql) {
                        result = false
                    }
                    
                    // Add support to french
                    // Add new field to prod_type_mstr
                    sql = "ALTER TABLE prod_type_mstr ADD COLUMN type_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(prod_type_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "type_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to case_value_mstr
                    sql = "ALTER TABLE case_value_mstr ADD COLUMN value_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(case_value_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "value_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to defect_value_mstr
                    sql = "ALTER TABLE defect_value_mstr ADD COLUMN value_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(defect_value_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "value_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_element_detail_select_val
                    sql = "ALTER TABLE inspect_element_detail_select_val ADD COLUMN select_text_fr nvarchar(1000)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_element_detail_select_val)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "select_text_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_element_mstr
                    sql = "ALTER TABLE inspect_element_mstr ADD COLUMN element_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_element_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "element_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_position_mstr
                    sql = "ALTER TABLE inspect_position_mstr ADD COLUMN position_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_position_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "position_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_section_mstr
                    sql = "ALTER TABLE inspect_section_mstr ADD COLUMN section_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_section_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "section_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_field_mstr
                    sql = "ALTER TABLE inspect_task_field_mstr ADD COLUMN field_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_field_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "field_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_field_select_val
                    sql = "ALTER TABLE inspect_task_field_select_val ADD COLUMN select_text_fr nvarchar(1000)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_field_select_val)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "select_text_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_task_tmpl_mstr
                    sql = "ALTER TABLE inspect_task_tmpl_mstr ADD COLUMN tmpl_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task_tmpl_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "tmpl_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to inspect_type_mstr
                    sql = "ALTER TABLE inspect_type_mstr ADD COLUMN type_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_type_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "type_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to result_value_mstr
                    sql = "ALTER TABLE result_value_mstr ADD COLUMN value_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(result_value_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "value_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to task_selection_option_mstr
                    sql = "ALTER TABLE task_selection_option_mstr ADD COLUMN option_text_fr nvarchar(1000)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_selection_option_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "option_text_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to zone_value_mstr
                    sql = "ALTER TABLE zone_value_mstr ADD COLUMN value_name_fr nvarchar(60)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(zone_value_mstr)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "value_name_fr" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new field to task_defect_data_record
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN is_pre_save nvarchar(1)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "is_pre_save" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }

                    // Add new field to task_inspect_data_record
                    sql = "ALTER TABLE task_inspect_data_record ADD COLUMN is_pre_save nvarchar(1)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_inspect_data_record)", withArgumentsIn: []) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.string(forColumn: "name") == "is_pre_save" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsIn: []) {
                            result = false
                        }
                    }
                    
                    // Add new table backup_task_upload_status
                    sql = "CREATE TABLE IF NOT EXISTS backup_log_task_folder_upload_status (task_folder_name nvarchar(1000), upload_date datetime DEFAULT (null), local_zip_delete_date datetime DEFAULT (null));"
                    if !self.db.executeStatements(sql) {
                        result = false
                    }
                    
                    //----------------------------------------------------------------------------------
                    
                    if result {
                        self.db.commit()
                    } else {
                        self.db.rollback()
                    }
                    
                    self.db.close()
                }
                
                //If upgrade success, remove the backup DB file, else rollback from the backup DB file
                if result && filemgr.fileExists(atPath: databasePathBakup) {
                    print("DB Upgrade Success, Remove Backup FIle Now...")
                    
                    do {
                        try filemgr.removeItem(atPath: databasePathBakup)
                        
                        DispatchQueue.main.async(execute: {
                            parentView.removeActivityIndicator()
                            parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Success"))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                parentView.removeActivityIndicator()
                                completion(result)
                            }
                        })
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        completion(result)
                    }
                }else if filemgr.fileExists(atPath: databasePathBakup) {
                    print("DB Upgrade Fail, Rollback Now...")
                    
                    do {
                        try filemgr.removeItem(atPath: databasePath)
                        try filemgr.moveItem(atPath: databasePathBakup, toPath: databasePath)
                        
                        DispatchQueue.main.async(execute: {
                            parentView.removeActivityIndicator()
                            parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail"))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                parentView.removeActivityIndicator()
                                completion(result)
                            }
                        })
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        completion(result)
                    }
                }else{
                    completion(false)
                }
                
                
            }
        })
    }
}
    
