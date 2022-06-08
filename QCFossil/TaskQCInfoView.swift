//
//  TaskQCInfoView.swift
//  QCFossil
//
//  Created by pacmobile on 19/7/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import UIKit

class TaskQCInfoView: UIView {
    
    @IBOutlet weak var sectionHeaderLabel1: UILabel!
    @IBOutlet weak var sectionHeaderLabel2: UILabel!
    @IBOutlet weak var sectionHeaderLabel3: UILabel!
    @IBOutlet weak var sectionHeaderLabel4: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorInput: UITextField!
    @IBOutlet weak var qcInternalNoLabel: UILabel!
    @IBOutlet weak var qcInternalNoInput: UITextField!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandInput: UITextField!
    @IBOutlet weak var tsReportNoLabel: UILabel!
    @IBOutlet weak var tsReportNoInput: UITextField!
    @IBOutlet weak var materialCategoryLabel: UILabel!
    @IBOutlet weak var materialCategoryInput: UITextField!
    @IBOutlet weak var assortmentLabel: UILabel!
    @IBOutlet weak var assortmentInput: UITextField!
    @IBOutlet weak var inspectorLabel: UILabel!
    @IBOutlet weak var inspectorInput: UITextField!
    @IBOutlet weak var assortmentStyleLabel: UILabel!
    @IBOutlet weak var assortmentStyleInput: UITextField!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var seasonInput: UITextField!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var updateTimeInput: UITextField!
    @IBOutlet weak var poView: UIView!
    @IBOutlet weak var orderQtyLabel: UILabel!
    @IBOutlet weak var orderQtyInput: UITextField!
    @IBOutlet weak var qualityStardardLabel: UILabel!
    @IBOutlet weak var qualityStardardInput: UITextField!
    @IBOutlet weak var bookedQtyLabel: UILabel!
    @IBOutlet weak var bookedQtyInput: UITextField!
    @IBOutlet weak var markingLabel: UILabel!
    @IBOutlet weak var markingInput: UITextField!
    @IBOutlet weak var aqlQtyLabel: UILabel!
    @IBOutlet weak var aqlQtyInput: UITextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var adjustTimeLabel: UILabel!
    @IBOutlet weak var adjustTimeInput: UITextField!
    @IBOutlet weak var lengthReqLabel: UILabel!
    @IBOutlet weak var lengthReqInput: UITextField!
    @IBOutlet weak var productGradeLabel: UILabel!
    @IBOutlet weak var productGradeInput: UITextField!
    @IBOutlet weak var movtLabel: UILabel!
    @IBOutlet weak var movtInput: UITextField!
    @IBOutlet weak var upcOrbidStatusLabel: UILabel!
    @IBOutlet weak var upcOrbidStatusInput: UITextField!
    @IBOutlet weak var combineQCRemarkLabel: UILabel!
    @IBOutlet weak var combineQCRemarkInput: UITextField!
    @IBOutlet weak var ssReadyLabel: UILabel!
    @IBOutlet weak var ssReadyInput: UITextField!
    @IBOutlet weak var ssCommentReadyLabel: UILabel!
    @IBOutlet weak var ssCommentReadyInput: UITextField!
    @IBOutlet weak var tsSubmitDateLabel: UILabel!
    @IBOutlet weak var tsSubmitDateInput: UITextField!
    @IBOutlet weak var tsResultLabel: UILabel!
    @IBOutlet weak var tsResultInput: UITextField!
    @IBOutlet weak var samePOWithRejectLabel: UILabel!
    @IBOutlet weak var samePOWithRejectInput: UITextField!
    @IBOutlet weak var inspectSampleReadyLabel: UILabel!
    @IBOutlet weak var inspectSampleReadyInput: UITextField!
    @IBOutlet weak var linkTestQtyLabel: UILabel!
    @IBOutlet weak var linkTestQtyInput: UITextField!
    @IBOutlet weak var dustTestQtyLabel: UILabel!
    @IBOutlet weak var dustTestQtyInput: UITextField!
    @IBOutlet weak var smartLinkTestQtyLabel: UILabel!
    @IBOutlet weak var smartLinkTestQtyInput: UITextField!
    @IBOutlet weak var otherTestQtyLabel: UILabel!
    @IBOutlet weak var otherTestQtyInput: UITextField!
    @IBOutlet weak var caFormLabel: UILabel!
    @IBOutlet weak var caFormInput: UITextField!
    @IBOutlet weak var precisionReportLabel: UILabel!
    @IBOutlet weak var precisionReportInput: UITextField!
    @IBOutlet weak var smartLinkReportLabel: UILabel!
    @IBOutlet weak var smartLinkReportInput: UITextField!
    @IBOutlet weak var reliabilityTestRemarkLabel: UILabel!
    @IBOutlet weak var reliabilityTestRemarkInput: UITextField!
    @IBOutlet weak var ftyPackInfoLabel: UILabel!
    @IBOutlet weak var ftyPackInfoInput: UITextField!
    @IBOutlet weak var ftyDroptestInfoLabel: UILabel!
    @IBOutlet weak var ftyDroptestInfoInput: UITextField!

