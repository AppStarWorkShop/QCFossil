//
//  TaskTableViewCell.swift
//  QCFossil
//
//  Created by Yin Huang on 17/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingDateText: UILabel!
    @IBOutlet weak var bookingNoLabel: UILabel!
    @IBOutlet weak var bookingNoText: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var taskStatusText: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorLabelText: UILabel!
    @IBOutlet weak var vendorLocationLabel: UILabel!
    @IBOutlet weak var vendorLocationText: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandText: UILabel!
    @IBOutlet weak var poListLabel: UILabel!
    @IBOutlet weak var poListText: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleText: UILabel!
    @IBOutlet weak var inspectionTypeLabel: UILabel!
    @IBOutlet weak var inspectionTypeText: UILabel!
    @IBOutlet weak var showAllPOLines: UIButton!
    @IBOutlet weak var eshipWinLabel: UILabel!
    @IBOutlet weak var shipWinText: UILabel!
    @IBOutlet weak var taskDeleteBtn: UIButton!
    @IBOutlet weak var showAllPOLines2: UIButton!
    @IBOutlet weak var showAllShipWinDates: UIButton!
    @IBOutlet weak var showAllshipWinDatesLabel: UILabel!
    @IBOutlet weak var taskStatusDescLabel: UILabel!
    @IBOutlet weak var showTaskStatusDesc: UIButton!
    @IBOutlet weak var showProdDesc: UIButton!
    @IBOutlet weak var showOpdRsd: UIButton!
    
    weak var parentTaskSearchVC:TaskSearchViewController?
    var dataRefuseDesc = ""
    var prodDesc = ""
    var opdRsd = ""
    var taskId:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func didMoveToSuperview() {
        if parentVC == nil {
            return
        }
        
        //add code here...
        updateLocalizedString()
    }
    
    func updateLocalizedString(){
        self.bookingDateLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect/Book Date")
        self.bookingNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect/Book No.")
        self.taskStatusLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status")
        self.vendorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor")
        self.vendorLocationLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD")//MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location")
        self.brandLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.poListLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO List/Material")
        self.styleLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
        self.inspectionTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Type")
        self.eshipWinLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Earliest Ship Win")
        self.shipWinText.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SW/Req. Ex-fty Date")
        
        self.setButtonCornerRadius(self.showAllPOLines)
        self.taskStatusDescLabel.layer.masksToBounds = true
        self.taskStatusDescLabel.layer.cornerRadius = 5
        self.taskDeleteBtn.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    @IBAction func showAllPOLinesOnClick(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//        popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
        popoverContent.dataType = _POPOVERPOITEMTYPE
        popoverContent.selectedValue = poListText.text!//"hello world,new world,"
        
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

    @IBAction func showAllShipWinDatesOnClick(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//        popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
        popoverContent.dataType = _POPOVERPOITEMTYPESHIPWIN
        popoverContent.selectedValue = shipWinText.text!
        
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
    
    
    
    @IBAction func taskDeleteButton(_ sender: UIButton) {
        
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Task?"),parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
            
            let taskDataHelper = TaskDataHelper()
            if taskDataHelper.deleteTaskById(self.taskId) {
                self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Deleted!"))
                
                if self.parentTaskSearchVC?.taskSet.count>0 {
                    for idx in 0...self.parentTaskSearchVC!.taskSet.count {
                        if self.parentTaskSearchVC?.taskSet[idx].taskId == self.taskId {
                            self.parentTaskSearchVC?.taskSet.remove(at: idx)
                            break
                        }
                    }
                
                    for idx in 0...self.parentTaskSearchVC!.tasks.count {
                        if self.parentTaskSearchVC?.tasks[idx].taskId == self.taskId {
                            self.parentTaskSearchVC?.tasks.remove(at: idx)
                            break
                        }
                    }
                    Cache_Task_On = nil
                    self.parentTaskSearchVC?.taskItemTableView.reloadData()
                    
                    //clear all relative files
                    self.clearAllFilesTaskImages(self.bookingNoText.text!)
                }
                
            }else{
                self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Delete Fail!"))
            }
        })
    }
    
    @IBAction func showTaskStatusDescOnClick(_ sender: UIButton) {
        
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//        popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
        popoverContent.dataType = _POPOVERTASKSTATUSDESC
        popoverContent.selectedValue = dataRefuseDesc//(Cache_Task_On?.dataRefuseDesc)!
        
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
    
    @IBAction func showProdDescOnClick(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//        popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
        popoverContent.dataType = _POPOVERPRODDESC
        popoverContent.selectedValue = prodDesc
        
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
    
    @IBAction func showOpdRsdOnClick(_ sender: UIButton) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//        popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
        popoverContent.dataType = _POPOVERPOPDRSD
        popoverContent.selectedValue = vendorLocationText.text!
        
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
    
    func clearAllFilesTaskImages(_ taskFderName:String){
        /*let fileManager = NSFileManager.defaultManager()
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        */
        let filemgr = FileManager.default
        //let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        //print("path: \(dirPaths)")
        //let dbDir = dirPaths[0] as String

        //let taskFilePath = dbDir.stringByAppendingString("/\(taskFderName)")
        let taskFilePath = _TASKSPHYSICALPATH+"\(taskFderName)"
        let taskThumbFilePath = taskFilePath+"/Thumbs"
        do {
            
            let fileNames = try filemgr.contentsOfDirectory(atPath: "\(taskFilePath)")
            print("all files in cache: \(fileNames)")
            for fileName in fileNames {
                    
                if (fileName.hasSuffix(".jpg"))
                {
                    let filePathName = "\(taskFilePath)/\(fileName)"
                    try filemgr.removeItem(atPath: filePathName)
                }
            }
                
            let fileThumbs = try filemgr.contentsOfDirectory(atPath: "\(taskThumbFilePath)")
            for fileName in fileThumbs {
                
                if (fileName.hasSuffix(".jpg"))
                {
                    let filePathName = "\(taskThumbFilePath)/\(fileName)"
                    try filemgr.removeItem(atPath: filePathName)
                }
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}
