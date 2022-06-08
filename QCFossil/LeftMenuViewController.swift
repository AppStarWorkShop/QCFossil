//
//  LeftMenuViewController.swift
//  QCFossil
//
//  Created by pacmobile on 21/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var taskSearchBtn: UIButton!
    @IBOutlet weak var poSearchBtn: UIButton!
    @IBOutlet weak var dataSyncBtn: UIButton!
    @IBOutlet weak var userLogoutBtn: UIButton!
    @IBOutlet weak var dataControlBtn: UIButton!
    @IBOutlet weak var userSettingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocalizedString()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocalizedString(){
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Version") + " \(_VERSION)"
        
        self.taskSearchBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Search"), for: UIControl.State())
        self.poSearchBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("PO Search"), for: UIControl.State())
        self.dataSyncBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Sync"), for: UIControl.State())
        self.userLogoutBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("User Logout"), for: UIControl.State())
        self.dataControlBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Control"), for: UIControl.State())
        self.userSettingBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("User Setting"), for: UIControl.State())
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func TaskSearchMenuClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "taskSearchMenuClickResponse"), object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERTASKSEARCH])
    }
    
    @IBAction func poSearchMenuClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "taskSearchMenuClickResponse"), object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERPOSEARCH])
    }
    
    @IBAction func dataSyncMenuClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "taskSearchMenuClickResponse"), object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERDATASYNC])
    }
    
    @IBAction func userLogoutMenuClick(_ sender: UIButton) {
        Cache_Task_On = nil
        Cache_Inspector = nil
        Cache_Task_Path = ""
        Cache_Thumb_Path = ""
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DataControlMenuClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "taskSearchMenuClickResponse"), object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERDATACTRL])
    }
    
    @IBAction func UserSettingMenuClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "taskSearchMenuClickResponse"), object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERUSERSETTING])
    }
}
