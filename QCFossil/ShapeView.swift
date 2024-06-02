//
//  ShapeView.swift
//  ShapesTutorial
//
//  Created by Silviu Pop on 7/27/15.
//  Copyright (c) 2015 WeHeartSwift. All rights reserved.
//

import UIKit

class ShapeView: UIView {
    
    var size: CGFloat = 105
    let lineWidth: CGFloat = 3
    var fillColor: UIColor!
    var path: UIBezierPath!
    
    func randomColor() -> UIColor {
        let hue:CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        return UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)
    }
    
    func pointFrom(_ angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }
    
    func regularPolygonInRect(_ rect:CGRect) -> UIBezierPath {
        let degree = arc4random() % 10 + 3
        
        let path = UIBezierPath()
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        var angle:CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(degree))
        let radius = rect.width / 2.0
        
        path.move(to: pointFrom(angle, radius: radius, offset: center))
        
        for _ in 1...degree - 1 {
            angle += angleIncrement
            path.addLine(to: pointFrom(angle, radius: radius, offset: center))
        }
        
        path.close()
        
        return path
    }
    
    func starPathInRect(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let starExtrusion:CGFloat = 30.0
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        let pointsOnStar = 5 + arc4random() % 10
        
        var angle:CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(pointsOnStar))
        let radius = rect.width / 2.0
        
        var firstPoint = true
        
        for _ in 1...pointsOnStar {
            
            let point = pointFrom(angle, radius: radius, offset: center)
            let nextPoint = pointFrom(angle + angleIncrement, radius: radius, offset: center)
            let midPoint = pointFrom(angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
            
            if firstPoint {
                firstPoint = false
                path.move(to: point)
            }
            
            path.addLine(to: midPoint)
            path.addLine(to: nextPoint)
            
            angle += angleIncrement
        }
        
        path.close()
        
        
        return path
    }
    
    func trianglePathInRect(_ rect:CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.width / 2.0, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width,y: rect.height))
        path.addLine(to: CGPoint(x: rect.origin.x,y: rect.height))
        path.close()
        
        return path
    }
    
    func randomPath() -> UIBezierPath {
        
        let insetRect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
        
        let shapeType = arc4random() % 5
        
        if shapeType == 0 {
            return UIBezierPath(roundedRect: insetRect, cornerRadius: 10.0)
        }
        
        if shapeType == 1 {
            return UIBezierPath(ovalIn: insetRect)
        }
        
        if (shapeType == 2) {
            return trianglePathInRect(insetRect)
        }
        
        if (shapeType == 3) {
            return regularPolygonInRect(insetRect)
        }
        
        return starPathInRect(insetRect)
    }
    
    func pathTypeById(_ shapeType:Int) -> UIBezierPath {
        
        let insetRect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
        
        if shapeType == 0 {
            return UIBezierPath(roundedRect: insetRect, cornerRadius: 10.0)
        }
        
        if shapeType == 1 {
            return UIBezierPath(ovalIn: insetRect)
        }
        
        if (shapeType == 2) {
            return trianglePathInRect(insetRect)
        }
        
        if (shapeType == 3) {
            return regularPolygonInRectByDegree(insetRect, degree: 4)
        }
        
        if (shapeType == 4) {
            return regularPolygonInRectByDegree(insetRect, degree: 5)
        }
        
        if (shapeType == 5) {
            if self.size < 200 {
                return UIBezierPath(ovalIn: CGRect(x: 10, y: 35, width: 90, height: 40))
            }else {
                return UIBezierPath(ovalIn: CGRect(x: 10, y: 25, width: 180, height: 80))
            }
        }
        
        if (shapeType == 6) {
            if self.size < 200 {
                return UIBezierPath(ovalIn: CGRect(x: 10, y: 25, width: 90, height: 60))
            }else {
                return UIBezierPath(ovalIn: CGRect(x: 10, y: 25, width: 180, height: 120))
            }
        }
        
        if (shapeType == 7) {
            return arrowShape(CGPoint(x: 10, y: 100), to: CGPoint(x: 100, y: 10), tailWidth: 20, headWidth: 45, headLength: 80)
        }
        
        if (shapeType == 8) {
            return arrowShape(CGPoint(x: 10, y: 100), to: CGPoint(x: 100, y: 10), tailWidth: 10, headWidth: 30, headLength: 60)
        }
        
        if (shapeType == 9) {
            return arrowShape(CGPoint(x: 10, y: 100), to: CGPoint(x: 100, y: 10), tailWidth: 10, headWidth: 25, headLength: 40)
        }
        
        if (shapeType == 10) {
            return arrowShape(CGPoint(x: 100, y: 100), to: CGPoint(x: 10, y: 10), tailWidth: 10, headWidth: 25, headLength: 40)
        }
        
        return starPathInRect(insetRect)
    }
    
    func regularPolygonInRectByDegree(_ rect:CGRect, degree:Int = 4) -> UIBezierPath {
        //let degree = arc4random() % 10 + 3
        
        let path = UIBezierPath()
        
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        
        var angle:CGFloat = -CGFloat(M_PI / 2.0)
        let angleIncrement = CGFloat(M_PI * 2.0 / Double(degree))
        let radius = rect.width / 2.0
        
        path.move(to: pointFrom(angle, radius: radius, offset: center))
        
        for _ in 1...degree - 1 {
            angle += angleIncrement
            path.addLine(to: pointFrom(angle, radius: radius, offset: center))
        }
        
        path.close()
        
        return path
    }
    
    func arrowShape(_ from:CGPoint, to:CGPoint, tailWidth:CGFloat, headWidth:CGFloat, headLength:CGFloat) -> UIBezierPath {
        return UIBezierPath.arrow(from: from, to: to,
                                   tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)
    }
    
    init(origin: CGPoint, shapeType:Int, shapeSize:CGFloat = 205) {
        self.size = shapeSize
        
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
        
        if shapeType == 7 || shapeType == 8 || shapeType == 9 || shapeType == 10 {
            self.fillColor = UIColor.init(red: CGFloat(_BRUSHSTYLE["red"]!), green: CGFloat(_BRUSHSTYLE["green"]!), blue: CGFloat(_BRUSHSTYLE["blue"]!), alpha: 1.0)
        }else{
            self.fillColor = UIColor.clear//randomColor()
        }
        
        self.path = pathTypeById(shapeType) //UIBezierPath(roundedRect: CGRectInset(self.bounds,lineWidth,lineWidth), cornerRadius: 10.0)
        
        self.center = origin
        
        self.backgroundColor = UIColor.clear
        
        initGestureRecognizers()
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(ShapeView.didPan(_:)))
        addGestureRecognizer(panGR)
        
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(ShapeView.didPinch(_:)))
        addGestureRecognizer(pinchGR)
        
        let rotationGR = UIRotationGestureRecognizer(target: self, action: #selector(ShapeView.didRotate(_:)))
        addGestureRecognizer(rotationGR)
        
        let removeGR = UILongPressGestureRecognizer(target: self, action: #selector(ShapeView.didRemove(_:)))
        addGestureRecognizer(removeGR)

    }

    @objc func didRemove(_ rmvGR: UILongPressGestureRecognizer) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Shape?"),parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
            self.removeFromSuperview()
        })
    }
    
    @objc func didPan(_ panGR: UIPanGestureRecognizer) {
        
        self.superview!.bringSubviewToFront(self)
        
        var translation = panGR.translation(in: self)
        
        translation = translation.applying(self.transform)
        
        self.center.x += translation.x
        self.center.y += translation.y
        
        panGR.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func didPinch(_ pinchGR: UIPinchGestureRecognizer) {
        
        self.superview!.bringSubviewToFront(self)
        
        let scale = pinchGR.scale
        
        self.transform = self.transform.scaledBy(x: scale, y: scale)
        
        pinchGR.scale = 1.0
    }
    
    @objc func didRotate(_ rotationGR: UIRotationGestureRecognizer) {
        
        self.superview!.bringSubviewToFront(self)
        
        let rotation = rotationGR.rotation
        
        self.transform = self.transform.rotated(by: rotation)
        
        rotationGR.rotation = 0.0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        self.fillColor.setFill()
        
        self.path.fill()
        /*
        var name = "hatch"
        if arc4random() % 2 == 0 {
            name = "cross-hatch"
        }
        
        let color = UIColor(patternImage: UIImage(named: name)!)
        
        color.setFill()
 
        if arc4random() % 2 == 0 {
            path.fill()
        }
        */
        //UIColor.blackColor().setStroke()
        let colorUsing = UIColor.init(red: CGFloat(_BRUSHSTYLE["red"]!), green: CGFloat(_BRUSHSTYLE["green"]!), blue: CGFloat(_BRUSHSTYLE["blue"]!), alpha: 1.0)
        colorUsing.setStroke()
        
        path.lineWidth = self.lineWidth
    
        path.stroke()
    }
    
}