    @IBOutlet weak var salesmanLabel: UILabel!
    @IBOutlet weak var caseBackLabel: UILabel!
    @IBOutlet weak var caseBackPhoto: UIImageView!
    @IBOutlet weak var salesmanPhoto: UIImageView!

    @IBOutlet weak var displayInspectorFullTextBtn: UIButton!
    @IBOutlet weak var displayQualityStandardFullTextBtn: UIButton!
    @IBOutlet weak var displayCombineQCRemarkFullTextBtn: UIButton!
    @IBOutlet weak var displayLengthReqFullTextBtn: UIButton!
    @IBOutlet weak var displayMovtFullTextBtn: UIButton!
    
    @IBOutlet weak var displaySSReadyFullTextBtn: UIButton!
    @IBOutlet weak var displaySSCommentReadyFullTextBtn: UIButton!
    @IBOutlet weak var displayCAFormFullTextBtn: UIButton!
    @IBOutlet weak var displayReliabilityFullTextBtn: UIButton!
    
    var caFormInputText = ""
    var combineQCRemarkInputText = ""
    var reliabilityTestRemarkInputText = ""
    var ssReadyInputText = ""
    var ssCommentReadyInputText = ""
    var tsSubmitDateInputText = ""
    var tsResultInputText = ""
    var qualityStardardInputText = ""
    var inspectors = ""
    var lengthReqInputText = ""
    var movtInputText = ""
    
    override func awakeFromNib() {
        updateCell(self)
        
        self.displayMovtFullTextBtn.isHidden = true
        self.displayCAFormFullTextBtn.isHidden = true
        self.displaySSReadyFullTextBtn.isHidden = true
        self.displayInspectorFullTextBtn.isHidden = true
        self.displayLengthReqFullTextBtn.isHidden = true
        self.displayReliabilityFullTextBtn.isHidden = true
        self.displaySSCommentReadyFullTextBtn.isHidden = true
        self.displayCombineQCRemarkFullTextBtn.isHidden = true
        self.displayQualityStandardFullTextBtn.isHidden = true
    }

    func updateCell(_ view:UIView) {
        
        // Get the subviews of the view
        let subviews = view.subviews
        
        // Return if there are no subviews
        if subviews.count < 1 {
            return
        }
        
        self.qualityStardardInput.isUserInteractionEnabled = false
        
        subviews.forEach({
            if $0.classForCoder == UITextField.classForCoder() {
                $0.isUserInteractionEnabled = false
            }
            
            updateCell($0)
        })
    }
    
