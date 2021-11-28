//
//  VendorDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 26/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class VendorDataHelper:DataHelperMaster{
    
    func getVdrNameByLocationId(_ locationId:Int) ->String {
        let sql = "SELECT display_name FROM vdr_mstr WHERE vdr_id = ?"
        var vdrName:String = "null"
        let vdrId = getVdrIdByLocationId(locationId)
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsIn: [vdrId]) {
            
                if rs.next() {
                    vdrName = rs.string(forColumnIndex: 0)
                }
            }
            
            db.close()
        }
        
        return vdrName
    }
    
    func getVdrLocationById(_ locationId:Int) ->String {
        let sql = "SELECT location_name FROM vdr_location_mstr WHERE location_id = ?"
        var vdrLocation:String = "null"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [locationId]) {
            
                if rs.next() {
                    vdrLocation = rs.string(forColumnIndex: 0)
                }
            }
            
            db.close()
        }
        
        return vdrLocation
    }
    
    func getVdrLocationCodeById(_ locationId:Int) ->String {
        let sql = "SELECT location_code FROM vdr_location_mstr WHERE location_id = ?"
        var vdrLocationCode:String = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [locationId]) {
                
                if rs.next() {
                    vdrLocationCode = rs.string(forColumnIndex: 0)
                }
            }
            
            db.close()
        }
        
        return vdrLocationCode
    }
    
    func getVdrLocationIdByName(_ vdrLocName:String) ->Int {
        let sql = "SELECT location_id FROM vdr_location_mstr WHERE location_name = ?"
        var vdrLocId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [vdrLocName]) {
                
                if rs.next() {
                    vdrLocId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return vdrLocId
    }
    
    func getVdrLocationIdByCode(_ vdrLocCode:String) ->Int {
        let sql = "SELECT location_id FROM vdr_location_mstr WHERE location_code = ?"
        var vdrLocId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [vdrLocCode]) {
                
                if rs.next() {
                    vdrLocId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return vdrLocId
    }
    
    func getVdrIdByLocationId(_ locationId:Int) ->Int {
        let sql = "SELECT vdr_id FROM vdr_location_mstr WHERE location_id = ?"
        var vdrId:Int = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [locationId]) {
            
                if rs.next() {
                    vdrId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return vdrId
    }
    
    func getBrandIdByLocationId(_ locationId:Int) ->Int {
        let sql = "SELECT brand_id FROM vdr_brand_map WHERE vdr_id = ?"
        var brandId:Int = 0
        let vdrId = getVdrIdByLocationId(locationId)
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [vdrId]) {
            
                if rs.next() {
                    brandId = Int(rs.int(forColumnIndex: 0))
                }
            }
            
            db.close()
        }
        
        return brandId
    }
    
    func getBrandNameByLocationId(_ locationId:Int) ->String {
        let sql = "SELECT brand_name FROM brand_mstr WHERE brand_id = ?"
        var brandName:String = ""
        let brandId = getBrandIdByLocationId(locationId)
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn: [brandId]) {
            
                if rs.next() {
                    brandName = rs.string(forColumnIndex: 0)
                }
            }
            
            db.close()
        }
        
        return brandName
    }
    
    func getVendorNameByvdrCode(_ vdrCode:Int) ->String {
        let sql = "SELECT display_name FROM vdr_mstr WHERE vdr_code = ?"
        var vendorName = ""

        if db.open() {

            if let rs = db.executeQuery(sql, withArgumentsIn: [vdrCode]) {

                if rs.next() {
                    vendorName = rs.string(forColumn: "vdr_code")
                }
            }
            
            db.close()
        }
        return vendorName
    }
    
    func getVendorLocationByvdrId(_ vdrId:Int) ->String {
        let sql = "SELECT location_name FROM vdr_location_mstr WHERE vdr_id = ?"

        var vendorLocation = ""
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsIn: [vdrId]) {
            
                if rs.next() {
                    vendorLocation = rs.string(forColumn: "vdr_id")
                }
            }
            
            db.close()
        }
        return vendorLocation
    }
    
    func getAllVendors() ->[Vendor]?{
        
        //let sql = "SELECT * FROM vdr_mstr WHERE data_env = 'LEATHER' ORDER BY display_name ASC"
        let sql = "SELECT DISTINCT vm.* FROM vdr_mstr vm INNER JOIN vdr_location_mstr vlm ON vm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id ORDER BY location_code ASC"
        
        var vendors = [Vendor]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:nil) {
            
            while rs.next() {
                
                let dataEnv = rs.string(forColumn: "data_env")
                let vdrId = rs.string(forColumn: "vdr_id")
                let vdrCode = rs.string(forColumn: "vdr_code")
                let vdrName = rs.string(forColumn: "vdr_name")
                let displayName = rs.string(forColumn: "display_name")
                let contactAddr = rs.string(forColumn: "contact_addr")
                let contactPerson = rs.string(forColumn: "contact_person")
                let contactPhone = rs.string(forColumn: "contact_phone")
                let contactEmail = rs.string(forColumn: "contact_email")
                let recStatus = rs.string(forColumn: "rec_status")
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = rs.string(forColumn: "deleted_flag")
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                let vendor = Vendor(dataEnv: dataEnv, vdrId: vdrId, vdrCode: vdrCode, vdrName: vdrName, displayName: displayName, contactAddr: contactAddr, contactPerson: contactPerson, contactPhone: contactPhone, contactEmail: contactEmail, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                vendors.append(vendor)
            }
            }
            
            db.close()
        }
        return vendors
    }
    
    func getAllVdrLocs() ->[VdrLoc]? {
        
        //let sql = "SELECT * FROM vdr_location_mstr WHERE data_env = 'LEATHER' ORDER BY location_code ASC"
        let sql = "SELECT DISTINCT vlm.* FROM vdr_location_mstr vlm INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id ORDER BY location_code ASC"
        
        var vdrLocs = [VdrLoc]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:nil) {
            
            while rs.next() {
                
                let dataEnv = rs.string(forColumn: "data_env")
                let locationId = rs.string(forColumn: "location_id")
                let vdrId = rs.string(forColumn: "vdr_id")
                let locationCode = rs.string(forColumn: "location_code")
                let locationName = rs.string(forColumn: "location_name")
                let recStatus = rs.string(forColumn: "rec_status")
                let createUser = rs.string(forColumn: "create_user")
                let createDate = rs.string(forColumn: "create_date")
                let modifyUser = rs.string(forColumn: "modify_user")
                let modifyDate = rs.string(forColumn: "modify_date")
                let deletedFlag = rs.string(forColumn: "deleted_flag")
                
                let deleteUser = rs.string(forColumn: "delete_user")
                let deleteDate = rs.string(forColumn: "delete_date")
                
                let vdrLoc = VdrLoc(dataEnv: dataEnv, locationId: locationId, vdrId: vdrId, locationCode: locationCode, locationName: locationName,recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                vdrLocs.append(vdrLoc)
                
            }
            }
            
            db.close()
        }
        return vdrLocs
    }
    
    func getAllVendorsFromPOSearch() ->[Vendor]?{
        
        let sql = "SELECT * FROM vdr_mstr vm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_id = vm.vdr_id AND fli.outstand_qty > 0 AND fli.line_status <> 5) ORDER BY display_name ASC"
        
        var vendors = [Vendor]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:nil) {
                
                while rs.next() {
                    
                    let dataEnv = rs.string(forColumn: "data_env")
                    let vdrId = rs.string(forColumn: "vdr_id")
                    let vdrCode = rs.string(forColumn: "vdr_code")
                    let vdrName = rs.string(forColumn: "vdr_name")
                    let displayName = rs.string(forColumn: "display_name")
                    let contactAddr = rs.string(forColumn: "contact_addr")
                    let contactPerson = rs.string(forColumn: "contact_person")
                    let contactPhone = rs.string(forColumn: "contact_phone")
                    let contactEmail = rs.string(forColumn: "contact_email")
                    let recStatus = rs.string(forColumn: "rec_status")
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let deletedFlag = rs.string(forColumn: "deleted_flag")
                    let deleteUser = rs.string(forColumn: "delete_user")
                    let deleteDate = rs.string(forColumn: "delete_date")
                    
                    let vendor = Vendor(dataEnv: dataEnv, vdrId: vdrId, vdrCode: vdrCode, vdrName: vdrName, displayName: displayName, contactAddr: contactAddr, contactPerson: contactPerson, contactPhone: contactPhone, contactEmail: contactEmail, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    vendors.append(vendor)
                }
            }
            
            db.close()
        }
        return vendors
    }
    
    func getAllVdrLocsFromPOSearch() ->[VdrLoc]? {
        
        let sql = "SELECT * FROM vdr_location_mstr vlm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_location_id = vlm.location_id AND fli.outstand_qty > 0 AND fli.line_status <> 5) ORDER BY location_code ASC"
        
        var vdrLocs = [VdrLoc]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:nil) {
                
                while rs.next() {
                    
                    let dataEnv = rs.string(forColumn: "data_env")
                    let locationId = rs.string(forColumn: "location_id")
                    let vdrId = rs.string(forColumn: "vdr_id")
                    let locationCode = rs.string(forColumn: "location_code")
                    let locationName = rs.string(forColumn: "location_name")
                    let recStatus = rs.string(forColumn: "rec_status")
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let deletedFlag = rs.string(forColumn: "deleted_flag")
                    
                    let deleteUser = rs.string(forColumn: "delete_user")
                    let deleteDate = rs.string(forColumn: "delete_date")
                    
                    let vdrLoc = VdrLoc(dataEnv: dataEnv, locationId: locationId, vdrId: vdrId, locationCode: locationCode, locationName: locationName,recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    vdrLocs.append(vdrLoc)
                    
                }
            }
            
            db.close()
        }
        return vdrLocs
    }
    
    func getAllVendorsFromTaskSearch() ->[Vendor]?{
        
        //let sql = "SELECT * FROM vdr_mstr vm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_id = vm.vdr_id) ORDER BY display_name ASC"
        let sql = "SELECT DISTINCT vm.* FROM inspect_task it INNER JOIN vdr_location_mstr vlm ON it.vdr_location_id = vlm.location_id INNER JOIN vdr_mstr vm ON vlm.vdr_id=vm.vdr_id WHERE it.vdr_location_id = vlm.location_id ORDER BY display_name ASC"
        
        var vendors = [Vendor]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:nil) {
                
                while rs.next() {
                    
                    let dataEnv = rs.string(forColumn: "data_env")
                    let vdrId = rs.string(forColumn: "vdr_id")
                    let vdrCode = rs.string(forColumn: "vdr_code")
                    let vdrName = rs.string(forColumn: "vdr_name")
                    let displayName = rs.string(forColumn: "display_name")
                    let contactAddr = rs.string(forColumn: "contact_addr")
                    let contactPerson = rs.string(forColumn: "contact_person")
                    let contactPhone = rs.string(forColumn: "contact_phone")
                    let contactEmail = rs.string(forColumn: "contact_email")
                    let recStatus = rs.string(forColumn: "rec_status")
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let deletedFlag = rs.string(forColumn: "deleted_flag")
                    let deleteUser = rs.string(forColumn: "delete_user")
                    let deleteDate = rs.string(forColumn: "delete_date")
                    
                    let vendor = Vendor(dataEnv: dataEnv, vdrId: vdrId, vdrCode: vdrCode, vdrName: vdrName, displayName: displayName, contactAddr: contactAddr, contactPerson: contactPerson, contactPhone: contactPhone, contactEmail: contactEmail, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    vendors.append(vendor)
                }
            }
            
            db.close()
        }
        return vendors
    }
    
    func getAllVdrLocsFromTaskSearch() ->[VdrLoc]? {
        
        //let sql = "SELECT * FROM vdr_location_mstr vlm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_location_id = vlm.location_id) ORDER BY location_code ASC"
        let sql = "SELECT DISTINCT vlm.* FROM inspect_task it INNER JOIN vdr_location_mstr vlm ON it.vdr_location_id = vlm.location_id ORDER BY location_code ASC"
        
        var vdrLocs = [VdrLoc]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:nil) {
                
                while rs.next() {
                    
                    let dataEnv = rs.string(forColumn: "data_env")
                    let locationId = rs.string(forColumn: "location_id")
                    let vdrId = rs.string(forColumn: "vdr_id")
                    let locationCode = rs.string(forColumn: "location_code")
                    let locationName = rs.string(forColumn: "location_name")
                    let recStatus = rs.string(forColumn: "rec_status")
                    let createUser = rs.string(forColumn: "create_user")
                    let createDate = rs.string(forColumn: "create_date")
                    let modifyUser = rs.string(forColumn: "modify_user")
                    let modifyDate = rs.string(forColumn: "modify_date")
                    let deletedFlag = rs.string(forColumn: "deleted_flag")
                    
                    let deleteUser = rs.string(forColumn: "delete_user")
                    let deleteDate = rs.string(forColumn: "delete_date")
                    
                    let vdrLoc = VdrLoc(dataEnv: dataEnv, locationId: locationId, vdrId: vdrId, locationCode: locationCode, locationName: locationName,recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    vdrLocs.append(vdrLoc)
                    
                }
            }
            
            db.close()
        }
        return vdrLocs
    }
    
    func getAllVendors(_ inputValue:String) ->[String] {
        //let sql = "SELECT DISTINCT(display_name) FROM vdr_mstr WHERE display_name LIKE ?"
        //let sql = "SELECT DISTINCT vm.* FROM vdr_mstr vm INNER JOIN vdr_location_mstr vlm ON vm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE display_name LIKE ? ORDER BY location_code ASC"
        let sql = "SELECT DISTINCT vm.* FROM vdr_mstr vm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_id = vm.vdr_id) AND vm.display_name LIKE ? ORDER BY display_name ASC"
        
        var vdrs = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:["%"+inputValue+"%"]) {
                
                while rs.next() {
                    
                    let vdr = rs.string(forColumn: "display_name")
                    
                    vdrs.append(vdr!)
                    
                }
            }
            
            db.close()
        }
        return vdrs
    }
    
    func getAllVendorKeyValues(_ inputValue:String) ->[String: Int] {
        let sql = "SELECT DISTINCT vm.* FROM vdr_mstr vm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_id = vm.vdr_id) AND vm.display_name LIKE ? ORDER BY display_name ASC"
        
        var vdrs = [String: Int]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:["%"+inputValue+"%"]) {
                
                while rs.next() {
                    
                    if let vdr = rs.string(forColumn: "display_name"), let vdrId = Int(rs.string(forColumn: "vdr_id")) {
                        vdrs[vdr] = vdrId
                    }
                }
            }
            
            db.close()
        }
        return vdrs
    }
    
    func getAllVendorLocs(_ inputValue:String) ->[String] {
        //let sql = "SELECT DISTINCT(location_code) FROM vdr_location_mstr WHERE location_code LIKE ?"
        //let sql = "SELECT DISTINCT vlm.* FROM vdr_location_mstr vlm INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE location_code LIKE ? ORDER BY location_code ASC"
        let sql = "SELECT DISTINCT vlm.* FROM vdr_location_mstr vlm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_location_id = vlm.location_id) AND location_code LIKE ? ORDER BY location_code ASC"

        var vdrLocs = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsIn:["%"+inputValue+"%"]) {
                
                while rs.next() {
                    
                    let vdrLoc = rs.string(forColumn: "location_code")
                    
                    vdrLocs.append(vdrLoc!)
                    
                }
            }
            
            db.close()
        }
        return vdrLocs
    }
}
