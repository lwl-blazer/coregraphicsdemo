//
//  CounterView.swift
//  CoregraphicDemo1
//
//  Created by morsearch on 2018/3/22.
//  Copyright © 2018年 morsearch. All rights reserved.
//

import UIKit

@IBDesignable class CounterView: UIView {

    private struct Constants{
        //存储属性
        static let numberOfGlasses = 10
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        //计算属性
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
            /*
             * 只读计算属性
             * 只有getter 没有 setter的计算属性就是只读计算属性
             * 只读计算属性总是返回一个值，可以通过点运算符访问，但不能设置新值
             */
        }
    }
    
    @IBInspectable var counter: Int = 5 {
        didSet {
            if counter <= Constants.numberOfGlasses{
                setNeedsDisplay()
            }
        }
        /*
         * 属性观察器:
         * 属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外
         *
         * willSet 在新的值被设置之前调用
         * didSet  在新的值被设置之后立即调用
         */
    }
    
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    
    override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)  //
        
        //半径
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        //其实是用弧度表示
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - Constants.arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle, clockwise: true)     //clockwise 顺时针
        
        //设置path
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        
        //两个角度之间的差值 为了保证是正数  所以必须是2 * .pi  - 起始  + 结束
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle;
        
        //步长
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        
        //算出结束的
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle

        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width / 2 - Constants.halfOfLineWidth,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        outlinePath.addArc(withCenter: center,
                           radius: bounds.width/2 - Constants.arcWidth + Constants.halfOfLineWidth,
                           startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false);
        
        outlinePath.close()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
        
        
        //------标尺------
        let context = UIGraphicsGetCurrentContext();  //得到当前上下文  类似于一张新的画布
        //图形上下文将被存储，以便于之后的存储操作   类似于OpenGL 的进出栈
        context?.saveGState();
        outlineColor.setFill();
        
        let markerWidth: CGFloat = 5.0
        let markerSize: CGFloat = 10.0
        
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth/2, y: 0, width: markerWidth, height: markerSize))
        
        //平移
        context?.translateBy(x: rect.width/2, y: rect.height/2)
        
        for i in 1...Constants.numberOfGlasses {
            context?.saveGState();
            let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi/2
            
            context?.rotate(by: angle)
            
            context?.translateBy(x: 0, y: rect.height/2 - markerSize)
            
            markerPath.fill()
            context?.restoreGState()
        }
        
        context?.restoreGState()
        
    }

}


