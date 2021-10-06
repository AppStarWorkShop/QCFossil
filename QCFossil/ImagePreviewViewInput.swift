//
//  ImagePreviewViewInput.swift
//  QCFossil
//
//  Created by Yin Huang on 21/2/16.
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ImagePreviewViewInput: UIView, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var BackgroundView: UIView!
    weak var parentView:UIView?
    weak var parentImageView:UIImageView?
    weak var parentDefectItem:InputModeDFMaster2?
    var imageName:String?
    var photoIndex:Int?
    var inactiveAlpha:CGFloat = 0.2
    var totalScale:CGFloat = 1.0
    var scrollView:UIScrollView?
    var previewOnly = false
    
    @IBOutlet weak var imageView: SignoffView!
    @IBOutlet weak var closeBtn: CustomButton!
    
    //Edit Tools
    @IBOutlet weak var brushColorRed: CustomButton!
    @IBOutlet weak var brushColorBlue: CustomButton!
    @IBOutlet weak var brushColorGreen: CustomButton!
    @IBOutlet weak var brushColorYellow: CustomButton!
    @IBOutlet weak var brushClearBtn: CustomButton!
    @IBOutlet weak var saveImageBtn: CustomButton!
    @IBOutlet weak var startEditBtn: CustomButton!
    @IBOutlet weak var brushSize_s: CustomButton!
    @IBOutlet weak var brushSize_m: CustomButton!
    @IBOutlet weak var brushSize_l: CustomButton!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        imageView.setBrushStyle(CGFloat(_BRUSHSTYLE["red"]!), green: CGFloat(_BRUSHSTYLE["green"]!), blue: CGFloat(_BRUSHSTYLE["blue"]!), brush: CGFloat(_BRUSHSTYLE["brush"]!))
        updateLocalizeString()
        
        self.clipsToBounds = true
    }
    
    func updateLocalizeString() {
        self.startEditBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Edit"), for: UIControl.State())
        self.closeBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Close")+" X", for: UIControl.State())
        self.saveImageBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), for: UIControl.State())
        
        updateBrushColor()
        updateBrushSize()
    }
    
    func updateBrushSize() {
        if _BRUSHSTYLE["brush"] > 5 {
            self.brushSize_l.alpha = 1.0
            self.brushSize_s.alpha = inactiveAlpha
            self.brushSize_m.alpha = inactiveAlpha
        }else if _BRUSHSTYLE["brush"] > 3 {
            self.brushSize_m.alpha = 1.0
            self.brushSize_s.alpha = inactiveAlpha
            self.brushSize_l.alpha = inactiveAlpha
        }else{
            self.brushSize_s.alpha = 1.0
            self.brushSize_m.alpha = inactiveAlpha
            self.brushSize_l.alpha = inactiveAlpha
        }
    }
    
    func updateBrushColor() {
        if _BRUSHSTYLE["red"] > 250 {
            self.brushColorRed.alpha = 1.0
            self.brushColorBlue.alpha = inactiveAlpha
            self.brushColorGreen.alpha = inactiveAlpha
            self.brushColorYellow.alpha = inactiveAlpha
        }else if _BRUSHSTYLE["blue"] > 250 {
            self.brushColorBlue.alpha = 1.0
            self.brushColorRed.alpha = inactiveAlpha
            self.brushColorGreen.alpha = inactiveAlpha
            self.brushColorYellow.alpha = inactiveAlpha
        }else if _BRUSHSTYLE["green"] > 250 {
            self.brushColorGreen.alpha = 1.0
            self.brushColorBlue.alpha = inactiveAlpha
            self.brushColorRed.alpha = inactiveAlpha
            self.brushColorYellow.alpha = inactiveAlpha
        }else{
            self.brushColorYellow.alpha = 1.0
            self.brushColorBlue.alpha = inactiveAlpha
            self.brushColorGreen.alpha = inactiveAlpha
            self.brushColorRed.alpha = inactiveAlpha
        }
    }
    
    func setEnableEditing(_ enable:Bool) {
        self.brushClearBtn.isHidden = enable
        self.brushColorBlue.isHidden = enable
        self.brushColorGreen.isHidden = enable
        self.brushColorRed.isHidden = enable
        self.brushColorYellow.isHidden = enable
        self.brushSize_s.isHidden = enable
        self.brushSize_m.isHidden = enable
        self.brushSize_l.isHidden = enable
        self.saveImageBtn.isHidden = enable
        self.imageView.isUserInteractionEnabled = !enable
    }

    override func didMoveToSuperview() {
        setEnableEditing(true)
        
        if previewOnly {
            guard let imageView = self.imageView else {return}
            
            imageView.previewOnly = true
            
            scrollView?.minimumZoomScale = 1.0
            scrollView?.maximumZoomScale = 3.0
            scrollView?.zoomScale = 1.0
            scrollView?.bouncesZoom = true
            scrollView?.contentSize = CGSize(width: 600, height: 800)
            scrollView?.delegate = self
        }
    }
    
    @IBAction func startEditOnClick(_ sender: UIButton) {
        /*if self.disableFuns(self) {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Confirmed or Cancelled Task!"))
            return
        }*/
        
        if sender.tag < 1 {
            sender.setTitle("+", for: UIControl.State())
            sender.tag = 1
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            setEnableEditing(false)
            
        }else{
            
            let popoverContent = PopoverViewController()
            popoverContent.preferredContentSize = CGSize(width: 320, height: 350 + _NAVIBARHEIGHT)//CGSizeMake(320,/*240 + _NAVIBARHEIGHT*/350 + _NAVIBARHEIGHT)
//            popoverContent.view.translatesAutoresizingMaskIntoConstraints = false
            popoverContent.parentTextFieldView = nil
            popoverContent.sourceType = _SHAPEPREVIEWTYPE
            popoverContent.dataType = _SHAPEDATATYPE
            popoverContent.parentView = self
            
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            nav.navigationBar.barTintColor = UIColor.white
            if #available(iOS 13.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                navBarAppearance.backgroundColor = .black
                nav.navigationBar.standardAppearance = navBarAppearance
                nav.navigationBar.scrollEdgeAppearance = navBarAppearance
            }
            
            let popover = nav.popoverPresentationController
            popover!.delegate = self
            popover!.sourceView = sender //sender.parentVC?.view
            popover!.sourceRect = CGRect(x: sender.frame.minX,y: sender.frame.minY,width: sender.frame.size.width,height: sender.frame.size.height)
            
            sender.parentVC!.present(nav, animated: true, completion: nil)
            
        }
    }

    @IBAction func closeBtnOnClick(_ sender: CustomButton) {
        if (self.parentView != nil) {
            self.parentView!.removeFromSuperview()
        }
    }
    
    @IBAction func saveBtnOnClick(_ sender: CustomButton) {
        self.imageView.image = UIImage.init(view: self.imageView)
        let endEditImage = imageView.saveEndEditImage(imageView.image!)
        //let endEditImageView = UIImageView.init(image: UIImage.init(view: self.imageView))
        let endEditImageView = UIImageView.init(image: endEditImage)
        
        //Update photo to local
        if self.photoIndex >= 0 {
            let photoName = self.parentDefectItem?.photoNameAtIndex[self.photoIndex!]
            var photo = Photo.init(photo: endEditImageView, photoFilename: photoName!, taskId: Cache_Task_On!.taskId!, photoFile: photoName!)
            let photoDataHelper = PhotoDataHelper()
            photo?.photoId = photoDataHelper.getPhotoIdByPhotoName(photoName!)
            
            photo = self.parentDefectItem!.savePhotoToLocal(photo!) //self.parentDefectItem?.savePhotoToLocal(photo!)
            
            //Update photo
            let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName!
            self.parentImageView?.image = UIImage(contentsOfFile: pathForImage)
        }
        
        self.imageView.subviews.forEach({if $0.tag == _SHAPEVIEWTAG {$0.removeFromSuperview()} })
    }

    @IBAction func clearBtnOnClick(_ sender: CustomButton) {
        //imageDrawView.image = nil
        //Use the Regular Size Image
        let path = Cache_Task_Path!+"/"+imageName!
        imageView.image = UIImage(contentsOfFile: path)
        
        self.imageView.subviews.forEach({if $0.tag == _SHAPEVIEWTAG {$0.removeFromSuperview()} })
    }
    
    @IBAction func setBrushStyle(_ sender: CustomButton) {
    
        switch sender.tag {
            case 1://red brush
                _BRUSHSTYLE["red"] = 255.0
                _BRUSHSTYLE["green"] = 0.0
                _BRUSHSTYLE["blue"] = 0.0
            
            case 2://blue brush
                _BRUSHSTYLE["red"] = 0.0
                _BRUSHSTYLE["green"] = 0.0
                _BRUSHSTYLE["blue"] = 255.0
            
            case 3://green brush
                _BRUSHSTYLE["red"] = 0.0
                _BRUSHSTYLE["green"] = 255.0
                _BRUSHSTYLE["blue"] = 0.0
            
            case 4://yellow brush
                _BRUSHSTYLE["red"] = 125.0
                _BRUSHSTYLE["green"] = 125.0
                _BRUSHSTYLE["blue"] = 0.0
            
            case 5://bigger brush
                _BRUSHSTYLE["brush"] = 6
            case 6://smaller brush
                _BRUSHSTYLE["brush"] = 4
            case 7://smaller brush
                _BRUSHSTYLE["brush"] = 2
            default://red brush
                _BRUSHSTYLE["red"] = 255.0
                _BRUSHSTYLE["green"] = 0.0
                _BRUSHSTYLE["blue"] = 0.0
        }
        
        updateBrushSize()
        updateBrushColor()
        imageView.setBrushStyle(CGFloat(_BRUSHSTYLE["red"]!), green: CGFloat(_BRUSHSTYLE["green"]!), blue: CGFloat(_BRUSHSTYLE["blue"]!), brush: CGFloat(_BRUSHSTYLE["brush"]!))
    }
}

extension ImagePreviewViewInput {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if (self.scrollView?.zoomScale > 1) {
            imageView.center = CGPoint(x: self.scrollView!.contentSize.width / 2, y: self.scrollView!.contentSize.height / 2)
        }
        else {
            imageView.center = self.scrollView?.center ?? self.center
        }
    }
}