    override func didMoveToSuperview() {
        self.sectionHeaderLabel1.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Product Info")
        self.vendorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor")
        self.qcInternalNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Internal No")
        self.brandLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.tsReportNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("TS Report No")
        self.materialCategoryLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Material Category")
        self.assortmentLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Assortment")
        self.inspectorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspector")
        self.assortmentStyleLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Assortment Style")
        self.seasonLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Season")
        self.updateTimeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Update datetime")
        
        self.sectionHeaderLabel2.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Info")
        self.orderQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Order Qty")
        self.qualityStardardLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Quality Standard")
        self.bookedQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Booked Qty")
        self.markingLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Marking")
        self.aqlQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("AQL Qty")
        self.weightLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Weight")
        self.adjustTimeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Adjust Time")
        self.lengthReqLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Length Req.")
        self.productGradeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Product Grade")
        self.movtLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Movt(Origin)")
        self.upcOrbidStatusLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("UPC-Orbid Status")
        self.combineQCRemarkLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Combine QC Remark")
        
        self.sectionHeaderLabel3.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SS/TS Info")
        self.ssReadyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SS Ready")
        self.ssCommentReadyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SS Comment Ready")
        self.tsSubmitDateLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("TS Submit Date")
        self.tsResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("TS Result")
        self.samePOWithRejectLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Same PO with Reject")
        self.inspectSampleReadyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Sample Ready")
        self.linkTestQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Link Test Qty")
        self.dustTestQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Dust Test Qty")
        self.smartLinkTestQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Smart Link Test Qty")
        self.otherTestQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Other Test Qty")
        
        self.sectionHeaderLabel4.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Additional Info")
        self.caFormLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("CA Form")
        self.precisionReportLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Precision Report")
        self.smartLinkReportLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Smart Link Report")
        self.reliabilityTestRemarkLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Reliability Test Remark")
        self.ftyPackInfoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fty Pack Info")
        self.ftyDroptestInfoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Fty Droptest Info")
        
        self.salesmanLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Salesman Photo")
        self.caseBackLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Case Back")
        
    }
    
    @IBAction func showFullText(_ sender: UIButton) {
        
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSize(width: 320, height: 150 + _NAVIBARHEIGHT)//CGSizeMake(320,150 + _NAVIBARHEIGHT)
//        popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
        popoverContent.dataType = _POPOVERNOTITLE
        
        switch sender.tag {
        case 1:
            popoverContent.selectedValue = self.caFormInputText ?? ""
            break
        case 2:
            popoverContent.selectedValue = self.combineQCRemarkInputText ?? ""
            break
        case 3:
            popoverContent.selectedValue = self.reliabilityTestRemarkInputText ?? ""
            break
        case 4:
            popoverContent.selectedValue = self.ssReadyInputText ?? ""
            break
        case 5:
            popoverContent.selectedValue = self.ssCommentReadyInputText ?? ""
            break
        case 6:
            popoverContent.selectedValue = self.tsSubmitDateInputText ?? ""
            break
        case 7:
            popoverContent.selectedValue = self.tsResultInputText ?? ""
            break
        case 8:
            popoverContent.selectedValue = self.qualityStardardInputText ?? ""
            break
        case 9:
            popoverContent.selectedValue = self.inspectors ?? ""
            break
        case 10:
            popoverContent.selectedValue = self.lengthReqInputText ?? ""
            break
        case 11:
            popoverContent.selectedValue = self.movtInputText ?? ""
            break
        default:
            popoverContent.selectedValue = self.caFormInputText ?? ""
            break
        }
        
        
        let nav = CustomNavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.tintColor = UIColor.black
        
        let popover = nav.popoverPresentationController
        popover!.delegate = sender.parentVC as! PopoverMaster
        popover!.sourceView = sender
       
        
        switch sender.tag {
        case 1:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        case 2:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY - 250,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        case 3:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY - 100,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        case 6:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY - 100,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        case 7:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY - 100,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        case 8:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY - 100,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        case 9:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY - 100,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        case 10:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY - 200,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        case 11:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY - 250,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        default:
            popover!.sourceRect = CGRect(x: 0,y: sender.frame.minY,width: sender.frame.size.width,height: sender.frame.size.height)
            break
        }
        
        sender.parentVC!.present(nav, animated: true, completion: nil)
    }

}
