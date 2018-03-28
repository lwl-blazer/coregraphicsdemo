//
//  BackgroundVIew.swift
//  CoregraphicDemo1
//
//  Created by morsearch on 2018/3/27.
//  Copyright © 2018年 morsearch. All rights reserved.
//

import UIKit

@IBDesignable
class BackgroundVIew: UIView {

    @IBInspectable var lightColor: UIColor = UIColor.orange
    @IBInspectable var darkColor: UIColor = UIColor.yellow
    @IBInspectable var patternSize: CGFloat = 200


    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(darkColor.cgColor)
        context.fill(rect)
        
        let drawSize = CGSize(width: patternSize, height: patternSize)
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        
        
        let drawingContext = UIGraphicsGetCurrentContext()!
        
        darkColor.setFill()
        drawingContext.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: drawSize.width/2, y: 0))
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height/2))
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height/2))
        
        trianglePath.move(to: CGPoint(x: 0, y: drawSize.height/2))
        trianglePath.addLine(to: CGPoint(x: drawSize.width/2, y: drawSize.height))
        trianglePath.addLine(to: CGPoint(x: 0, y: drawSize.height))
        
        trianglePath.move(to: CGPoint(x: drawSize.width, y: drawSize.height/2))
        trianglePath.addLine(to: CGPoint(x: drawSize.width/2, y: drawSize.height))
        trianglePath.addLine(to: CGPoint(x: drawSize.width, y: drawSize.height))
        
        lightColor.setFill()
        trianglePath.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image).setFill()
        context.fill(rect)
    }
    
}
