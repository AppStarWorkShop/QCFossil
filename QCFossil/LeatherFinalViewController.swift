//
//  LeatherFinalViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 19/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class LeatherFinalViewController: UIViewController {

    @IBOutlet weak var inptComment: CustomTextView!
    @IBOutlet weak var vendorNotes: CustomTextView!
    @IBOutlet weak var inptResult: UITextField!
    @IBOutlet weak var inptCatWrapper: UIView!
    @IBOutlet weak var commentWrapper: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let inputview = TaskDetailViewInput.loadFromNibNamed("TaskDetailView")
        self.view.addSubview(inputview!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ToSignoffSegue" {
            segue.destinationViewController.navigationItem.title = "Sign-Off & Confirm"
            self.navigationController?.navigationBar.topItem?.title = "Back"
            segue.destinationViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: UIBarButtonItemStyle.Plain, target: segue.destinationViewController, action: "confirmMenuButton:")
        }
    }
    */
    @IBAction func signoffButtonClick(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "ToSignoffSegue", sender:self)
    }
}
