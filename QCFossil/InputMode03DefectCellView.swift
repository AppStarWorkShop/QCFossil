//
//  InputMode03DefectCellView.swift
//  QCFossil
//
//  Created by Yin Huang on 20/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputMode03DefectCellView: InputModeDFMaster2, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var icLabel: UILabel!
    @IBOutlet weak var icInput: UITextField!
    @IBOutlet weak var iiLabel: UILabel!
    @IBOutlet weak var iiInput: UITextField!
    @IBOutlet weak var ddLabel: UILabel!
    @IBOutlet weak var ddInput: UITextField!
    @IBOutlet weak var dfQtyLabel: UILabel!
    @IBOutlet weak var dfQtyInput: UITextField!
    @IBOutlet weak var addDescButton: UIButton!
    @IBOutlet weak var dismissDescButton: UIButton!
    @IBOutlet weak var defectPhoto1: UIImageView!
    @IBOutlet weak var defectPhoto2: UIImageView!
    @IBOutlet weak var defectPhoto3: UIImageView!
    @IBOutlet weak var defectPhoto4: UIImageView!
    @IBOutlet weak var defectPhoto5: UIImageView!
    @IBOutlet weak var dismissPhotoButton1: CustomButton!
    @IBOutlet weak var dismissPhotoButton2: CustomButton!
    @IBOutlet weak var dismissPhotoButton3: CustomButton!
    @IBOutlet weak var dismissPhotoButton4: CustomButton!
    @IBOutlet weak var dismissPhotoButton5: CustomButton!
    
    weak var pVC:DefectListViewController!
    //weak var inspItem = InputMode03CellView()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    

    override func awakeFromNib() {
        defectPhoto1.image = nil
        defectPhoto2.image = nil
        defectPhoto3.image = nil
        defectPhoto4.image = nil
        defectPhoto5.image = nil
        
        dismissPhotoButton1.isHidden = true
        dismissPhotoButton2.isHidden = true
        dismissPhotoButton3.isHidden = true
        dismissPhotoButton4.isHidden = true
        dismissPhotoButton5.isHidden = true
        
        self.dfQtyInput.delegate = self
        
        updateLocalizedString()
    }
    
    func updateLocalizedString(){
        self.icLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Category")
        self.iiLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Item")
        self.ddLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Description")
        self.dfQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Qty")
    }
    
    @IBAction func addDefectPhotoButton(_ sender: CustomButton) {
        print("add Cell photo")
        
        if self.defectPhoto1.image != nil && self.defectPhoto2.image != nil && self.defectPhoto3.image != nil && self.defectPhoto4.image != nil && self.defectPhoto5.image != nil {
            
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        let sheet:UIActionSheet = UIActionSheet()
        let title:String = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please choose a source")
        sheet.title = title
        sheet.delegate = self
        sheet.addButton(withTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"))
        sheet.addButton(withTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Add from Photo Library"))
        sheet.addButton(withTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Add from Camera"))
        sheet.addButton(withTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Add from Photo Album"))
        sheet.cancelButtonIndex = 0
        sheet.show(in: self)
        
    }
    
    func actionSheet(_ sheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        NSLog("index %d %@", buttonIndex, sheet.buttonTitle(at: buttonIndex)!)
        
        if buttonIndex < 1 {
            return
        }
        
        if buttonIndex > 2 {
            //self.pVC?.currentCell = self
            self.pVC?.performSegue(withIdentifier: "PhotoAlbumSegueFromDF", sender: self)
        }else{
            
            var imagePicker:UIImagePickerController!
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary
            if buttonIndex > 1 {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePicker.sourceType = .camera
                }
            }
            
            OperationQueue.main.addOperation() {
                self.pVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.pVC!.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dismissDfPhotoButton(_ sender: CustomButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Photo?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
         
        self.defectPhoto1.image = nil
        self.dismissPhotoButton1.isHidden = true
        self.defectPhoto2.image = nil
        self.dismissPhotoButton2.isHidden = true
        self.defectPhoto3.image = nil
        self.dismissPhotoButton3.isHidden = true
        self.defectPhoto4.image = nil
        self.dismissPhotoButton4.isHidden = true
        self.defectPhoto5.image = nil
        self.dismissPhotoButton5.isHidden = true
            
        self.clearDefectPhotoDataAtIndex(sender.tag-1)
        self.refreshPhotos()
        var idx = 1
        for photo in self.photos {
            if photo?.photo != nil {
                if self.defectPhoto1.image == nil {
                    self.defectPhoto1.image = photo?.photo?.image
                    self.dismissPhotoButton1.isHidden = false
                    
                }else if self.defectPhoto2.image == nil {
                    self.defectPhoto2.image = photo?.photo?.image
                    self.dismissPhotoButton2.isHidden = false
                    
                }else if self.defectPhoto3.image == nil {
                    self.defectPhoto3.image = photo?.photo?.image
                    self.dismissPhotoButton3.isHidden = false
                    
                }else if self.defectPhoto4.image == nil {
                    self.defectPhoto4.image = photo?.photo?.image
                    self.dismissPhotoButton4.isHidden = false
                    
                }else if self.defectPhoto5.image == nil {
                    self.defectPhoto5.image = photo?.photo?.image
                    self.dismissPhotoButton5.isHidden = false
                    
                }
            }
            idx += 1
        }
        
        //Update InspItem PhotoAdded Status
        if self.defectPhoto1.image == nil && self.defectPhoto2.image == nil && self.defectPhoto3.image == nil && self.defectPhoto4.image == nil && self.defectPhoto5.image == nil {
            self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "no"))
        }
        
        let defectsByItemId = self.pVC?.defectCells.filter({$0.sectionId == self.sectionId && $0.itemId == self.itemId && self.cellIdx>=0})
        let ifPhotoAdded = defectsByItemId!.filter({($0 as! InputMode03DefectCellView).photoAdded == String(describing: PhotoAddedStatus.init(caseId: "yes"))})
        
        if ifPhotoAdded.count<1 {
            self.updatePhotoAddedStatus("no")
        }
 
        })
    }
    
    @IBAction func addDefectCellButton(_ sender: UIButton) {
        print("add cell")
        
        if self.icInput.text == "" || self.iiInput.text == "" {
            self.alertView("Please select the Inspect Category & fill in the Inspect Item!")
            return
        }
        
        self.pVC!.addDefectCellWithSection(_INPUTMODE03, idxLabel: indexLabel.text!,iaLabel: icLabel.text!,iiLabel: iiInput.text!,sectionId: sectionId,itemId: itemId, inspItem: inspItem!)
    }
    
    @IBAction func dismissDefectCellButton(_ sender: UIButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Defect Item?"),parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
            self.updatePhotoAddedStatus("no")
            self.removeDefectCell()
        })
    }
    
    override func removeDefectCell() {
        let idx = self.pVC?.defectCells.index(where: {$0.cellIdx==self.cellIdx && $0.itemId==self.itemId && $0.sectionId==self.sectionId})
        /*
        if idx >= 0 {
            self.pVC?.defectCells.removeAtIndex(idx!)
            self.removeFromSuperview()
            self.pVC?.updateContentView()
            
            for idx in 0...self.photos.count-1 {
                clearDefectPhotoDataAtIndex(idx)
            }
            
            //Delete Record From DB
            if self.taskDefectDataRecordId > 0 {
                self.deleteTaskInspDefectDataRecord(self.taskDefectDataRecordId!)
            }
        }*/
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        NSLog("Image Pick")
        
        picker.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let imageView = UIImageView.init(image: image)
                let photo = Photo(photo: imageView, photoFilename: "", taskId: (Cache_Task_On?.taskId)!, photoFile: "")
                self.setSelectedPhoto(photo!)
            }
        })
    }
    
    override func setSelectedPhoto(_ photo:Photo, needSave:Bool=true) {
        if defectPhoto1.image == nil {
            let resizePhoto = updateDefectPhotoData(0, photo: photo, needSave: needSave)
            defectPhoto1.image = resizePhoto!.photo?.image
            dismissPhotoButton1.isHidden = false
            
        }else if defectPhoto2.image == nil {
            let resizePhoto = updateDefectPhotoData(1, photo: photo, needSave: needSave)
            defectPhoto2.image = resizePhoto!.photo?.image
            dismissPhotoButton2.isHidden = false
            
        }else if defectPhoto3.image == nil {
            let resizePhoto = updateDefectPhotoData(2, photo: photo, needSave: needSave)
            defectPhoto3.image = resizePhoto!.photo?.image
            dismissPhotoButton3.isHidden = false
            
        }else if defectPhoto4.image == nil {
            let resizePhoto = updateDefectPhotoData(3, photo: photo, needSave: needSave)
            defectPhoto4.image = resizePhoto!.photo?.image
            dismissPhotoButton4.isHidden = false
            
        }else if defectPhoto5.image == nil {
            let resizePhoto = updateDefectPhotoData(4, photo: photo, needSave: needSave)
            defectPhoto5.image = resizePhoto!.photo?.image
            dismissPhotoButton5.isHidden = false
            
        }
        
        //Update InspItem PhotoAdded Status
        self.photoAdded = String(describing: PhotoAddedStatus.init(caseId: "yes"))
        updatePhotoAddedStatus("yes")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadPhotos"), object: nil, userInfo: ["photoSelected":photo])
    }
    
    func updatePhotoAddedStatus(_ newStatus:String) {
        if newStatus == "yes" {
            (self.inspItem as! InputMode03CellView).photoAdded = true
        }else{
            (self.inspItem as! InputMode03CellView).photoAdded = false
        }
        
        (self.inspItem as! InputMode03CellView).updatePhotoAddediConStatus("",photoTakenIcon: (self.inspItem as! InputMode03CellView).photoTakenIcon)
    }
    
    func saveDefectPhotos() {
        if defectPhoto1.image != nil {
            savePhotoToLocal(self.photos[0]!)
        }else if defectPhoto2.image != nil {
            savePhotoToLocal(self.photos[1]!)
        }else if defectPhoto3.image != nil {
            savePhotoToLocal(self.photos[2]!)
        }else if defectPhoto4.image != nil {
            savePhotoToLocal(self.photos[3]!)
        }else if defectPhoto5.image != nil {
            savePhotoToLocal(self.photos[4]!)
        }
    }
    
    @IBAction func previewTapOnClick(_ sender: UITapGestureRecognizer) {
        if (sender.view as! UIImageView).image != nil {
            let imageView = sender.view as! UIImageView
            if imageView.tag-1 >= 0 && imageView.tag-1 < self.photos.count {
                imageView.previewImage(imageView.tag-1,imageName:(self.photos[imageView.tag-1]?.photoFile)!,senderImageView: imageView, parentItem: self)
            }
        }
    }
}
