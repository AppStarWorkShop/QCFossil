//
//  TaskSearchViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 16/12/15.
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


class TaskSearchViewController: PopoverMaster, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var taskItemTableView: UITableView!
    @IBOutlet weak var taskHeaderSegment: UISegmentedControl!
    @IBOutlet weak var bookingDateFromLabel: UILabel!
    @IBOutlet weak var bookingDateFromInput: UITextField!
    @IBOutlet weak var bookingDateToLabel: UILabel!
    @IBOutlet weak var bookingDateToInput: UITextField!
    @IBOutlet weak var bookingNoLabel: UILabel!
    @IBOutlet weak var bookingNoInput: UITextField!
    @IBOutlet weak var inspTypeLabel: UILabel!
    @IBOutlet weak var inspTypeInput: UITextField!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleInput: UITextField!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandInput: UITextField!
    @IBOutlet weak var poNoLabel: UILabel!
    @IBOutlet weak var poNoInput: UITextField!
    @IBOutlet weak var shipWinFromLabel: UILabel!
    @IBOutlet weak var shipWinFromInput: UITextField!
    @IBOutlet weak var shipWinToLabel: UILabel!
    @IBOutlet weak var shipWinToInput: UITextField!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorInput: UITextField!
    @IBOutlet weak var vendorLocationLabel: UILabel!
    @IBOutlet weak var vendorLocationInput: UITextField!
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var draftLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var uploadedLabel: UILabel!
    @IBOutlet weak var refuseLabel: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var canceledLabel: UILabel!
    @IBOutlet weak var reviewedLabel: UILabel!
    @IBOutlet weak var opdRsdFromLabel: UILabel!
    @IBOutlet weak var opdRsdFromInput: UITextField!
    @IBOutlet weak var opdRsdToLabel: UILabel!
    @IBOutlet weak var opdRsdToInput: UITextField!
    
    var taskItems = [TaskItem]()
    var taskSet = [Task]()
    var tasks = [Task]()
    var vendors = [Vendor]()
    var vendorLocs = [VdrLoc]()
    var brands = [Brand]()
    var pendingSwitch = true
    var draftSwitch = true
    var confirmedSwitch = true
    var uploadedSwitch = false
    var refuseSwitch = false
    var canceledSwitch = false
    var reviewedSwitch = false
    var showListData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //loadSampleTasks()
        NSLog("Task Search Page Did Load")
        
        initData()
        
        taskItemTableView.delegate = self
        taskItemTableView.dataSource = self
        
        bookingDateFromInput.delegate = self
        bookingDateToInput.delegate = self
        shipWinFromInput.delegate = self
        shipWinToInput.delegate = self
        opdRsdFromInput.delegate = self
        opdRsdToInput.delegate = self
        styleInput.delegate = self
        vendorInput.delegate = self
        vendorLocationInput.delegate = self
        brandInput.delegate = self
        inspTypeInput.delegate = self
        poNoInput.delegate = self
        bookingNoInput.delegate = self
        
        self.view.setButtonCornerRadius(self.searchBtn)
        self.view.setButtonCornerRadius(self.clearBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TaskSearchViewController.reloadTaskSearchTableView), name: NSNotification.Name(rawValue: "reloadTaskSearchTableView"), object: nil)
    }
    
    func initData() {
        let taskDataHelper = TaskDataHelper()
        brands = taskDataHelper.getAllTaskBrands()
        taskItems = taskDataHelper.getAllTaskItems()!
        
        for taskItem in taskItems {
            if let task = taskDataHelper.getTaskById(taskItem.taskId!) {
                taskSet.append(task)
            }
        }
        
        tasks = taskSet
        
        tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Uploaded").rawValue })
        tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Reviewed").rawValue })
        tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Refused").rawValue })
        tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Cancelled").rawValue })
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        tasks.sort(){ (dateFormatter.date(from: $0.bookingDate! != "" ? $0.bookingDate! : $0.inspectionDate!)?.isGreaterThanDate(dateFormatter.date(from: $1.bookingDate! != "" ? $1.bookingDate! : $1.inspectionDate!)!))! }
        
        let vendorDataHelper = VendorDataHelper()
        vendors = vendorDataHelper.getAllVendorsFromTaskSearch()!
        vendorLocs = vendorDataHelper.getAllVdrLocsFromTaskSearch()!
        
        updateLocalizedString()
    }
    
    @objc func reloadTaskSearchTableView() {
        taskSet = [Task]()
        tasks = [Task]()
        brands = [Brand]()
        
        let taskDataHelper = TaskDataHelper()
        brands = taskDataHelper.getAllTaskBrands()
        taskItems = taskDataHelper.getAllTaskItems()!
        
        let vendorDataHelper = VendorDataHelper()
        vendors = vendorDataHelper.getAllVendorsFromTaskSearch()!
        vendorLocs = vendorDataHelper.getAllVdrLocsFromTaskSearch()!

        for taskItem in taskItems {
            if let task = taskDataHelper.getTaskById(taskItem.taskId!) {
                taskSet.append(task)
            }
        }
        
        tasks = taskSet
        
        if !self.pendingSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Pending").rawValue })
        }
        
        if !self.draftSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Draft").rawValue })
        }
        
        if !self.confirmedSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Confirmed").rawValue })
        }
        
        if !self.uploadedSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Uploaded").rawValue })
        }
        
        if !self.reviewedSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Reviewed").rawValue })
        }
        
        if !self.refuseSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Refused").rawValue })
        }
        
        if !self.canceledSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Cancelled").rawValue })
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        tasks.sort(){ (dateFormatter.date(from: $0.bookingDate! != "" ? $0.bookingDate! : $0.inspectionDate!)?.isGreaterThanDate(dateFormatter.date(from: $1.bookingDate! != "" ? $1.bookingDate! : $1.inspectionDate!)!))! }
        
        if (self.taskItemTableView != nil) {
            self.taskItemTableView.reloadData()
        }
    }
    
    func updateLocalizedString(){
        
        self.bookingDateFromLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Book/Inspect Date From")
        self.bookingDateToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("To")
        self.bookingNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Book/Inspect No.")
        self.inspTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Type")
        self.styleLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
        self.brandLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.poNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        self.shipWinFromLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship Win From")
        self.shipWinToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("To")
        self.vendorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor")
        self.vendorLocationLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location")
        self.taskStatusLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status")
        self.pendingLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Pending")
        self.draftLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Draft")
        self.confirmedLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirmed")
        self.uploadedLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Uploaded")
        self.refuseLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Refused")
        self.canceledLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancelled")
        self.reviewedLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Reviewed")
        self.searchBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Search"), for: UIControl.State())
        self.clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), for: UIControl.State())
        self.vendorInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor PlaceHolder")
        self.vendorLocationInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location PlaceHolder")
        self.opdRsdFromLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD From")
        self.opdRsdToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("To")
        
        let segmentTitles = [MylocalizedString.sharedLocalizeManager.getLocalizedString("Book Date"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Book No"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Status"),MylocalizedString.sharedLocalizeManager.getLocalizedString("PO"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Style"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship Win")]
        
        for idx in 0...self.taskHeaderSegment.numberOfSegments-1 {
            self.taskHeaderSegment.setTitle(segmentTitles[idx], forSegmentAt: idx)
        }
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Search")
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        self.navigationItem.rightBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Create Task")
        
        self.inspTypeInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Final/Material/In-line")
        self.bookingNoInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect/Book No.")
        self.poNoInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        self.styleInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
        self.brandInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.bookingDateFromInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.bookingDateToInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.shipWinFromInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.shipWinToInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.opdRsdFromInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.opdRsdToInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view!.isKind(of: UITextField().classForCoder) || String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.view.resignFirstResponderByTextField(self.view)
            
        }else {
            self.view.clearDropdownviewForSubviews(self.view)
            
        }
        
        return false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        
        if touch.view!.isKind(of: UITextField().classForCoder) || String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.view.resignFirstResponderByTextField(self.view)
            
        }else {
            self.view.clearDropdownviewForSubviews(self.view)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.taskItemTableView.reloadData()
        
        let taskOnArray = tasks.filter({$0.taskId == Cache_Task_On?.taskId})
        if taskOnArray.count>0 {
            let index = tasks.index(where: { (task) -> Bool in
                task.taskId == Cache_Task_On?.taskId
            })
            if let index = index {
                tasks[index] = Cache_Task_On!
                self.taskItemTableView.reloadData()
            }
        }
        
        let taskSetOnArray = taskSet.filter({$0.taskId == Cache_Task_On?.taskId})
        if taskSetOnArray.count>0 {
            let index = taskSet.index(where: { (task) -> Bool in
                task.taskId == Cache_Task_On?.taskId // test if this is the item you're looking for
            })
            if let index = index {
                taskSet[index] = Cache_Task_On!
            }
        }
        
        //Physical Delete Task if Need
        if Cache_Task_On?.deleteFlag == 1 {
            if Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue {
                self.view.deleteTask((Cache_Task_On?.taskId)!)
                self.reloadTaskSearchTableView()
                
            }else{
                self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete all invalid tasks?"), parentVC:self, handlerFun: { (action:UIAlertAction!) in
                
                    DispatchQueue.main.async(execute: {
                        self.view.showActivityIndicator("Deleting...")
                    
                        DispatchQueue.main.async(execute: {
                            let taskDataHelper = TaskDataHelper()
                            var invalidTaskIds = taskDataHelper.getAllInvalidTaskId()
                
                            while let id = invalidTaskIds.popLast() {
                                    self.view.deleteTask(id)
                            }
                        
                            Cache_Task_On = nil
                            self.view.removeActivityIndicator()
                            self.reloadTaskSearchTableView()
                        })
                    })
                
                })
            }
        }
        
        //NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
        //self.reloadTaskSearchTableView()
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Menu(_ sender: UIBarButtonItem) {
        NSLog("Toggle Menu")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
    }

    @IBAction func createTaskBarButton(_ sender: UIBarButtonItem) {
        NSLog("Create Task")
        
        self.performSegue(withIdentifier: "CreateTaskSegue", sender:self)
    }
    
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
    */
    
    func numberOfSections(in taskItemTableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 1
    }
    
    func tableView(_ taskItemTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return tasks.count
    }
    
    func tableView(_ taskItemTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskItemTableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        
        let task = tasks[indexPath.row] as Task
        
        cell.bookingDateText.text = task.bookingDate!.isEmpty ? task.inspectionDate : task.bookingDate
        cell.bookingNoText.text = task.bookingNo!.isEmpty ? task.inspectionNo : task.bookingNo
        
        if task.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && task.cancelDate != "" {
            cell.taskStatusText.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(String(describing: TaskStatus(caseId: task.taskStatus!)) + " (C)")
        }else{
            cell.taskStatusText.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(String(describing: TaskStatus(caseId: task.taskStatus!)))
        }
        
        var vendorLoc = ""
        if task.vendor != nil {
            vendorLoc = task.vendor!
        }
        
        if task.vendorLocation != nil {
            vendorLoc = "\(vendorLoc)(\(task.vendorLocation!))"
        }
        
        cell.vendorLabelText.text = vendorLoc
        cell.brandText.text = task.brand
        cell.styleText.text = task.style
        cell.poListText.text = task.poNo
        cell.inspectionTypeText.text = task.inspectionType
        cell.taskId = task.taskId!
        cell.dataRefuseDesc = task.dataRefuseDesc
        cell.parentTaskSearchVC = self
        
        if task.prodDesc != nil {
            cell.prodDesc = task.prodDesc!
        }else{
            cell.prodDesc = ""
        }
        
        if task.poNo?.range(of: ",") != nil {
            cell.showAllPOLines.isHidden = false
//            cell.showAllPOLines2.isHidden = false
        }else{
            cell.showAllPOLines.isHidden = true
//            cell.showAllPOLines2.isHidden = true
        }
        
        if task.shipWin?.range(of: ",") != nil {
            cell.showAllShipWinDates.isHidden = false
//            cell.showAllshipWinDatesLabel.isHidden = false
        }else{
            cell.showAllShipWinDates.isHidden = true
//            cell.showAllshipWinDatesLabel.isHidden = true
        }
        
        if task.opdRsd?.range(of: ",") != nil {
            cell.showOpdRsd.isHidden = false
        }else{
            cell.showOpdRsd.isHidden = true
        }
        
        if task.dataRefuseDesc == "" {
            cell.taskStatusDescLabel.isHidden = true
            cell.showTaskStatusDesc.isHidden = true
        }else{
            cell.taskStatusDescLabel.isHidden = false
            cell.showTaskStatusDesc.isHidden = false
        }
        
        cell.shipWinText.text = task.shipWin
        cell.vendorLocationText.text = task.opdRsd
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = _TABLECELL_BG_COLOR2
        }else{
            cell.backgroundColor = _TABLECELL_BG_COLOR1
        }
        
        if cell.taskId == Cache_Task_On?.taskId {
            self.taskItemTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Task Selected")
        
        Cache_Task_On = tasks[indexPath.row]
        
        // Clear pre save data
        if let taskId = Cache_Task_On?.taskId {
            let defectDataHelper = DefectDataHelper()
            defectDataHelper.deletePreSavedItemsFromInspectDataRecords(taskId)
            defectDataHelper.deletePreSavedItemsFromDefectDataRecords(taskId)
        }
        
        self.performSegue(withIdentifier: "TaskDetailAfterSearchSegue", sender:self)
    }
    
    @IBAction func taskHeaderSegmentClick(_ sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex
        
        sortBySegmentSelected(selectedSegment)
        
        self.taskItemTableView.reloadData()
    }
    
    func sortBySegmentSelected(_ selectedSegment:Int = 0) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        switch selectedSegment {
        case 0: tasks.sort(){ (dateFormatter.date(from: $0.bookingDate! != "" ? $0.bookingDate! : $0.inspectionDate!)?.isGreaterThanDate(dateFormatter.date(from: $1.bookingDate! != "" ? $1.bookingDate! : $1.inspectionDate!)!))! }; break
        case 1: tasks.sort(){ $0.bookingNo<$1.bookingNo && $0.sortingNum<$1.sortingNum  }; break
        //case 1: tasks.sortInPlace(){$0.bookingNo<$1.bookingNo}; break
        //case 2: tasks.sortInPlace(){$0.taskStatus<$1.taskStatus}; break
        case 2: tasks.sort(){String(describing: TaskStatus(caseId: $0.taskStatus!))<String(describing: TaskStatus(caseId: $1.taskStatus!))}; break
        case 3: tasks.sort(){$0.poNo<$1.poNo}; break
        case 4: tasks.sort(){$0.style<$1.style}; break
        case 5: tasks.sort(){$0.brand<$1.brand}; break
        case 6: tasks.sort(){ ($0.shipWin != nil && $1.shipWin != nil) ? sortByShipWin($0.shipWin!, shipWin2: $1.shipWin!) : $0.shipWin>$1.shipWin }; break
        default: tasks.sort(){ (dateFormatter.date(from: $0.bookingDate!)?.isGreaterThanDate(dateFormatter.date(from: $1.bookingDate!)!))! }; break
        }
    }
    
    func sortByShipWin(_ shipWin1:String, shipWin2:String) ->Bool {
        let shipWin1Array = shipWin1.characters.split{$0 == ","}.map(String.init)
        let shipWin2Array = shipWin2.characters.split{$0 == ","}.map(String.init)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        if shipWin1Array.count>0 && shipWin2Array.count>0 {
            
            if dateFormatter.date(from: shipWin1Array[0])!.isGreaterThanDate(dateFormatter.date(from: shipWin2Array[0])!) {
                
                return true
            }
        }
        
        return false
    }
    
    @IBAction func switchOnClick(_ sender: UISwitch) {
        switch sender.tag {
            case 1: if sender.isOn {self.pendingSwitch = true}else{self.pendingSwitch = false}
            case 2: if sender.isOn {self.draftSwitch = true}else{self.draftSwitch = false}
            case 3: if sender.isOn {self.confirmedSwitch = true}else{self.confirmedSwitch = false}
            case 4: if sender.isOn {self.uploadedSwitch = true}else{self.uploadedSwitch = false}
            case 5: if sender.isOn {self.refuseSwitch = true}else{self.refuseSwitch = false}
            case 6: if sender.isOn {self.canceledSwitch = true}else{self.canceledSwitch = false}
            case 7: if sender.isOn {self.reviewedSwitch = true}else{self.reviewedSwitch = false}
            default: break
        }
    }
    
    @IBAction func searchTaskOnClick(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.view.showActivityIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = _DATEFORMATTER
                
                let taskDataHelper = TaskDataHelper()
                self.taskItems = taskDataHelper.getAllTaskItems()!
                
                self.taskSet = [Task]()
                
                for taskItem in self.taskItems {
                    if let task = taskDataHelper.getTaskById(taskItem.taskId!) {
                        self.taskSet.append(task)
                    }
                }
                
                var tasksByFilter = self.taskSet
                
                //Filter By Booking Date
                let bookingDateFrom = dateFormatter.date(from: self.bookingDateFromInput.text!)
                let bookingDateTo = dateFormatter.date(from: self.bookingDateToInput.text!)
                
                if self.bookingDateFromInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ ($0.bookingDate != nil && $0.bookingDate != "") ? ((dateFormatter.date(from: $0.bookingDate!)!.equalToDate(bookingDateFrom!)) || (dateFormatter.date(from: $0.bookingDate!)!.isGreaterThanDate(bookingDateFrom!))) : ((dateFormatter.date(from: $0.inspectionDate!)!.equalToDate(bookingDateFrom!)) || (dateFormatter.date(from: $0.inspectionDate!)!.isGreaterThanDate(bookingDateFrom!))) })
                }
                
                if self.bookingDateToInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ ($0.bookingDate != nil && $0.bookingDate != "") ? ((dateFormatter.date(from: $0.bookingDate!)!.equalToDate(bookingDateTo!)) || (dateFormatter.date(from: $0.bookingDate!)!.isLessThanDate(bookingDateTo!))) : ((dateFormatter.date(from: $0.inspectionDate!)!.equalToDate(bookingDateTo!)) || (dateFormatter.date(from: $0.inspectionDate!)!.isLessThanDate(bookingDateTo!))) })
                }
                
                //Filter By Booking No.
                if self.bookingNoInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.bookingNo == nil || ($0.bookingNo?.lowercased().contains((self.bookingNoInput.text?.lowercased())!))! || ($0.inspectionNo?.lowercased().contains((self.bookingNoInput.text?.lowercased())!))! })
                }
                
                //Filter By InspType
                if self.inspTypeInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.inspectionType == nil || ($0.inspectionType?.lowercased().contains((self.inspTypeInput.text?.lowercased())!))! })
                }
                
                //Filter By Style
                if self.styleInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.style == nil || ($0.style?.lowercased().contains((self.styleInput.text?.lowercased())!))! })
                }
                
                //Filter By Brand
                if self.brandInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.brand == nil || ($0.brand?.lowercased().contains((self.brandInput.text?.lowercased())!))! })
                }
                
                //Filter By PoNo.
                if self.poNoInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.poNo == nil || ($0.poNo?.lowercased().contains((self.poNoInput.text?.lowercased())!))! })
                }
                
                //Filter By Ship Win Date
                let shipWinFrom = dateFormatter.date(from: self.shipWinFromInput.text! == "" ? "01/01/1970" : self.shipWinFromInput.text!)
                let shipWinTo = dateFormatter.date(from: self.shipWinToInput.text! == "" ? "12/30/2099" : self.shipWinToInput.text!)
                
                tasksByFilter = tasksByFilter.filter({ $0.shipWin == nil || $0.shipWin == "" || self.filterByShipWin($0.shipWin!, shipWinFrom: shipWinFrom!, shipWinTo: shipWinTo!) })
                
                //Filter By OPDRSD
                let opdRsdFrom = dateFormatter.date(from: self.opdRsdFromInput.text! == "" ? "01/01/1970" : self.opdRsdFromInput.text!)
                let opdRsdTo = dateFormatter.date(from: self.opdRsdToInput.text! == "" ? "12/30/2099" : self.opdRsdToInput.text!)
                
                tasksByFilter = tasksByFilter.filter({ $0.opdRsd == nil || $0.opdRsd == "" || self.filterByOPDRSD($0.opdRsd!, opdRsdFrom: opdRsdFrom!, opdRsdTo: opdRsdTo!) })
                
                //Filter By Vendor
                if self.vendorInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.vendor == nil || ($0.vendor != "" && ($0.vendor?.lowercased().contains((self.vendorInput.text?.lowercased())!))!) })
                }
                
                //Filter By VendorLocation
                if self.vendorLocationInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.vendorLocation == nil || ($0.vendorLocation != "" && ($0.vendorLocation?.lowercased().contains((self.vendorLocationInput.text?.lowercased())!))!) })
                }
                
                
                //Filter By Task Status Pending
                if !self.pendingSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Pending").rawValue) })
                }
                
                
                //Filter By Task Status Draft
                if !self.draftSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Draft").rawValue) })
                }
                
                
                //Filter By Task Status Confirmed
                if !self.confirmedSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Confirmed").rawValue) })
                }
                
                
                //Filter By Task Status Uploaded
                if !self.uploadedSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Uploaded").rawValue) })
                }
                
                
                //Filter By Task Status Refuserd
                if !self.refuseSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Refused").rawValue) })
                }
                
                
                //Filter By Task Status Cancelled
                if !self.canceledSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Cancelled").rawValue) })
                }
                
               
                //Filter By Task Status Revieweded
                if !self.reviewedSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Reviewed").rawValue) })
                }
                
                self.tasks = tasksByFilter
                
                self.sortBySegmentSelected(self.taskHeaderSegment.selectedSegmentIndex)
                
                self.taskItemTableView.reloadData()
                
                self.view.removeActivityIndicator()
            }
        })
    }
    
    func filterByShipWin(_ shipWinTmp:String, shipWinFrom:Date, shipWinTo:Date) ->Bool {
        let shipWinTmpArray = shipWinTmp.characters.split{$0 == ","}.map(String.init)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        if shipWinTmpArray.count>0 {
            
            for shipWin in shipWinTmpArray {
                
                if shipWin != "" && (dateFormatter.date(from: shipWin)!.equalToDate(shipWinFrom) || dateFormatter.date(from: shipWin)!.equalToDate(shipWinTo) || (dateFormatter.date(from: shipWin)!.isGreaterThanDate(shipWinFrom) && dateFormatter.date(from: shipWin)!.isLessThanDate(shipWinTo)))
                {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func filterByOPDRSD(_ opdRsdTmp:String, opdRsdFrom:Date, opdRsdTo:Date) ->Bool {
        let opdRsdTmpArray = opdRsdTmp.characters.split{$0 == ","}.map(String.init)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        if opdRsdTmpArray.count>0 {
            
            for opdRsd in opdRsdTmpArray {
                
                if opdRsd != "" && (dateFormatter.date(from: opdRsd)!.equalToDate(opdRsdFrom) || dateFormatter.date(from: opdRsd)!.equalToDate(opdRsdTo) || (dateFormatter.date(from: opdRsd)!.isGreaterThanDate(opdRsdFrom) && dateFormatter.date(from: opdRsd)!.isLessThanDate(opdRsdTo)))
                {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    @IBAction func clearOnClick(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.view.showActivityIndicator()
            
            DispatchQueue.main.async(execute: {
                
                self.bookingDateFromInput.text = ""
                self.bookingDateToInput.text = ""
                self.bookingNoInput.text = ""
                self.inspTypeInput.text = ""
                self.styleInput.text = ""
                self.brandInput.text = ""
                self.poNoInput.text = ""
                self.shipWinFromInput.text = ""
                self.shipWinToInput.text = ""
                self.vendorInput.text = ""
                self.vendorLocationInput.text = ""
                self.opdRsdFromInput.text = ""
                self.opdRsdToInput.text = ""
                
                self.view.removeActivityIndicator()
            })
        })
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.clearDropdownviewForSubviews(self.view)
        if !showListData {
            showListData = true
            return false
        }
        
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.bookingDateFromInput || textField == self.bookingDateToInput || textField == self.shipWinFromInput || textField == self.shipWinToInput || textField == self.opdRsdFromInput || textField == self.opdRsdToInput {
            UITextField.init().showDatePicker(textField)
            
            return false
        }else if textField == self.inspTypeInput {
            let taskDataHelper = TaskDataHelper()
            let inspTypeData = taskDataHelper.getAllInspType()
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: inspTypeData as NSArray)
            return false
        }
        
        /*else if textField == self.bookingNoInput {
            let taskDataHelper = TaskDataHelper()
            let bookingNoList = taskDataHelper.getAllTaskBookingNo(textField.text!)
            
            Cache_Dropdown_Instance = textField.showListData(textField, parent: self.view, listData: bookingNoList, width: 200, height: 650)
        
        }else if textField == self.poNoInput {
            let poDataHelper = PoDataHelper()
            let poNoList = poDataHelper.getAllTaskPoNo(textField.text!)
            
            Cache_Dropdown_Instance = textField.showListData(textField, parent: self.view, listData: poNoList, width: 200, height: 650)
        }else if textField == self.styleInput {
            let poDataHelper = PoDataHelper()
            let styleList = poDataHelper.getAllStyleNoByValue(textField.text!)
            
            Cache_Dropdown_Instance = textField.showListData(textField, parent: self.view, listData: styleList, width: 200, height: 650)
        }*/else if textField == self.brandInput {
            let taskDataHelper = TaskDataHelper()
            let brandList = taskDataHelper.getAllTaskBrandNames()
            
            textField.showListData(textField, parent: self.view, listData: brandList as NSArray)
            
        }else if textField == self.vendorInput {
            
            var vdrData = [String]()
            
            for vendor in vendors {
                vdrData.append(vendor.displayName!)
            }
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vdrData as NSArray)
        }else if textField == self.vendorLocationInput{
            var vdrLocData = [String]()
            var currVendorId = "0"
            
            if self.vendorInput.text != "" {
                let vendorOnFilter = vendors.filter({ $0.displayName == self.vendorInput.text })
                
                if vendorOnFilter.count > 0 {
                    let vendorOn = vendorOnFilter[0]
                    currVendorId = vendorOn.vdrId!
                }
            }
            
            for vendorLoc in vendorLocs {
                if vendorLoc.vdrId == currVendorId || currVendorId == "0" {
                    vdrLocData.append(vendorLoc.locationCode!)
                }
            }
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vdrLocData as NSArray, width: 150)
        }
 
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        if textField == self.vendorLocationInput || textField == self.vendorInput {
            self.vendorLocationInput.text = ""
            self.vendorInput.text = ""
            
            showListData = false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var inputValue = ""
        if textField.text!.characters.count < 2 && string == "" {
            inputValue = ""
            textField.showListData(textField, parent: self.view, handle: nil, listData: [String]() as NSArray, width: 200)
            return true
        }else if string == ""{
            inputValue = String(textField.text!.characters.dropLast())
        }else {
            inputValue = textField.text! + string
        }
        
        if textField == self.styleInput {
            let taskDataHelper = TaskDataHelper()
            let styleList = taskDataHelper.getAllStyleNoByValue(inputValue)

            textField.showListData(textField, parent: self.view, listData: styleList as NSArray, width: 200)
            
        }else if textField == self.bookingNoInput {
            let taskDataHelper = TaskDataHelper()
            let bookingNoList = taskDataHelper.getAllTaskBookingNo(inputValue)
            
            textField.showListData(textField, parent: self.view, listData: bookingNoList as NSArray, width: 200)
            
        }else if textField == self.poNoInput {
            let poDataHelper = PoDataHelper()
            let poNoList = poDataHelper.getAllTaskPoNo(inputValue)
            
            textField.showListData(textField, parent: self.view, listData: poNoList as NSArray, width: 200)
            
        }else if textField == self.brandInput {
            let taskDataHelper = TaskDataHelper()
            let brandList = taskDataHelper.getAllTaskBrandNames(inputValue)
            
            textField.showListData(textField, parent: self.view, listData: brandList as NSArray, width: 200)
            
        }else if textField == self.vendorInput {
            let vendorDataHelper = VendorDataHelper()
            let vendorList = vendorDataHelper.getAllVendors(inputValue)
            let handleFun:(UITextField)->(Void) = dropdownHandleFunc
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vendorList as NSArray, width: 200)
        }
        else if textField == self.vendorLocationInput {
            let vendorDataHelper = VendorDataHelper()
            let vendorLocationList = vendorDataHelper.getAllVendorLocs(inputValue)
            let handleFun:(UITextField)->(Void) = dropdownHandleFunc
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vendorLocationList as NSArray, width: 200)
        }
        
        return true
    }
    
    func dropdownHandleFunc(_ textField: UITextField) {
        
        if textField == self.vendorInput {
            
            let vendorOnFilter = vendors.filter({ $0.displayName == textField.text })
            
            if vendorOnFilter.count > 0 {
                let vendorOn = vendorOnFilter[0]
                let vendorLocFilter = vendorLocs.filter({ $0.vdrId == vendorOn.vdrId})
                
                if vendorLocFilter.count > 0 {
                    let vendorLoc = vendorLocFilter[0]
                    self.vendorLocationInput.text = vendorLoc.locationCode
                }
            }
        }else if textField == self.vendorLocationInput {
            
            let vendorLocFilter = vendorLocs.filter({ $0.locationCode == textField.text })
            
            if vendorLocFilter.count > 0 {
                let vendorLocOn = vendorLocFilter[0]
                let vendorOnFilter = vendors.filter({ $0.vdrId == vendorLocOn.vdrId})
                
                if vendorOnFilter.count > 0 {
                    let vendor = vendorOnFilter[0]
                    self.vendorInput.text = vendor.displayName
                }
            }
        }
    }
}
