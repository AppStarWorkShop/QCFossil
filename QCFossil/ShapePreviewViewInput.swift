//
//  ShapePreviewViewInput.swift
//  QCFossil
//
//  Created by Yin Huang on 22/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class ShapePreviewViewInput: UIView {
    var parentView:UIView!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override func awakeFromNib() {
        /*
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 100, height: 50))
        cancelBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        cancelBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: #selector(ShapePreviewViewInput.shapeSelectOnClick), forControlEvents: UIControlEvents.TouchUpInside)
        self.setButtonCornerRadius(cancelBtn)
 
        self.addSubview(cancelBtn)
        */
        
    }
    
    override func didMoveToSuperview() {
        if (self.parentVC == nil) {
            return
        }
        
        let shapeView1 = ShapeView(origin: self.parentView.center, shapeType: 1, shapeSize: 105)
        shapeView1.frame = CGRect(x: 10, y: 20, width: 110, height: 110)
        shapeView1.isUserInteractionEnabled = false
        self.addSubview(shapeView1)
        
        let shapeView2 = ShapeView(origin: self.parentView.center, shapeType: 2, shapeSize: 105)
        shapeView2.frame = CGRect(x: 120, y: 20, width: 110, height: 110)
        shapeView2.isUserInteractionEnabled = false
        self.addSubview(shapeView2)
        
        let shapeView3 = ShapeView(origin: self.parentView.center, shapeType: 3, shapeSize: 105)
        shapeView3.frame = CGRect(x: 230, y: 20, width: 110, height: 110)
        shapeView3.isUserInteractionEnabled = false
        self.addSubview(shapeView3)
        
        let shapeView4 = ShapeView(origin: self.parentView.center, shapeType: 0, shapeSize: 105)
        shapeView4.frame = CGRect(x: 10, y: 140, width: 110, height: 110)
        shapeView4.isUserInteractionEnabled = false
        self.addSubview(shapeView4)
        
        let shapeView5 = ShapeView(origin: self.parentView.center, shapeType: 6, shapeSize: 105)
        shapeView5.frame = CGRect(x: 120, y: 140, width: 110, height: 110)
        shapeView5.isUserInteractionEnabled = false
        self.addSubview(shapeView5)
        
        let shapeView6 = ShapeView(origin: self.parentView.center, shapeType: 9, shapeSize: 105)
        shapeView6.frame = CGRect(x: 230, y: 140, width: 110, height: 110)
        shapeView6.isUserInteractionEnabled = false
        self.addSubview(shapeView6)
        
        let shapeView7 = ShapeView(origin: self.parentView.center, shapeType: 10, shapeSize: 105)
        shapeView7.frame = CGRect(x: 10, y: 260, width: 110, height: 110)
        shapeView7.isUserInteractionEnabled = false
        self.addSubview(shapeView7)
        /*
        let shapeView8 = ShapeView(origin: self.parentView.center, shapeType: 8, shapeSize: 105)
        shapeView8.frame = CGRect(x: 110, y: 260, width: 110, height: 110)
        shapeView8.userInteractionEnabled = false
        self.addSubview(shapeView8)
        
        let shapeView9 = ShapeView(origin: self.parentView.center, shapeType: 9, shapeSize: 105)
        shapeView9.frame = CGRect(x: 220, y: 260, width: 110, height: 110)
        shapeView9.userInteractionEnabled = false
        self.addSubview(shapeView9)
         */
    }
    
    func shapeSelectOnClick() {
        
        let shapeView = ShapeView(origin: self.parentView.center, shapeType: 1)
        self.parentView.addSubview(shapeView)
        
    }
    
    @IBAction func ShapeOnClick(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 1)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        case 2:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 2)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        case 3:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 3)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        case 4:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 0)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        case 5:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 6)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        case 6:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 9)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        case 7:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 10)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        case 8:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 8)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        case 9:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 9)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
            break
        default:
            let shapeView = ShapeView(origin: CGPoint(x: self.parentView.center.x - 100, y: self.parentView.center.y - 100), shapeType: 0)
            shapeView.tag = _SHAPEVIEWTAG
            (self.parentView as! ImagePreviewViewInput).imageView.addSubview(shapeView)
        }
        
        self.parentVC!.dismiss(animated: true, completion: nil)
    }
    
    
}
