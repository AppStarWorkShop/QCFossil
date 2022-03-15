//
//  PopoverViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 13/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    //var pVC = TaskTypeViewController()
    var parentView:UIView!
    weak var parentTextFieldView:UITextField!
    var inputview = PopoverViewsInput()
    var calenderview = CalenderPickerViewInput()
    var shapepreview = ShapePreviewViewInput()
    var sourceType:String!
    var dataType:String! = _POPOVERDATATPYE
    var selectedValue:String = ""
    var didPickCompletion:(()->(Void))?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if dataType == _POPOVERDATETPYE {
            calenderview = CalenderPickerViewInput.loadFromNibNamed("CalenderPickerView")!
            calenderview.translatesAutoresizingMaskIntoConstraints = false
            calenderview.frame = CGRect(x: 20, y: _NAVIBARHEIGHT + 20, width: 325, height: 350+_NAVIBARHEIGHT+20)
            self.view.addSubview(calenderview)
            
        }else if dataType == _POPOVERPRODDESC {
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Prod Desc")
            
            var descView = UITextView.init(frame: CGRect(x: 0,y: 0,width: 325,height: 500))
            if #available(iOS 13.0, *) {
                descView = UITextView.init(frame: CGRect(x: 0,y: _NAVIBARHEIGHT,width: 325,height: 500))
            }
            descView.text = selectedValue
            descView.isUserInteractionEnabled = false
            
            self.view.addSubview(descView)
            
        }else if dataType == _POPOVERPOPDRSD {
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD")
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: _NAVIBARHEIGHT, width: 325, height: 150+_NAVIBARHEIGHT))
            scrollView.contentSize = CGSize.init(width: 325, height: 150+_NAVIBARHEIGHT)
            
            self.view.addSubview(scrollView)
            
            let poItemString = selectedValue
            let poItemNames = poItemString.characters.split{$0 == ","}.map(String.init)
            
            if poItemNames.count>0 {
                for idx in 0...poItemNames.count-1 {
                    
                    let poItem = UILabel.init(frame: CGRect(x: 10,y: idx*20+10,width: 325,height: 21))
                    //poItem.font = UIFont(name: "", size: 30)
                    poItem.text = poItemNames[idx]
                    
                    scrollView.addSubview(poItem)
                }
                
                let newHeight:CGFloat = CGFloat(poItemNames.count*21)
                scrollView.contentSize = CGSize.init(width: 325, height: newHeight+_NAVIBARHEIGHT)
            }
            
            let rightButton=UIBarButtonItem()
            rightButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Close")
            rightButton.tintColor = UIColor.black
            rightButton.style=UIBarButtonItem.Style.plain
            rightButton.target=self
            rightButton.action=#selector(PopoverViewController.cancelPick)
            self.navigationItem.rightBarButtonItem=rightButton
            
            return
        }else if dataType == _POPOVERTASKSTATUSDESC {
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Refused")
            
            let descView = UITextView.init(frame: CGRect(x: 0,y: _NAVIBARHEIGHT + 20,width: 325,height: 500))
            descView.text = selectedValue
            descView.isUserInteractionEnabled = false 
            
            self.view.addSubview(descView)
            
        }else if dataType == _POPOVERPOITEMTYPE || dataType == _POPOVERPOITEMTYPESHIPWIN {
            if dataType == _POPOVERPOITEMTYPE {
                self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO List/Material")
            }else{
                self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("SW/Req. Ex-fty Date")
            }
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: _NAVIBARHEIGHT, width: 325, height: 150+_NAVIBARHEIGHT))
            scrollView.contentSize = CGSize.init(width: 325, height: 150+_NAVIBARHEIGHT)
            
            self.view.addSubview(scrollView)
            
            let poItemString = selectedValue
            let poItemNames = poItemString.characters.split{$0 == ","}.map(String.init)
            
            if poItemNames.count>0 {
                for idx in 0...poItemNames.count-1 {
            
                    let poItem = UILabel.init(frame: CGRect(x: 10,y: idx*20+10,width: 325,height: 21))
                    //poItem.font = UIFont(name: "", size: 30)
                    poItem.text = poItemNames[idx]
            
                    scrollView.addSubview(poItem)
                }
                
                let newHeight:CGFloat = CGFloat(poItemNames.count*21)
                scrollView.contentSize = CGSize.init(width: 325, height: newHeight+_NAVIBARHEIGHT)
            }
            
            let rightButton=UIBarButtonItem()
            rightButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Close")
            rightButton.tintColor = UIColor.black
            rightButton.style=UIBarButtonItem.Style.plain
            rightButton.target=self
            rightButton.action=#selector(PopoverViewController.cancelPick)
            self.navigationItem.rightBarButtonItem=rightButton
            
            return
        }else if dataType == _SHAPEDATATYPE {
            shapepreview = ShapePreviewViewInput.loadFromNibNamed("ShapePreviewView")!
            shapepreview.frame = CGRect(x: 10, y: _NAVIBARHEIGHT, width: 350, /*220+_NAVIBARHEIGHT*/height: 350+_NAVIBARHEIGHT)
            shapepreview.parentView = self.parentView
            self.view.addSubview(shapepreview)
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Shape Types")
            
            let rightButton=UIBarButtonItem()
            rightButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Close")
            rightButton.tintColor = UIColor.black
            rightButton.style=UIBarButtonItem.Style.plain
            rightButton.target=self
            rightButton.action=#selector(PopoverViewController.cancelPick)
            self.navigationItem.rightBarButtonItem=rightButton
            
            return
        }else if dataType == _DEFECTPPDESC {
        
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Point(s)")
            self.automaticallyAdjustsScrollViewInsets = false
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: _NAVIBARHEIGHT+20, width: 325, height: 150+_NAVIBARHEIGHT))
            scrollView.contentSize = CGSize.init(width: 325, height: 150+_NAVIBARHEIGHT)
            
            self.view.addSubview(scrollView)
            
            let poItemString = selectedValue
            let poItemNames = poItemString.characters.split{$0 == ","}.map(String.init)
            
            if poItemNames.count>0 {
                for idx in 0...poItemNames.count-1 {
                    
                    let poItem = UILabel.init(frame: CGRect(x: 10,y: idx*20+10,width: 325,height: 21))
                    
                    if idx < 1 {
                        poItem.text = "\((idx+1)).  \(poItemNames[idx])"
                    }else{
                        poItem.text = "\((idx+1)). \(poItemNames[idx])"
                    }
                    
                    scrollView.addSubview(poItem)
                }
                
                let newHeight:CGFloat = CGFloat(poItemNames.count*21)
                scrollView.contentSize = CGSize.init(width: 325, height: newHeight+_NAVIBARHEIGHT)
            }
            
            return
        }else if dataType == _POPOVERNOTITLE {
            if let nav = self.parent as? UINavigationController {
                nav.setNavigationBarHidden(true, animated: false)
            }
            
            let descView = UITextView()// UITextView.init(frame: CGRect(x: 0,y: 0,width: 325,height: 500))
            descView.translatesAutoresizingMaskIntoConstraints = false
            descView.text = selectedValue
            descView.isUserInteractionEnabled = false
            descView.font = UIFont.systemFont(ofSize: 18.0)
            
            self.view.addSubview(descView)
            if #available(iOS 11.0, *) {
                descView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
                descView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
                descView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
                descView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            } else {
                descView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                descView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                descView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                descView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            }
            return
        } else if dataType == _DOWNLOADTASKSTATUSDESC {
            if let nav = self.parent as? UINavigationController {
                nav.setNavigationBarHidden(true, animated: false)
            }
            
            let descView = UITextView.init(frame: CGRect(x: 0,y: 0,width: 640, height: 320))
            descView.text = selectedValue
            descView.isUserInteractionEnabled = true
            descView.font = UIFont.systemFont(ofSize: 18.0)
            self.view.addSubview(descView)
        
        } else{
            inputview = PopoverViewsInput.loadFromNibNamed("PopoverViews")!
            inputview.initData(sourceType)
            inputview.addSubview((inputview.typeSelection)!)
            self.view.addSubview(inputview)
            inputview.typeSelection.translatesAutoresizingMaskIntoConstraints = false
            inputview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                inputview.typeSelection.centerXAnchor.constraint(equalTo: inputview.centerXAnchor),
                inputview.typeSelection.centerYAnchor.constraint(equalTo: inputview.centerYAnchor),
                inputview.typeSelection.heightAnchor.constraint(equalTo: inputview.heightAnchor),
                inputview.typeSelection.widthAnchor.constraint(equalTo: inputview.widthAnchor),

                inputview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                inputview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                inputview.topAnchor.constraint(equalTo: view.topAnchor),
                inputview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            
        }
        
        let leftButton=UIBarButtonItem()
        leftButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel")
        leftButton.tintColor = UIColor.white
        leftButton.style=UIBarButtonItem.Style.plain
        leftButton.target=self
        leftButton.action=#selector(PopoverViewController.cancelPick)
        self.navigationItem.leftBarButtonItem=leftButton
        
        let rightButton=UIBarButtonItem()
        rightButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
        rightButton.tintColor = UIColor.white
        rightButton.style=UIBarButtonItem.Style.plain
        rightButton.target=self
        rightButton.action=#selector(PopoverViewController.didPick)
        self.navigationItem.rightBarButtonItem=rightButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func cancelPick() {
        print("cancel pick")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didPick() {
        print("did pick: \(self.selectedValue)")
        //pVC.productType.text = self.inputview.selectedValue
        
        parentTextFieldView?.text = selectedValue
        
        /*if self.selectedValue != nil {
            setValueBySourceType(sourceType, selectedValue: self.selectedValue)
        }*/
        self.didPickCompletion?()
        
        self.dismiss(animated: true, completion: nil)
    }
}
