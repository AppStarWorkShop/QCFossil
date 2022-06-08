//
//  POSearchView.swift
//  QCFossil
//
//  Created by Yin Huang on 11/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class POSearchView: UIView {
    
    var parentViewController = POSearchViewController()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func okButton(_ sender: UIButton) {
        parentViewController.dismiss(animated: true, completion:nil)
    }
}
