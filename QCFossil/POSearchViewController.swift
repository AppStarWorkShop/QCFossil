//
//  POSearchViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 11/1/16.
//  Copyright © 2016 kira. All rights reserved.
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


class POSearchViewController: PopoverMaster, UITableViewDelegate,  UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorInput: UITextField!
    @IBOutlet weak var vendorLocationLabel: UILabel!
    @IBOutlet weak var vendorLocationInput: UITextField!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleInput: UITextField!
    @IBOutlet weak var poNoLabel: UILabel!
    @IBOutlet weak var poNoInput: UITextField!
    @IBOutlet weak var shipWinFromInput: UITextField!
    @IBOutlet weak var shipWinFromLabel: UILabel!
    @IBOutlet weak var shipWinToLabel: UILabel!
    @IBOutlet weak var shipWinToInput: UITextField!
    @IBOutlet weak var orFromLabel: UILabel!
    @IBOutlet weak var orFromInput: UITextField!
    @IBOutlet weak var orToLabel: UILabel!
    @IBOutlet weak var orToInput: UITextField!
    @IBOutlet weak var taskScheduledLabel: UILabel!
    @IBOutlet weak var taskScheduledInput: UITextField!
    @IBOutlet weak var poTableView: UITableView!
    @IBOutlet weak var selectPOLineBtn: UIButton!
    @IBOutlet weak var PoSortingBar: UISegmentedControl!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var cancelBtnPopup: UIButton!
    @IBOutlet weak var poSearchTitlePopup: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandInput: UITextField!
    
    var poItems = [PoItem]()
    var poItemSet = [PoItem]()
    var poSelectedItems = [PoItem]()
    var vendors = [Vendor]()
    var vendorLocs = [VdrLoc]()
    var brands = [Brand]()
    weak var pVC:UIViewController!
    var vendorName = ""
    var vendorLocCode = ""
    var styleNo = ""
    var showListData = true
    var vendorId:String?
    var vendorLocationCodeId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // Do any additional setup after loading the view.
        poTableView.delegate = self
        poTableView.dataSource = self
        vendorInput.delegate = self
        vendorLocationInput.delegate = self
        taskScheduledInput.delegate = self
        shipWinFromInput.delegate = self
        shipWinToInput.delegate = self
        orFromInput.delegate = self
        orToInput.delegate = self
        brandInput.delegate = self
        poNoInput.delegate = self
        styleInput.delegate = self
        
        self.vendorInput.text = vendorName
        self.vendorLocationInput.text = vendorLocCode
        self.styleInput.text = styleNo
        self.taskScheduledInput.text =  MylocalizedString.sharedLocalizeManager.getLocalizedString("All")
        
        if vendorName != "" && vendorLocCode != "" && styleNo != "" {
            //if pVC != nil && pVC?.classForCoder == TaskDetailsViewController.classForCoder() {
            self.vendorInput.isUserInteractionEnabled = false
            self.vendorLocationInput.isUserInteractionEnabled = false
            self.styleInput.isUserInteractionEnabled = false
            
        }
        initData()
        self.view.setButtonCornerRadius(self.searchBtn)
        self.view.setButtonCornerRadius(self.clearBtn)
        self.view.setButtonCornerRadius(self.selectPOLineBtn)
    }
    
    func initData() {
        DispatchQueue.main.async(execute: {
            
            let vendorDataHelper = VendorDataHelper()
            self.vendors = vendorDataHelper.getAllVendorsFromPOSearch()!
            self.vendorLocs = vendorDataHelper.getAllVdrLocsFromPOSearch()!
            
            let taskDataHelper = TaskDataHelper()
            self.brands = taskDataHelper.getAllTaskBrands()
            
            NotificationCenter.default.addObserver(self, selector: #selector(POSearchViewController.reloadPoSearchTableView), name: NSNotification.Name(rawValue: "reloadPoSearchTableView"), object: nil)
        })
    }
    
    @objc func reloadPoSearchTableView() {
        poItemSet = [PoItem]()
        vendors = [Vendor]()
        vendorLocs = [VdrLoc]()
        brands = [Brand]()
        
        let taskDataHelper = TaskDataHelper()
        brands = taskDataHelper.getAllTaskBrands()
        
        let poDataHelper = PoDataHelper()
        poItemSet = poDataHelper.getAllPoItems()!
        
        let vendorDataHelper = VendorDataHelper()
        vendors = vendorDataHelper.getAllVendorsFromPOSearch()!
        vendorLocs = vendorDataHelper.getAllVdrLocsFromPOSearch()!
        
        updateLocalizedString()
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
    
    func updateLocalizedString(){
        
        let sortingBarTitles = [MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No."),MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand"),
            MylocalizedString.sharedLocalizeManager.getLocalizedString("Style"),
            MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship To"),
            MylocalizedString.sharedLocalizeManager.getLocalizedString("SW/Req. Ex-fty Date"),
            MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD")
        ]
        
        for idx in 0...sortingBarTitles.count - 1 {
            if self.PoSortingBar != nil {
                self.PoSortingBar.numberOfSegments
                self.PoSortingBar.setTitle(sortingBarTitles[idx], forSegmentAt: idx)
            }
        }
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO Search")
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        self.navigationItem.rightBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Create Task")
        
        if (self.vendorLabel != nil) {
            self.vendorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("*Vendor")
        }
        
        if (self.vendorLocationLabel != nil){
            self.vendorLocationLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("*Vendor Location")
        }
        
        if (self.styleLabel != nil) {
            self.styleLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
        }
        
        if(self.poNoLabel != nil) {
            self.poNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        }
        
        if(self.brandLabel != nil) {
            self.brandLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        }
        
        if(self.shipWinFromLabel != nil) {
            self.shipWinFromLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship Win From")
        }
        
        if(self.shipWinToLabel != nil){
            self.shipWinToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("To")
        }
        
        if(self.orFromLabel != nil){
            self.orFromLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD From")
        }
        
        if(self.orToLabel != nil) {
            self.orToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("To")
        }
        
        if(self.taskScheduledLabel != nil){
            self.taskScheduledLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Scheduled?")
        }
        
        if(self.styleInput != nil){
            self.styleInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
        }
        
        if(self.poNoInput != nil){
            self.poNoInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        }
        
        if(self.shipWinFromInput != nil){
            self.shipWinFromInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        }
        
        if(self.shipWinToInput != nil){
            self.shipWinToInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        }
        
        if(self.orFromInput != nil){
            self.orFromInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        }
        
        if(self.orToInput != nil){
            self.orToInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        }
        
        if(self.searchBtn != nil){
            self.searchBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Search"), for: UIControl.State() )
        }
        
        if(self.clearBtn != nil){
            self.clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), for: UIControl.State())
        }
        
        if(self.selectPOLineBtn != nil){
            self.selectPOLineBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Select PO Line"), for: UIControl.State())
        }
        
        if(self.brandInput != nil){
            self.brandInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        }
        
        if(self.vendorInput != nil){
            self.vendorInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor PlaceHolder")
        }
        
        if(self.vendorLocationInput != nil) {
            self.vendorLocationInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location PlaceHolder")
        }
        
        if(self.cancelBtnPopup != nil){
            self.cancelBtnPopup.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), for: UIControl.State())
        }
        
        if(self.poSearchTitlePopup != nil) {
            self.poSearchTitlePopup.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO Search")
        }
        //initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.view.showActivityIndicator()
            
            DispatchQueue.main.async(execute: {
                self.updateLocalizedString()
                
                if self.pVC?.classForCoder == CreateTaskViewController.classForCoder() || self.pVC?.classForCoder == TaskDetailsViewController.classForCoder() {
                    self.selectPOLineBtn.isHidden = false
                    let leftButton = UIBarButtonItem()
                    leftButton.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel")
                    leftButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
                    leftButton.style = UIBarButtonItem.Style.plain
                    leftButton.target = self
                    leftButton.action = #selector(self.closeButton)
                    
                    self.navigationItem.leftBarButtonItem = leftButton
                    self.navigationItem.rightBarButtonItem = nil
                }
                
                if self.vendorName != "" && self.vendorLocCode != "" && self.styleNo != "" {
                    var poItemsByFilter = self.poItemSet
                    
                    for poItem in self.poSelectedItems {
                        poItemsByFilter = poItemsByFilter.filter({$0.itemId != poItem.itemId})
                    }
                    
                    if self.vendorInput.text != "" {
                        poItemsByFilter = poItemsByFilter.filter({ ($0.vdrDisplayName?.lowercased().contains((self.vendorInput.text?.lowercased())!))! })
                    }
                    
                    //Filter By VendorLocation
                    if self.vendorLocationInput.text != "" {
                        poItemsByFilter = poItemsByFilter.filter({ ($0.vdrLocationCode?.lowercased().contains((self.vendorLocationInput.text?.lowercased())!))! })
                    }
                    
                    //Filter By StyleNo
                    if self.styleInput.text != "" {
                        poItemsByFilter = poItemsByFilter.filter({ ($0.styleNo?.lowercased().contains((self.styleInput.text?.lowercased())!))! })
                    }
                    
                    self.poItems = poItemsByFilter
                }
                
                self.poTableView.reloadData()
                
                self.view.removeActivityIndicator()
                
                
                //NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
                
            })
        })
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CreateTaskSegueFromPO" {
            
            let destVC = segue.destination as! CreateTaskViewController
            destVC.poItems = poSelectedItems
            destVC.pVC = self
            destVC.vendorId = vendorId
            destVC.vendorLocationCodeId = vendorLocationCodeId
            
            if poSelectedItems.count>0 {
                let poSelectedItem = poSelectedItems[0]
                destVC.vendorName = poSelectedItem.vdrDisplayName!
                destVC.vendorLocCode = poSelectedItem.vdrLocationCode!
            
            }
            
            poSelectedItems = [PoItem]()
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
        
        return poItems.count
    }
    
    func tableView(_ poItemTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = poItemTableView.dequeueReusableCell(withIdentifier: "poCell", for: indexPath) as! POSearchTableViewCell
        
        let poItem = poItems[indexPath.row] as PoItem
        
        cell.poNoInput.text = poItem.poNo
        cell.poLineNoInput.text = poItem.poLineNo
        cell.brandInput.text = poItem.brandName
        cell.styleInput.text = poItem.styleNo
        cell.orderQtyInput.text = String(poItem.orderQty)
        cell.shipToInput.text = String(poItem.buyerLocationCode)
        cell.taskScheduledInput.text = ""
        cell.shipWinInput.text = poItem.shipWin
        cell.orInput.text = ""
        cell.osQCQtyInput.text = String(poItem.orderQty-poItem.qcBookedQty) //String(poItem.outStandQty!)
        cell.shipToInput.text = poItem.shipTo
        cell.orInput.text = poItem.opdRsd
        cell.taskScheduledInput.text = poItem.taskSched
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = _TABLECELL_BG_COLOR2
        }else{
            cell.backgroundColor = _TABLECELL_BG_COLOR1
        }
        
        for poItem in poSelectedItems {
            if cell.poNoInput.text == poItem.poNo && cell.poLineNoInput.text == poItem.poLineNo {
                self.poTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none/*UITableViewScrollPosition.Top*/)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let poSelectedData = poItems[indexPath.row] as PoItem
        poSelectedItems.append(poSelectedData)
        
        self.styleInput.text = poSelectedData.styleNo
        
        //Filter By Style
        poItems = poItems.filter({ ($0.styleNo?.lowercased().contains((self.styleInput.text?.lowercased())!))! })
        self.poTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let poSelectedData = poItems[indexPath.row] as PoItem
        let index = poSelectedItems.index(where: { $0.poNo == poSelectedData.poNo && $0.poLineNo == poSelectedData.poLineNo } )
        poSelectedItems.remove(at: index!)
        
        if self.poSelectedItems.count < 1 {
            
            if self.styleInput.isUserInteractionEnabled == true {
                self.styleInput.text = ""
                self.poItems = self.poItemSet.filter({$0.vdrDisplayName == self.vendorInput.text && $0.vdrLocationCode == self.vendorLocationInput.text})
            }
        }
        
        self.poTableView.reloadData()
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
                    
                    if let vc = pVC as? CreateTaskViewController {
                        vc.vendorId = vendorOn.vdrId
                        vc.vendorLocationCodeId = vendorLoc.locationId
                    } else {
                        vendorId = vendorOn.vdrId
                        vendorLocationCodeId = vendorLoc.locationId
                    }
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
                    
                    if let vc = pVC as? CreateTaskViewController {
                        vc.vendorId = vendor.vdrId
                        vc.vendorLocationCodeId = vendorLocOn.locationId
                    } else {
                        vendorId = vendor.vdrId
                        vendorLocationCodeId = vendorLocOn.locationId
                    }
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.clearDropdownviewForSubviews(self.view)
        
        if !showListData {
            showListData = true
            return false
        }
        
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.shipWinFromInput || textField == self.shipWinToInput || textField == self.orFromInput || textField == self.orToInput {
            UITextField.init().showDatePicker(textField)
        }else if textField == self.taskScheduledInput {
            
            let vdrData = [ MylocalizedString.sharedLocalizeManager.getLocalizedString("YES"), MylocalizedString.sharedLocalizeManager.getLocalizedString("NO"), MylocalizedString.sharedLocalizeManager.getLocalizedString("ALL")]
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vdrData as NSArray, width: 269)
            
            return false
            
        }
            
        /*
        else if textField == self.poNoInput {
            let poDataHelper = PoDataHelper()
            let poNoList = poDataHelper.getAllPoNo(textField.text!)
            
            Cache_Dropdown_Instance = textField.showListData(textField, parent: self.view, handle: handleFun, listData: poNoList, width: 250, height: 650)
            
        }else if textField == self.styleInput {
            let poDataHelper = PoDataHelper()
            let styleList = poDataHelper.getAllStyleNoByValue(textField.text!)
            
            Cache_Dropdown_Instance = textField.showListData(textField, parent: self.view, handle: handleFun, listData: styleList, width: 250, height: 650)
            
        }*/else if textField == self.brandInput {
            let taskDataHelper = TaskDataHelper()
            let brandList = taskDataHelper.getAllTaskBrandNames()
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: brandList as NSArray, width: 250)
            
        }else if textField == self.vendorInput {
            var vdrData = [String]()

            if vendors.count < 1 {
                initData()
            }
            
            for vendor in vendors {
                vdrData.append(vendor.displayName!)
            }
 
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vdrData as NSArray, width: 269)
        }else if textField == self.vendorLocationInput {
            var vdrLocData = [String]()
            var currVendorId = "0"
            
            if vendorLocs.count < 1 {
                initData()
            }
            
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
            let poDataHelper = PoDataHelper()
            let styleList = poDataHelper.getAllStyleNoByValue(inputValue, vendorName: self.vendorInput.text!, vendorLocationCode: self.vendorLocationInput.text!)
            
            let handleFun:(UITextField)->(Void) = dropdownHandleFunc
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: styleList as NSArray, width: 200)
            
        }else if textField == self.poNoInput {
            let poDataHelper = PoDataHelper()
            let poNoList = poDataHelper.getAllPoNo(inputValue, vendorName: self.vendorInput.text!, vendorLocationCode: self.vendorLocationInput.text!)
            
            let handleFun:(UITextField)->(Void) = dropdownHandleFunc
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: poNoList as NSArray, width: 250)
            
        }else if textField == self.brandInput {
            let taskDataHelper = TaskDataHelper()
            let brandList = taskDataHelper.getAllTaskBrandNames(inputValue)

            let handleFun:(UITextField)->(Void) = dropdownHandleFunc
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: brandList as NSArray, width: 250)
        
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
    
    @IBAction func selectPOLineBtn(_ sender: UIButton) {
        
        if self.vendorInput.text == "" || self.vendorLocationInput.text == "" {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please chose a Vendor & Vendor Location!"))
            return
        }
        
        if pVC?.classForCoder == CreateTaskViewController.classForCoder() {
            let poItemsUsed = (pVC as! CreateTaskViewController).poItems
            for poItemUsed in poItemsUsed {
                poSelectedItems = poSelectedItems.filter({$0.itemId != poItemUsed.itemId})
            }
            
            (pVC as! CreateTaskViewController).poItems += poSelectedItems
            
            if poSelectedItems.count > 0 {
                (pVC as! CreateTaskViewController).vendorInput.text = self.vendorInput.text
                (pVC as! CreateTaskViewController).vdrLocationInput.text = self.vendorLocationInput.text
            }
            
        }else if pVC?.classForCoder == TaskDetailsViewController.classForCoder() {
            
            let taskDetailViewInput = pVC?.view.viewWithTag(_TASKDETAILVIEWTAG) as! TaskDetailViewInput
            
            if poSelectedItems.count>0 {
                for idx in 0...poSelectedItems.count-1 {
                    let exsit = taskDetailViewInput.poItems.filter({$0.itemId==poSelectedItems[idx].itemId})
                
                    //append if not exsit
                    if exsit.count<1{
                        taskDetailViewInput.poItems.append(poSelectedItems[idx])
                        Cache_Task_On?.poItems.append(poSelectedItems[idx])
                        
                        //Resize
                        taskDetailViewInput.resizePoWrapperContent(CGFloat(taskDetailViewInput.poCellHeight))
                    }
                }
            }
            
            Cache_Task_On?.didModify = true
            taskDetailViewInput.loadPoList()
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func MenuButton(_ sender: UIBarButtonItem) {
        NSLog("Toggle Menu")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
    }
    
    @IBAction func POSearchBtn(_ sender: UIButton) {
        
        if self.vendorInput.text == "" {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please select the Vendor!"))
            
            return
        }
        
        DispatchQueue.main.async(execute: {
            self.view.showActivityIndicator("Searching")
            
            DispatchQueue.main.async(execute: {
            let poDataHelper = PoDataHelper()
            self.poItemSet = poDataHelper.getAllPoItems()!
            
            //Reset Items
            self.poSelectedItems = [PoItem]()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = _DATEFORMATTER
                
                var poItemsByFilter = self.poItemSet
                
                //for poItem in self.poSelectedItems {
                if self.pVC?.classForCoder == CreateTaskViewController.classForCoder() {
                    for poItem in (self.pVC as! CreateTaskViewController).poItems {
                        poItemsByFilter = poItemsByFilter.filter({$0.itemId != poItem.itemId})
                    }
                }else if self.pVC?.classForCoder == TaskDetailsViewController.classForCoder() {
                    let taskDetailViewInput = self.pVC?.view.viewWithTag(_TASKDETAILVIEWTAG) as! TaskDetailViewInput
                    
                    for poItem in taskDetailViewInput.poItems {
                        poItemsByFilter = poItemsByFilter.filter({$0.itemId != poItem.itemId})
                    }
                }
                
                //Filter By Brand
                if self.brandInput.text != "" {
                    poItemsByFilter = poItemsByFilter.filter({ ($0.brandName?.lowercased().contains((self.brandInput.text?.lowercased())!))! })
                }
                
                //Filter By Style
                if self.styleInput.text != "" {
                    poItemsByFilter = poItemsByFilter.filter({ ($0.styleNo?.lowercased().contains((self.styleInput.text?.lowercased())!))! })
                }
                
                //Filter By PoNo.
                if self.poNoInput.text != "" {
                    poItemsByFilter = poItemsByFilter.filter({ ($0.poNo?.lowercased().contains((self.poNoInput.text?.lowercased())!))! })
                }
                
                //Filter By Ship Win Date
                if self.shipWinFromInput.text != "" {
                    let shipWinFromInput = dateFormatter.date(from: self.shipWinFromInput.text!)
                    poItemsByFilter = poItemsByFilter.filter({ $0.shipWin == nil || ($0.shipWin != "" && (dateFormatter.date(from: $0.shipWin)!.equalToDate(shipWinFromInput!) || dateFormatter.date(from: $0.shipWin)!.isGreaterThanDate(shipWinFromInput!))) })
                }
                
                if self.shipWinToInput.text != "" {
                    let shipWinToInput = dateFormatter.date(from: self.shipWinToInput.text!)
                    poItemsByFilter = poItemsByFilter.filter({ $0.shipWin == nil || ($0.shipWin != "" && (dateFormatter.date(from: $0.shipWin)!.equalToDate(shipWinToInput!) || dateFormatter.date(from: $0.shipWin)!.isLessThanDate(shipWinToInput!))) })
                }
                
                // Filter By OPD/RSD Date
                if self.orFromInput.text != "" {
                    let orFromInput = dateFormatter.date(from: self.orFromInput.text!)
                    poItemsByFilter = poItemsByFilter.filter({ $0.opdRsd == nil || ($0.opdRsd != "" && (dateFormatter.date(from: $0.opdRsd)!.equalToDate(orFromInput!) || dateFormatter.date(from: $0.opdRsd)!.isGreaterThanDate(orFromInput!))) })
                }
                
                if self.orToInput.text != "" {
                    let orToInput = dateFormatter.date(from: self.orToInput.text!)
                    poItemsByFilter = poItemsByFilter.filter({ $0.opdRsd == nil || ($0.opdRsd != "" && (dateFormatter.date(from: $0.opdRsd)!.equalToDate(orToInput!) || dateFormatter.date(from: $0.opdRsd)!.isLessThanDate(orToInput!))) })
                }
                
                //Filter By Vendor
                if self.vendorInput.text != "" {
                    //poItemsByFilter = poItemsByFilter.filter({ ($0.vdrDisplayName?.lowercaseString.containsString((self.vendorInput.text?.lowercaseString)!))! })
                    poItemsByFilter = poItemsByFilter.filter({ $0.vdrDisplayName == self.vendorInput.text })
                }
                
                //Filter By VendorLocation
                if self.vendorLocationInput.text != "" {
                    //poItemsByFilter = poItemsByFilter.filter({ ($0.vdrLocationName?.lowercaseString.containsString((self.vendorLocationInput.text?.lowercaseString)!))! })
                    poItemsByFilter = poItemsByFilter.filter({ $0.vdrLocationCode == self.vendorLocationInput.text })
                }
                
                //Filter By TaskScheduledInput
                if self.taskScheduledInput.text != "" &&  self.taskScheduledInput.text != MylocalizedString.sharedLocalizeManager.getLocalizedString("All") {
                    poItemsByFilter = poItemsByFilter.filter({ $0.taskSched == self.taskScheduledInput.text })
                }
                
                self.poItems = poItemsByFilter
                
                self.sortBySegment(self.PoSortingBar.selectedSegmentIndex)
                
                self.poTableView.reloadData()
                
                self.view.removeActivityIndicator()
            }
        })
        })
    }
    
    @IBAction func clearOnClick(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            //Reset Items
            self.poSelectedItems = [PoItem]()
            
            self.view.showActivityIndicator()
            
            DispatchQueue.main.async(execute: {
                if self.vendorInput.isUserInteractionEnabled == true {
                    self.vendorInput.text = ""
                }
                
                if self.vendorLocationInput.isUserInteractionEnabled == true {
                    self.vendorLocationInput.text = ""
                }
                
                if self.styleInput.isUserInteractionEnabled == true {
                    self.styleInput.text = ""
                }
                
                self.poNoInput.text = ""
                self.shipWinFromInput.text = ""
                self.shipWinToInput.text = ""
                self.orFromInput.text = ""
                self.orToInput.text = ""
                self.brandInput.text = ""
                self.taskScheduledInput.text = ""
                self.poSelectedItems = [PoItem]()
                self.poItems = [PoItem]()
                self.poTableView.reloadData()
                
                self.view.removeActivityIndicator()
            })
        })
        
    }
    
    @IBAction func POSearchSorting(_ sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex

        sortBySegment(selectedSegment)
        
        self.poTableView.reloadData()
    }
    
    func sortBySegment(_ selectedSegment:Int = 0) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        switch selectedSegment {
        case 0: poItems.sort(){$0.poNo>$1.poNo}; break
        case 1: poItems.sort(){$0.brandName<$1.brandName}; break
        case 2: poItems.sort(){$0.styleNo<$1.styleNo}; break
        case 3: poItems.sort(){$0.buyerLocationCode<$1.buyerLocationCode}; break
        case 4: poItems.sort(){($0.shipWin != "" && $1.shipWin != "") ? dateFormatter.date(from: $0.shipWin)!.isGreaterThanDate(dateFormatter.date(from: $1.shipWin)!) : $0.shipWin>$1.shipWin}; break
        case 5: poItems.sort(){ ($0.opdRsd != "" && $1.opdRsd != "") ? dateFormatter.date(from: $0.opdRsd)!.isGreaterThanDate(dateFormatter.date(from: $1.opdRsd)!) : $0.opdRsd>$1.opdRsd }; break
        default: poItems.sort(){$0.poNo>$1.poNo}; break
        }
        
    }
    
    @IBAction func createTaskBtnOnClick(_ sender: UIBarButtonItem) {
        
        if poSelectedItems.count > 0{
            self.performSegue(withIdentifier: "CreateTaskSegueFromPO", sender:self)
        }else{
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please add PO Lines(s)!"))
        }
    }
    
    @objc func closeButton() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setScrollable"), object: nil,userInfo: ["canScroll":false])
        self.dismiss(animated: true, completion: nil)
    }
}
