//
//  ScrollViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 22/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func startTaskMenuClick(_ sender: UIBarButtonItem) {
        NSLog("Start Task in Scroll-Container")
        
        
    }

    @IBAction func toggleMenuClick(_ sender: UIBarButtonItem) {
        NSLog("Toggle Menu in Scroll-Container")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "toggleMenu"), object: nil)
    }
}
