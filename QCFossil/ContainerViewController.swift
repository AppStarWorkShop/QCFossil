//
//  ContainerViewController.swift
//  QCFossil
//
//  Created by pacmobile on 18/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController{
    
    // This value matches the left menu's width in the Storyboard
    let leftMenuWidth:CGFloat = 180
    weak var embedContainerController:EmbedContainerController!
    var resetLogonItems: (() -> Void)?
    
    @IBOutlet weak var containerScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Set up a notification for toggleMenu from other page.
        
        //Init Toggle Menu Notification
        NotificationCenter.default.addObserver(self, selector: #selector(ContainerViewController.toggleMenu), name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
        //Init Task Search Menu Click Response Notification
        NotificationCenter.default.addObserver(self, selector: #selector(ContainerViewController.taskSearchMenuClickResponse(_:)), name: NSNotification.Name(rawValue: "taskSearchMenuClickResponse"), object: nil)
        //Init Toggle Scrollable Notification
        NotificationCenter.default.addObserver(self, selector: #selector(ContainerViewController.setScrollable(_:)), name: NSNotification.Name(rawValue: "setScrollable"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            NSLog("Close Menu.")
            
            self.closeMenu(false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetLogonItems?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "taskSearchMenuClickResponse"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "setScrollable"), object: nil)
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
        
        if segue.identifier == "embedContainer" {
            self.embedContainerController = segue.destination as? EmbedContainerController
        }
    }
    
    func closeMenu(_ animated:Bool = true) {
        containerScroll.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
    }
    
    func displayMenu(_ animated:Bool = true) {
        containerScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    @objc func toggleMenu(){
        if self.containerScroll.isScrollEnabled {
            containerScroll.contentOffset.x == 0  ? closeMenu() : displayMenu()
        }
    }
    
    @objc func taskSearchMenuClickResponse(_ notification:Notification){
        //closeMenu()
        let userInfo:Dictionary<String,String?> = notification.userInfo as! Dictionary<String,String?>
        if let segueIdentifier = userInfo[_SEGUEIDENTIFIER] {
            self.embedContainerController?.switchSegue(segueIdentifier!)
        }
    }
    
    @objc func setScrollable(_ notification:Notification) {
        let userInfo:Dictionary<String,Bool?> = notification.userInfo as! Dictionary<String,Bool?>
        if let canScroll = userInfo["canScroll"] as? Bool {
            if canScroll == false {
                closeMenu()
            }
            self.containerScroll.isScrollEnabled = canScroll
        }
    }
}

/*
    Funcs of UIScrollViewDelegate
*/
extension ContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ containerScroll: UIScrollView) {
        //print("scrollView.contentOffset.x:: \(containerScroll.contentOffset.x)")
    }
    
    func scrollViewWillBeginDragging(_ containerScroll: UIScrollView) {
        //NSLog("pagingEnabled: true")
        containerScroll.isPagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ containerScroll: UIScrollView) {
        //NSLog("pagingEnabled: false")
        containerScroll.isPagingEnabled = false
    }
}
