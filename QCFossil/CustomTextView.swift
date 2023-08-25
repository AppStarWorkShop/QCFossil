//
//  CustomTextView.swift
//  QCFossil
//
//  Created by Yin Huang on 14/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = _TEXTVIEWBORDORCOLOR
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.borderColor = _TEXTVIEWBORDORCOLOR
        self.layer.backgroundColor = UIColor.whiteColor().CGColor
        
    }*/
}
