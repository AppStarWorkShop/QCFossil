//
//  TaskDetailsViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 14/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class TaskDetailsViewController: PopoverMaster, UIScrollViewDelegate {

    var ScrollView = UIScrollView()
    var categories = [InptCategoryCell]()
    var categoriesDetail = [InputModeSCMaster]()
    var displaySubViewTag = _TASKDETAILVIEWTAG
    var inspCatAdded = false
    var scrollViewOffset:CGFloat = 0
    var backBtnText = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
    var inspCatText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let parentVC = self.parent as? TabBarViewController {
            parentVC.taskDetalViewContorller = self
        }
         
        // Do any additional setup after loading the view.
        ScrollView.translatesAutoresizingMaskIntoConstraints = false
        ScrollView.contentSize = CGSize.init(width: _DEVICE_WIDTH, height: _DEVICE_HEIGHT)
        ScrollView.delegate = self
        
        self.view.addSubview(self.ScrollView)
        
        initTask()
        
        NSLayoutConstraint.activate([
            ScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            ScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.self.parent?.view.removeActivityIndicator()
        })
        
        self.view.disableAllFunsForView(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshCameraIcon()
        self.tabBarItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
        if displaySubViewTag == _TASKINSPCATVIEWTAG {
            self.updateNaviBarMenu(backBtnText, leftBarActionName: "backToTaskDetail", rightBarTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), rightBarActionName: "updateTask:")
        }else {
            self.updateNaviBarMenu(rightBarTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), rightBarActionName: "updateTask:")
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":true])
    }
    
    func updateNaviBarMenu(_ leftBarTitle:String = "Task Search", leftBarActionName:String = "backTaskSearch:", rightBarTitle:String, rightBarActionName:String) {
        if let myParentTabVC = self.parent as? TabBarViewController {
        
        if leftBarTitle == "Task Search" {
            //myParentTabVC.navigationItem.leftBarButtonItem = myParentTabVC.navigationItem.backBarButtonItem
            myParentTabVC.setLeftBarItem("< \(MylocalizedString.sharedLocalizeManager.getLocalizedString(leftBarTitle))",actionName: leftBarActionName)
            myParentTabVC.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
        }else {
            myParentTabVC.setLeftBarItem("< "+leftBarTitle,actionName: leftBarActionName)
            myParentTabVC.navigationItem.title = inspCatText
        }
        
        if !self.view.disableFuns(self.view) {
            myParentTabVC.setRightBarItem(rightBarTitle, actionName: rightBarActionName)
        }
        }
    }
    
    func updateNavigationTitle(title: String) {
        if let myParentTabVC = self.parent as? TabBarViewController {
            myParentTabVC.navigationItem.title = title
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CreateTaskSegueFromTaskForm" {
            
            if let destVC = segue.destination.children.first as? POSearchViewController {
                destVC.pVC = self

                let taskDetailView = self.view.viewWithTag(_TASKDETAILVIEWTAG) as! TaskDetailViewInput
                destVC.vendorName = taskDetailView.vendorInput.text!
                destVC.vendorLocCode = taskDetailView.vendorLocInput.text!

                if taskDetailView.poItems.count > 0 {
                    let poItem = taskDetailView.poItems[0]
                    destVC.styleNo = poItem.styleNo!

                    destVC.poSelectedItems = taskDetailView.poItems
                }
            }
        }else if segue.identifier == "DefectListFromInspectItemSegue" {
            
            let destVC = segue.destination as! InspectionDefectList
            let inspectionItem = sender as! InputModeICMaster
            
            destVC.inspItem = inspectionItem
        }
        
    }
    
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        NSLog("Toggle Menu in Scroll-Container")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
    }

    @IBAction func startTaskMenuButton(_ sender: UIBarButtonItem) {
        //let ScreenVC = ICScreenOneViewController()
        //self.presentViewController(ScreenVC, animated: true, completion: nil)
        //self.performSegueWithIdentifier("InptCategoryDetailSegue", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewOffset = scrollView.contentOffset.y
    }
    
    func scrollToPosition(_ offset:CGFloat) {
        self.ScrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
    }
    
    func initTask(){
        DispatchQueue.main.async(execute: {
            self.view.showActivityIndicator()
            
            DispatchQueue.main.async(execute: {
                //Retriving Task Data
                let taskDataHelper = TaskDataHelper()
                Cache_Task_On = taskDataHelper.getTaskDetailByTask(Cache_Task_On!)
                
                //Default keep task status Pending for Pending Tasks
                if Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Pending").rawValue {
                    Cache_Task_On?.didKeepPending = true
                }
                
                Cache_Task_On?.didModify = false
                
                //update Inspection Date & No
                if Cache_Task_On?.inspectionNo == "" && Cache_Task_On?.inspectionDate == "" {
                    taskDataHelper.updateTaskInspectionDate((Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectionDate: self.view.getCurrentDateTime(), taskId: (Cache_Task_On?.taskId)!)
                }
                
                if Cache_Task_On!.inspSections.count > 0 {
                    self.view.createTaskFolderById((Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!)
                    Cache_Task_Path = _TASKSPHYSICALPATH + (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!
                    Cache_Thumb_Path = Cache_Task_Path!+"/"+_THUMBSPHYSICALNAME
                }else{
                    print("No Inspection Category In Selected Task!")
                    self.navigationController!.popViewController(animated: true)
                }
                
                //Init sub view TaskDetail
                let taskDetailView = TaskDetailViewInput.loadFromNibNamed("TaskDetailView")!
                taskDetailView.pVC = self
                taskDetailView.tag = _TASKDETAILVIEWTAG
                
                self.ScrollView.addSubview(taskDetailView)
                self.ScrollView.translatesAutoresizingMaskIntoConstraints = false
                taskDetailView.translatesAutoresizingMaskIntoConstraints = false
                
                let paddingBottom = self.ScrollView.contentSize.height - _DEVICE_HEIGHT
                NSLayoutConstraint.activate([
                    taskDetailView.topAnchor.constraint(equalTo: self.ScrollView.topAnchor, constant: -40),
                    taskDetailView.heightAnchor.constraint(equalTo: self.ScrollView.heightAnchor, constant: paddingBottom > 0 ? paddingBottom : 0),
                    taskDetailView.widthAnchor.constraint(equalTo: self.ScrollView.widthAnchor),
                ])
                
                
                self.view.removeActivityIndicator()
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadAllPhotosFromDB"), object: nil, userInfo: nil)
            })
        })
    }
    
    func startTask(_ currentPage:Int = 0) {
        
        if !inspCatAdded {
            DispatchQueue.main.async(execute: {
                self.view.showActivityIndicator()
                
                DispatchQueue.main.async(execute: {
                    self.view.removeActivityIndicator()
                    
                    if let inspectionView = InspectionViewInput.loadFromNibNamed("InspectionView") {
                        inspectionView.tag = _TASKINSPCATVIEWTAG
                        inspectionView.pVC = self
                        inspectionView.currentPage = currentPage
                        self.ScrollView.addSubview(inspectionView)
                        self.inspCatAdded = true
                    }
                    self.updateNaviBarMenu(self.backBtnText, leftBarActionName: "backToTaskDetail", rightBarTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), rightBarActionName: "updateTask:")
                    
                    self.ScrollView.contentOffset.y = 0
                    
                    self.scrollToPosition(0)
                    
                    self.displaySubViewTag = _TASKINSPCATVIEWTAG
                    
                    self.ScrollView.isScrollEnabled = false
                })
            })
            
        }else{
            
            if let inspectionView = self.ScrollView.viewWithTag(_TASKINSPCATVIEWTAG) {
                
                DispatchQueue.main.async(execute: {
                    self.view.showActivityIndicator()
                    
                    DispatchQueue.main.async(execute: {
                        self.view.removeActivityIndicator()
                
                        (inspectionView as! InspectionViewInput).updateSectionHeader(currentPage)
                        (inspectionView as! InspectionViewInput).scrollToPosition(currentPage, animation: false)
                
                        self.ScrollView.bringSubviewToFront(self.ScrollView.viewWithTag(_TASKINSPCATVIEWTAG)!)
                
                        self.updateNaviBarMenu(self.backBtnText, leftBarActionName: "backToTaskDetail", rightBarTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), rightBarActionName: "updateTask:")
                
                        self.scrollToPosition(0)
                
                        self.displaySubViewTag = _TASKINSPCATVIEWTAG
                
                        self.ScrollView.isScrollEnabled = false
                    })
                })
            }
        }
    }
    
    func refreshSummaryResult() {
        if let tastDetailView = view.viewWithTag(_TASKDETAILVIEWTAG) {
            let inspCatView = (tastDetailView as! TaskDetailViewInput).inptCatWrapperView
            
            inspCatView?.subviews.forEach({
                if $0.classForCoder == InptCategoryCell.classForCoder() {
                    let icSecs = self.categoriesDetail
                    var itemsCount = 0
                    let inspectionCategoryCell = $0 as? InptCategoryCell
                    
                    for icSec in icSecs {
                        
                        if inspectionCategoryCell?.sectionId == icSec.categoryIdx {
                            let resultSetValues = ($0 as! InptCategoryCell).resultSetValues
                            for resultSetValue in resultSetValues{
                                resultSetValue.clear()
                            }

                            switch icSec.InputMode {
                            case _INPUTMODE01:
                                let inputCells = (icSec as! InputMode01View).inputCells
                                
                                for inputCell in inputCells {
                                    itemsCount += 1
                                    for resultSetValue in resultSetValues{
                                        if resultSetValue.valueName.lowercased().range(of: (inputCell.cellResultInput.text?.lowercased())!) != nil {
                                            resultSetValue.resultCount += 1
                                            break
                                        }
                                    }
                                }
                            case _INPUTMODE02:
                                let inputCells = (icSec as! InputMode02View).inputCells
                                
                                for inputCell in inputCells {
                                    itemsCount += 1
                                    for resultSetValue in resultSetValues{
                                        if resultSetValue.valueName.lowercased().range(of: (inputCell.cellResultInput.text?.lowercased())!) != nil {
                                            resultSetValue.resultCount += 1
                                            break
                                        }
                                    }
                                }
                            case _INPUTMODE03:
                                let inputCells = (icSec as! InputMode03View).inputCells
                                
                                for inputCell in inputCells {
                                    itemsCount += 1
                                    for resultSetValue in resultSetValues{
                                        if resultSetValue.valueName.lowercased().range(of: (inputCell.cellResultInput.text?.lowercased())!) != nil {
                                            resultSetValue.resultCount += 1
                                            break
                                        }
                                    }
                                }
                            case _INPUTMODE04:
                                let inputCells = (icSec as! InputMode04View).inputCells
                                
                                for inputCell in inputCells {
                                    itemsCount += 1
                                    for resultSetValue in resultSetValues{
                                        if resultSetValue.valueName.lowercased().range(of: (inputCell.subResultInput.text?.lowercased())!) != nil {
                                            resultSetValue.resultCount += 1
                                            break
                                        }
                                    }
                                }
                            default:break
                            }
                            
                            inspectionCategoryCell?.updateSummaryResultValues(resultSetValues)
                            let title = MylocalizedString.sharedLocalizeManager.getLocalizedString(stringDic: [.en: icSec.inspSection!.sectionNameEn, .zh: icSec.inspSection!.sectionNameCn, .fr: icSec.inspSection!.sectionNameFr])
                            inspectionCategoryCell?.inptCatButton.setTitle(title+"(\(itemsCount))", for: UIControl.State())
                        }
                    }
                }
            })
        }
    }
    
    func refreshCameraIcon() {
        if (view.viewWithTag(_TASKDETAILVIEWTAG) != nil) {
            let photoDataHelper = PhotoDataHelper()
            let icSecs = self.categoriesDetail
            
            for icSec in icSecs {
                switch icSec.InputMode {
                    case _INPUTMODE01:
                        let inputCells = (icSec as! InputMode01View).inputCells
                        
                        for inputCell in inputCells {
                            
                            if photoDataHelper.existPhotoByInspItem(inputCell.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || inputCell.inspPhotos.count>0 {
                                
                                if let image = UIImage(named: "taken_photo_icon") {
                                    inputCell.takePhotoIcon.setImage(image, for: UIControl.State())
                                }
                            }else{
                                if let image = UIImage(named: "take_photo") {
                                    inputCell.takePhotoIcon.setImage(image, for: UIControl.State())
                                }
                            }
                        }

                    case _INPUTMODE02:
                        let inputCells = (icSec as! InputMode02View).inputCells
                        
                        for inputCell in inputCells {
                            
                            if photoDataHelper.existPhotoByInspItem(inputCell.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || inputCell.inspPhotos.count>0 {
                                
                                if let image = UIImage(named: "taken_photo_icon") {
                                    inputCell.takePhotoIcon.setImage(image, for: UIControl.State())
                                }
                            }else{
                                if let image = UIImage(named: "take_photo") {
                                    inputCell.takePhotoIcon.setImage(image, for: UIControl.State())
                                }
                            }
                        }
                    
                    case _INPUTMODE03:
                        let inputCells = (icSec as! InputMode03View).inputCells
                        
                        for inputCell in inputCells {
                            
                            if photoDataHelper.existPhotoByInspItem(inputCell.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || inputCell.inspPhotos.count>0 {
                                
                                if let image = UIImage(named: "taken_photo_icon") {
                                    inputCell.takePhotoIcon.setImage(image, for: UIControl.State())
                                }
                            }else{
                                if let image = UIImage(named: "take_photo") {
                                    inputCell.takePhotoIcon.setImage(image, for: UIControl.State())
                                }
                            }
                        }
                    
                    case _INPUTMODE04:
                        let inputCells = (icSec as! InputMode04View).inputCells
                                
                        for inputCell in inputCells {
                            
                            if photoDataHelper.existPhotoByInspItem(inputCell.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || inputCell.inspPhotos.count>0 {
                                    
                                if let image = UIImage(named: "taken_photo_icon") {
                                    inputCell.takePhotoIcon.setImage(image, for: UIControl.State())
                                }
                            }else{
                                if let image = UIImage(named: "take_photo") {
                                    inputCell.takePhotoIcon.setImage(image, for: UIControl.State())
                                }
                            }
                        }
                                
                    default:break
                }
                            
            }
        }
    }
    
}
