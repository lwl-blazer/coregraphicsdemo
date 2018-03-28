//
//  MedalView.swift
//  CoregraphicDemo1
//
//  Created by morsearch on 2018/3/27.
//  Copyright © 2018年 morsearch. All rights reserved.
//

import UIKit

class MedalView: UIImageView {

    lazy var medalImage: UIImage = self.createMedalImage()

    func createMedalImage() -> UIImage{
        
        debugPrint("creating Medal Image")
        
        let size = CGSize(width: 120.0, height: 200.0)
        
        //得到图形上下文，生成由UIImageView或知道如何以显示图像的任何界面对象显示的图片  产生一个UIImage
        /*
         public func UIGraphicsBeginImageContextWithOptions(_ size: CGSize, _ opaque: Bool, _ scale: CGFloat)
         参数1:size
         参数2:opauqe  是否透明，一般使用false
         参数3:scale 缩放
         */
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        
        let darkGoldColor = UIColor(red: 0.6, green: 0.5, blue: 0.15, alpha: 1.0)
        let midGoldColor = UIColor(red: 0.86, green: 0.73, blue: 0.3, alpha: 1.0)
        let lightGoldColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)
        
        
        let shadow: UIColor = UIColor.black.withAlphaComponent(0.80)
        let shadowOffset = CGSize(width: 2.0, height: 2.0)
        let shadowBlurRadius: CGFloat = 5
        
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
        context?.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let lowerRibbonPath = UIBezierPath()
        lowerRibbonPath.move(to: CGPoint(x: 0, y: 0))
        lowerRibbonPath.addLine(to: CGPoint(x: 40, y: 0))
        lowerRibbonPath.addLine(to: CGPoint(x: 78, y: 70))
        lowerRibbonPath.addLine(to: CGPoint(x: 38, y: 70))
        lowerRibbonPath.close()
        UIColor.red.setFill()
        lowerRibbonPath.fill()
        
        let claspPath = UIBezierPath(roundedRect: CGRect(x: 36, y: 62, width: 43, height: 20),
                                     cornerRadius: 5)
        claspPath.lineWidth = 5
        darkGoldColor.setStroke()
        claspPath.stroke()
        
        let medallionPath = UIBezierPath(ovalIn: CGRect(x: 8, y: 72, width: 100, height: 100))
        context?.saveGState()
        medallionPath.addClip()
        
        let colors = [darkGoldColor.cgColor, midGoldColor.cgColor, lightGoldColor.cgColor] as CFArray
        
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: colors,
                                  locations: [0, 0.51, 1])!
        context?.drawLinearGradient(gradient,
                                    start: CGPoint(x: 40, y: 40),
                                    end: CGPoint(x: 100, y:160),
                                options: [])
        context?.restoreGState()
        
        var transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        transform = transform.translatedBy(x: 15, y: 30)
        medallionPath.lineWidth = 2.0
        
        medallionPath.apply(transform)
        medallionPath.stroke()
        
        let upperRibbonPath = UIBezierPath()
        upperRibbonPath.move(to: CGPoint(x: 68, y: 0))
        upperRibbonPath.addLine(to: CGPoint(x: 108, y: 0))
        upperRibbonPath.addLine(to: CGPoint(x: 78, y: 70))
        upperRibbonPath.addLine(to: CGPoint(x: 38, y: 70))
        upperRibbonPath.close()
        
        UIColor.blue.setFill()
        upperRibbonPath.fill()
        
        let numberOne = "1" as NSString
        let numberOneRect = CGRect(x: 47, y: 100, width: 50, height: 50)
        let font = UIFont(name: "Academy Engraved LET", size: 60)!
        let numberOneAttributes = [
            NSAttributedStringKey.font : font,
            NSAttributedStringKey.foregroundColor: darkGoldColor
        ]
        numberOne.draw(in: numberOneRect, withAttributes: numberOneAttributes);
        context?.endTransparencyLayer()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image

    }
    
    func showMedal(show: Bool){
        image = show == true ? medalImage : nil
    }
    
}
