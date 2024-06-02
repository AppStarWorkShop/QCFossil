//
//  SignoffView.swift
//  QCFossil
//
//  Created by pacmobile on 22/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class SignoffView: UIImageView {

    var mouseSwiped:Bool = false
    var touched:Bool = false
    var lastPoint:CGPoint = CGPoint(x: 0.0, y: 0.0)
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var brush:CGFloat = 2.0
    var opacity:CGFloat = 1.0
    var previewOnly = false
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setBrushStyle(_ red:CGFloat, green:CGFloat, blue:CGFloat, brush:CGFloat=2.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.brush = brush
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("Touches Begin")
        
        if previewOnly {
            return
        }
        
        mouseSwiped = false
        
        let touch = touches.first! as UITouch
        lastPoint = touch.location(in: self)
        
        for view in self.subviews {
            if view.isKind(of: ShapeView.self) && view.frame.contains(lastPoint) {
                return
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if previewOnly {
            return
        }
        
        mouseSwiped = true
        let touch =  touches.first! as UITouch
        let currentPoint = touch.location(in: self)
        
        for view in self.subviews {
            if view.isKind(of: ShapeView.self) && view.frame.contains(lastPoint) {
                return
            }
        }
        
        UIGraphicsBeginImageContext(self.frame.size)
        self.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        // self.image?.drawInRect(CGRectMake(0, 0, (self.image?.size.width)!, (self.image?.size.height)!))
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(brush)
        UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.normal)
        
        UIGraphicsGetCurrentContext()?.strokePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = opacity
        UIGraphicsEndImageContext()
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if previewOnly {
            return
        }
        
        for view in self.subviews {
            if view.isKind(of: ShapeView.self) && view.frame.contains(lastPoint) {
                return
            }
        }
        
        if !mouseSwiped {
            UIGraphicsBeginImageContext(self.frame.size)

            //UIGraphicsBeginImageContext((self.image?.size)!)
            self.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            //self.image?.drawInRect(CGRectMake(0, 0, (self.image?.size.width)!, (self.image?.size.height)!))
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
            UIGraphicsGetCurrentContext()?.setLineWidth(brush)
            UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.strokePath()
            UIGraphicsGetCurrentContext()?.flush()
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }else{
            touched = true
        }
    }
}
