//
//  GraphView.swift
//  CoregraphicDemo1
//
//  Created by morsearch on 2018/3/23.
//  Copyright © 2018年 morsearch. All rights reserved.
//

import UIKit


@IBDesignable class GraphView: UIView {
    
    private struct Constants{
        
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
        
    }

    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    var graphPoints:[Int] = [4, 2, 6, 4, 5, 8 ,3];
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        //------- SubView -----
        //根据rect 指定任意角 任意size的圆角
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: UIRectCorner.allCorners,    //Rect的角的位置   有上左 上右 下左 下右 全部
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip() //path调用addClip之后，你所在的context的可见区域就变成了它的"fill area(填充区域)"，接下来的绘制，如果在这个区域外都会被无视
        
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor] //渐变样式的起始颜色和结束颜色
        let colorSpace = CGColorSpaceCreateDeviceRGB()    //CGColorSpace 描述的是颜色的域值范围。大多情况下你会使用RGB模式来描述颜色
        let colorLocations: [CGFloat] = [0.0, 1.0] //定义各种颜色的相对位置
        
        //渐变信息
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: bounds.height)
        //绘制渐变颜色
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: CGGradientDrawingOptions(rawValue: 0))
        
        // --------- 计算 --------
        //计算x轴的point
        let margin = Constants.margin
        let columnXPoint = {(colum:Int) ->CGFloat in
            let spacer = (width - margin * 2 - 4) / CGFloat((self.graphPoints.count - 1))
            var x: CGFloat = CGFloat(colum) * spacer
            x += margin + 2
            return x
        }
        
        //计算y轴的point
        let topBorder: CGFloat = Constants.topBorder
        let bottomBorder: CGFloat = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //----- 折线 ------
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        context.saveGState()
        
        //---- 在折线下面的渐变颜色     使用的是剪切路径的处理  ------
        //复制路径
        let clippingPath = graphPath.copy() as! UIBezierPath
        //添加路径来完成剪裁区域
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()  //关闭或者说结整这个Path
        clippingPath.addClip()  //将剪切路径添加到上下文
        
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x: margin, y: highestYPoint)
        endPoint = CGPoint(x: margin, y: self.bounds.height)
        
        //创建线性渐变
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: CGGradientDrawingOptions(rawValue:0))
        context.restoreGState()
        
        
        
        // ----- 绘制小圆点  -------
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        //小圆点
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
       
            let circle = UIBezierPath(ovalIn: CGRect(origin: point,
                                                     size: CGSize(width: Constants.circleDiameter,
                                                                  height: Constants.circleDiameter)))
            circle.fill()
        }
        
        // ------ 三条平行线 ---------
        
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        linePath.move(to: CGPoint(x: margin, y: graphHeight / 2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
    }
}
