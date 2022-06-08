//
//  EmbedContainerController.swift
//  QCFossil
//
//  Created by pacmobile on 18/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class EmbedContainerController: UIViewController {

    var currentSegueIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
            1. _SEGUEIDENTIFIERTASKSEARCH
            2. _SEGUEIDENTIFIERTASKDETAIL
        */
        self.currentSegueIdentifier = _SEGUEIDENTIFIERTASKSEARCH
        self.performSegue(withIdentifier: self.currentSegueIdentifier, sender: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EmbedContainerController.switchToTaskSearch), name: NSNotification.Name(rawValue: "switchToTaskSearch"), object: nil)
        //addClearDropdownListTapGesture()
    }
    
    /*
    func addClearDropdownListTapGesture() {
        //Add Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("gestureRecognizer:"))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        print("trigger gesture!")
        if touch.view!.isKindOfClass(UITextField().classForCoder) || String(touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.view.resignFirstResponderByTextField(self.view)
            print("trigger gesture: resignFirstResponderByTextField!")
            
        }else {
            
            if (touch.view!.parentVC?.classForCoder)! == TaskSearchViewController.classForCoder() || (touch.view!.parentVC?.classForCoder)! == TaskDetailsViewController.classForCoder() || (touch.view!.parentVC?.classForCoder)! == POSearchViewController.classForCoder() {
                self.view.clearDropdownviewForSubviews(self.view)
                print("trigger gesture: clearDropdownviewForSubviews!")
                
            }
        }
        
        return false
    }
    */
    override func viewDidDisappear(_ animated: Bool) {
        print("Remove Observer From EmbedContainerVC Now")
        
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "switchToTaskSearch", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        let destVC = segue.destination as! UINavigationController
        let destVCChildVC = destVC.children[0]
        
        var added = false
        for childVC in self.children {
            let childChildVC = childVC.children[0]
                
            if childChildVC.classForCoder == destVCChildVC.classForCoder {
                added = true
            }
        }
        
        if !added {
            self.addChild(segue.destination)
                
            if let destView = segue.destination.view {
                destView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
                destView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(destView)
                NSLayoutConstraint.activate([
                    destView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    destView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    destView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
                    destView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
                ])
                
                segue.destination.didMove(toParent: self)
            }
        }else{
            for childVC in self.children {
                let childChildVC = childVC.children[0]
                
                if childChildVC.classForCoder == destVCChildVC.classForCoder {
                    self.view.addSubview(childVC.view)
                    
                    if childChildVC.classForCoder == TaskSearchViewController.classForCoder() {
                        let taskSearchVC = childChildVC as! TaskSearchViewController
                        /*
                        if Cache_Task_On?.taskId > 0 {
                            
                            let taskOnArray = taskSearchVC.tasks.filter({$0.taskId == Cache_Task_On?.taskId})
                            if taskOnArray.count < 1 {
                                taskSearchVC.tasks.append(Cache_Task_On!)
                            }
                            
                            let taskSetOnArray = taskSearchVC.taskSet.filter({$0.taskId == Cache_Task_On?.taskId})
                            if taskSetOnArray.count < 1 {
                                taskSearchVC.taskSet.append(Cache_Task_On!)
                            }
                        }*/
                        
                        taskSearchVC.reloadTaskSearchTableView()
                        //taskSearchVC.taskItemTableView.reloadData()
                    }else if childChildVC.classForCoder == POSearchViewController.classForCoder() {
                        let poSearchVC = childChildVC as! POSearchViewController
                        poSearchVC.reloadPoSearchTableView()
                        
                    }
                }
                
                if childChildVC.classForCoder == DataSyncViewController.classForCoder() && destVCChildVC.classForCoder != DataSyncViewController.classForCoder() {
                    let dataSyncVC = childChildVC as! DataSyncViewController
                    dataSyncVC.resetSession()
                }
            }
        }
    }
    
    func switchSegue(_ segueIdentifier:String) {
        //NSLog("Switch Segue: %@",segueIdentifier)
        DispatchQueue.main.async(execute: {
            self.view.showActivityIndicator("Loading")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.currentSegueIdentifier = segueIdentifier
                self.performSegue(withIdentifier: self.currentSegueIdentifier, sender: nil)
            }
        })
    }
    
    @objc func switchToTaskSearch() {
        self.currentSegueIdentifier = _SEGUEIDENTIFIERTASKSEARCH
        self.performSegue(withIdentifier: self.currentSegueIdentifier, sender: nil)
    }
    
}
