//
//  CustomTextField.swift
//  QCFossil
//
//  Created by Yin Huang on 14/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override var canBecomeFirstResponder : Bool {
        return false
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

class NoActionTextField: UITextField {
    
//    override func caretRectForPosition(position: UITextPosition) -> CGRect {
//        return CGRect.zero
//    }
//    
//    override func selectionRectsForRange(range: UITextRange) -> [AnyObject] {
//        return []
//    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
