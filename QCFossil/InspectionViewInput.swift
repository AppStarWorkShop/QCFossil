//
//  InspectionViewInput.swift
//  QCFossil
//
//  Created by Yin Huang on 29/1/16.
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


class InspectionViewInput: UIView, UIScrollViewDelegate {

    @IBOutlet weak var inspNo: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var borderLine: UILabel!
    
    var lastContentOffset:CGFloat! = 0
    var currentPage = 0
    var activeAlpha:CGFloat = 1.0
    var inactiveAlpha:CGFloat = 0.4
    var indexPoints = [UIButton]()
    
    weak var pVC:TaskDetailsViewController!
    //add actived sub-page here
    var activedPageIds = [Int]()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else {
            return
        }
        
        if touch.view!.isKind(of: UITextField().classForCoder) || String(describing: touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.resignFirstResponderByTextField(self)
            
        }else {
            self.clearDropdownviewForSubviews(self)
            
        }
    }
    
    override func didMoveToSuperview() {
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            
            return
        }
        
        let categoryCount = Cache_Task_On!.inspSections.count
        if categoryCount < 1 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("No Category Info in DB!"))
            return
        }
        
        self.inspNo.text = Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo
        self.frame = CGRect(x: 0, y: 0, width: 768, height: 1024)
        self.scrollView.contentSize = CGSize.init(width: CGFloat(categoryCount*768), height: self.scrollView.frame.size.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.delegate = self
        
        for idx in 0...(Cache_Task_On?.inspSections.count)!-1 {
            
            let indexPoint = CustomButton()
            indexPoint.frame = CGRect.init(x: 743+(idx-categoryCount+1)*35, y: 76, width: 25, height: 25)
            //indexPoint.addTarget(self, action: #selector(InspectionViewInput.indexPointOnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            indexPoint.tag = idx
            indexPoint.setTitle(String(idx+1), for: UIControl.State())
            indexPoint.setTitleColor(_BTNTITLECOLOR, for: UIControl.State())
            indexPoint.backgroundColor = _FOSSILYELLOWCOLOR
            indexPoint.layer.cornerRadius = _CORNERRADIUS
            indexPoint.alpha = inactiveAlpha
        
            indexPoints.append(indexPoint)
            self.addSubview(indexPoint)
        }
    }
    
    func initInspView(_ currentPage:Int=0) {
        
        self.currentPage = currentPage
        let idx = self.currentPage
        
        if self.currentPage < Cache_Task_On!.inspSections.count && !self.activedPageIds.contains(idx) {
            DispatchQueue.main.async(execute: {
                self.showActivityIndicator()
                
                DispatchQueue.main.async(execute: {
                    self.removeActivityIndicator()
                    
                    self.initInspViewProcess(self.currentPage)
                    
                    if self.currentPage < 1 {
                        self.initInspViewProcess(1)
                    } else if self.currentPage < Cache_Task_On!.inspSections.count {
                        self.initInspViewProcess(self.currentPage - 1)
                        self.initInspViewProcess(self.currentPage + 1)
                    } else {
                        self.initInspViewProcess(self.currentPage - 1)
                    }
                    
                })
            })
        }
    }
    
    func initInspViewProcess(_ page:Int=0) {
        let idx = page
        
        if page < Cache_Task_On!.inspSections.count && !self.activedPageIds.contains(idx) {
        
            let section = Cache_Task_On!.inspSections[idx]
            let inputMode = section.inputModeCode
            
            switch inputMode! {
            case _INPUTMODE01:
                let inputview = InputMode01View.loadFromNibNamed("InputMode01")!
                inputview.idx = idx
                inputview.categoryIdx = section.sectionId!
                inputview.inspSection = section
                inputview.categoryName = _ENGLISH ? section.sectionNameEn! : section.sectionNameCn!
                inputview.InputMode = inputMode!
                
                inputview.frame = CGRect.init(x: idx*768, y: 0, width: 768, height: Int((inputview.frame.size.height) + 500))
                self.scrollView.addSubview(inputview)
                self.pVC?.categoriesDetail.append(inputview)
            case _INPUTMODE02:
                let inputview = InputMode02View.loadFromNibNamed("InputMode02")!
                inputview.idx = idx
                inputview.categoryIdx = section.sectionId!
                inputview.inspSection = section
                inputview.categoryName = _ENGLISH ? section.sectionNameEn! : section.sectionNameCn!
                inputview.InputMode = inputMode!
                
                inputview.frame = CGRect.init(x: idx*768, y: 0, width: 768, height: Int((inputview.frame.size.height) + 500))
                self.scrollView.addSubview(inputview)
                self.pVC?.categoriesDetail.append(inputview)
            case _INPUTMODE03:
                let inputview = InputMode03View.loadFromNibNamed("InputMode03")!
                inputview.idx = idx
                inputview.categoryIdx = section.sectionId!
                inputview.inspSection = section
                inputview.categoryName = _ENGLISH ? section.sectionNameEn! : section.sectionNameCn!
                inputview.InputMode = inputMode!
                
                inputview.frame = CGRect.init(x: idx*768, y: 0, width: 768, height: Int((inputview.frame.size.height) + 500))
                self.scrollView.addSubview(inputview)
                self.pVC?.categoriesDetail.append(inputview)
            case _INPUTMODE04:
                let inputview = InputMode04View.loadFromNibNamed("InputMode04")!
                inputview.idx = idx
                inputview.categoryIdx = section.sectionId!
                inputview.categoryName = _ENGLISH ? section.sectionNameEn! : section.sectionNameCn!
                inputview.inspSection = section
                inputview.InputMode = inputMode!
                
                inputview.frame = CGRect.init(x: idx*768, y: 0, width: 768, height: Int((inputview.frame.size.height) + 500))
                self.scrollView.addSubview(inputview)
                self.pVC?.categoriesDetail.append(inputview)
            default:break
            }
            
            self.activedPageIds.append(page)
            self.disableAllFunsForView(self)
            self.pVC?.refreshCameraIcon()
        }
    }
    
    func updateSectionHeader(_ currentPage:Int = 0) {
        if currentPage < Cache_Task_On?.inspSections.count, let title = _ENGLISH ? Cache_Task_On?.inspSections[currentPage].sectionNameEn : Cache_Task_On?.inspSections[currentPage].sectionNameCn {
            self.pVC.updateNavigationTitle(title: title)
            (self.pVC! as TaskDetailsViewController).inspCatText = title
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        currentPage = Int(scrollView.contentOffset.x / 768)
        ActiveIndexPointStatus(currentPage)
        updateSectionHeader(currentPage)
        
        self.lastContentOffset = scrollView.contentOffset.x
    }
    
    func ActiveIndexPointStatus(_ currentPage:Int = 0) {
        
        for indexPoint in indexPoints {
            indexPoint.alpha = inactiveAlpha
        }
        
        initInspView(currentPage)
        
        if currentPage < indexPoints.count {
            indexPoints[currentPage].alpha = activeAlpha
        }
    }
    
    func indexPointOnClick(_ sender:UIButton) {
        
        //let offset = CGFloat(sender.tag)*768
        scrollToPosition(sender.tag)
        
    }
    
    func scrollToPosition(/*offset:CGFloat,*/_ currentPage:Int, animation:Bool = true) {
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(currentPage)*768, y: 0), animated: animation)
        self.currentPage = currentPage
        ActiveIndexPointStatus(self.currentPage)
        updateSectionHeader(self.currentPage)
    }
    
    @IBAction func backBarBtnOnClick(_ sender: UIBarButtonItem) {
        self.parentVC?.navigationController?.popViewController(animated: false)
    }
    
    
}
