//
//  CreateTaskViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 11/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    @IBOutlet weak var bookingNoLabel: UILabel!
    @IBOutlet weak var bookingNoInput: UITextField!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingDateInput: UITextField!
    @IBOutlet weak var inspectTypeLabel: UILabel!
    @IBOutlet weak var inspectTypeInput: UITextField!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var productTypeInput: UITextField!
    @IBOutlet weak var inspectorLabel: UILabel!
    @IBOutlet weak var inspectorInput: UITextField!
    @IBOutlet weak var vdrLocationLabel: UILabel!
    @IBOutlet weak var vdrLocationInput: UITextField!
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var taskStatusInput: UITextField!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorInput: UITextField!
    @IBOutlet weak var basicInformation: UILabel!
    @IBOutlet weak var inspectionInformation: UILabel!
    @IBOutlet weak var addPoLineBtn: UIButton!
    @IBOutlet weak var createTaskTableview: UITableView!
    
    weak var pVC:UIViewController!
    var poCellHeight:CGFloat = 100
    var poItems = [PoItem]()
    var vendorName = ""
    var vendorLocCode = ""
    var tmplName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.performSegue(withIdentifier: "TaskTypeSelectionSegue", sender: self)
        self.inspectorInput.text = Cache_Inspector?.appUserName
        self.taskStatusInput.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(TaskStatus(caseId: GetTaskStatusId(caseId: "Pending").rawValue).rawValue)
        self.bookingDateInput.text = self.view.getCurrentDate()
        
        
        let keyValueDataHelper = KeyValueDataHelper()
        let runningNo = keyValueDataHelper.getTaskRunningNoByDate(String(Cache_Inspector!.inspectorId!))
        Cache_Inspector?.reportRunningNo = runningNo
        
        var reportRunningNo = (Cache_Inspector?.reportRunningNo)!
        while reportRunningNo.characters.count < 3 {
            reportRunningNo = "0"+reportRunningNo
        }
        
        self.bookingNoInput.text = (Cache_Inspector?.reportPrefix)!+"-"+self.view.getCurrentDate(_DATEFORMATTER2).replacingOccurrences(of: "/", with: "", options: NSString.CompareOptions.literal, range: nil)+reportRunningNo
        self.vendorInput.text = self.vendorName
        self.vdrLocationInput.text = self.vendorLocCode
        
        updateLocalizedString()
        
        self.view.setButtonCornerRadius(self.addPoLineBtn)
        
        self.createTaskTableview.rowHeight = poCellHeight
        self.createTaskTableview.delegate = self
        self.createTaskTableview.dataSource = self
    }
    
    func updateLocalizedString(){
        
        self.bookingNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Book/Inspect No.")
        self.bookingDateLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Book/Inspect Date")
        self.inspectTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Type")
        self.productTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Product Type")
        self.inspectorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspector")
        self.vdrLocationLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location")
        self.taskStatusLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status")
        self.vendorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor")
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
        
        self.inspectionInformation.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Information")
        self.addPoLineBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Add PO Line(s)"), for: UIControl.State())
        self.basicInformation.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Basic Information")
        self.vendorInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor")
        self.vdrLocationInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location")
        
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel")
        self.navigationItem.rightBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Save")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loadPoItemCell()
        self.createTaskTableview.reloadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "TaskTypeSelectionSegue" {
            let destVC = segue.destination as! TaskTypeViewController
            destVC.pVC = self
            
        }else if segue.identifier == "POSearchSegueFromCT" {
            if let destVC = segue.destination.children.first as? POSearchViewController {
                destVC.vendorName = self.vendorInput.text!
                destVC.vendorLocCode = self.vdrLocationInput.text!
                
                if poItems.count > 0 {
                    destVC.styleNo = poItems[0].styleNo!
                }
                
                destVC.poSelectedItems = poItems
                destVC.pVC = self
            }
        }
    }
    
    func createNotificationFromSubView() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTaskViewController.dismissFromSubView), name: NSNotification.Name(rawValue: "CreateTaskCancel"), object: nil)
    }
    
    @objc func dismissFromSubView() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CreateTaskCancel"), object: nil)
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":true])
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        NSLog("Save New Task")
        
        if self.poItems.count < 1 {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("No PO Item Selected!"))
            return
        }
        
        let taskDataHelper = TaskDataHelper()
        let inspTypeId = taskDataHelper.getInspTypeIdByName(self.inspectTypeInput.text!)
        let prodTypeId = taskDataHelper.getProdTypeIdByName(self.productTypeInput.text!)
        let tmplId = taskDataHelper.getTmplIdByName(tmplName)
        let inspSetupId = taskDataHelper.getInspSetupIdByName(tmplName)
        
        if inspTypeId < 1 || prodTypeId < 1 || tmplId < 1 {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Type / Product Type / Template Not Allow Empty!"))
            return
        }
        
        let vendorDataHelper = VendorDataHelper()
        let vdrLocId = vendorDataHelper.getVdrLocationIdByCode (self.vdrLocationInput.text!)
        
        if vdrLocId < 1 {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please chose a Vendor & Vendor Location!"))
            return
        }
        
        let task = Task(taskId: 0, prodTypeId: prodTypeId, inspectionTypeId: inspTypeId, bookingNo: "", bookingDate: "", vdrLocationId: vdrLocId, reportInspectorId: (Cache_Inspector?.inspectorId)!, reportPrefix: (Cache_Inspector?.reportPrefix)!,reportRunningNo:(Cache_Inspector?.reportRunningNo)!, inspectionNo: bookingNoInput.text!, inspectionDate: self.view.getCurrentDateTime(), taskRemarks: "", vdrNotes: "", inspectionResultValueId: 0, inspectionSignImageFile: "", vdrSignName: "", vdrSignImageFile: "", taskStatus: GetTaskStatusId(caseId: "Pending").rawValue, uploadInspectorId: (Cache_Inspector?.inspectorId)!, uploadDeviceId: "", refTaskId: 0, recStatus: 0, createUser: (Cache_Inspector?.appUserName)!, createDate: self.view.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.view.getCurrentDateTime(), deleteFlag: 0, deleteUser: "", deleteDate: "",inspectSetupId:inspSetupId, qcRemarks: "", additionalAdministrativeItems:"")
        
        task?.tmplId = tmplId
        task?.inspectSetupId = inspSetupId
        
        let poDataHelper = PoDataHelper()
        let taskId = poDataHelper.insertTask(task!)
        
        
        //update task inspector
        let taskInspector = TaskInspector(inspectorId: (Cache_Inspector?.inspectorId)!, createUser: (Cache_Inspector?.appUserName)!, createDate: self.view.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.view.getCurrentDateTime(), inspectEnableFlag: 1, taskId: taskId)
        
        if !poDataHelper.insertTaskInspector(taskInspector) {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot Update Task Inspector!"))
        }
        
        //update task items
        for i in 0  ..< poItems.count  {
            
            let taskItem = TaskItem(taskId: taskId, poItemId: poItems[i].itemId!, targetInspectQty: 0, availInspectQty: 0, inspectEnableFlag: 1, createUser: Cache_Inspector?.appUserName, createDate: self.view.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.view.getCurrentDateTime(), samplingQty: 0)
            
            if poDataHelper.InsertTaskItem(taskItem) < 1 {
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Create Failed!"))
            }
        }
        
        if taskId>0 {
            let taskDataHelper = TaskDataHelper()
            Cache_Task_On = taskDataHelper.getTaskById(taskId)
            
            let inspectorDataHelper = InspectorDataHelper()
            //Cache_Inspector?.reportRunningNo = String(Int((Cache_Inspector?.reportRunningNo)!)! + 1)
            inspectorDataHelper.updateRunningNo(Int((Cache_Inspector?.reportRunningNo)!)!, inspectorId: (Cache_Inspector?.inspectorId)!)
        }
        
        self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Create Successed!"),handlerFun: alertViewDismissCallBack)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":true])
    }
    
    func alertViewDismissCallBack(_ alert: UIAlertAction!) {
        print("Dismiss From Create Task Page")
        DispatchQueue.main.async {
            self.view.showActivityIndicator()
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "switchToTaskSearch"), object: nil, userInfo: nil)
            }
        }
    }
    
    func numberOfSections(in poItemTableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 1
    }
    
    func tableView(_ poItemTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.poItems.count
    }
    
    func tableView(_ poItemTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = poItemTableView.dequeueReusableCell(withIdentifier: "poCellInCreateTaskVC", for: indexPath) as! CreateTaskTableViewCell
        
        let poItem = poItems[indexPath.row] as PoItem
        
        cell.poNoText.text = poItem.poNo
        cell.poLineNoText.text = poItem.poLineNo
        cell.brandText.text = poItem.brandName
        cell.styleText.text = poItem.styleNo
        cell.orderQtyText.text = String(poItem.orderQty)
        cell.shipToText.text = String(poItem.buyerLocationCode)
        cell.shipWinInput.text = poItem.shipWin
        cell.orderQtyText.text = String(poItem.orderQty)
        cell.opdRsdInput.text = poItem.opdRsd //String(poItem.orderQty-poItem.qcBookedQty)
        cell.bookingQtyInput.text = "0"
        cell.pVC = self
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = _TABLECELL_BG_COLOR2
        }else{
            cell.backgroundColor = _TABLECELL_BG_COLOR1
        }
        
        return cell
    }

}
