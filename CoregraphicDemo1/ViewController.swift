//
//  ViewController.swift
//  CoregraphicDemo1
//
//  Created by morsearch on 2018/3/22.
//  Copyright © 2018年 morsearch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var averageWater: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var containView: UIView!
    
    @IBOutlet weak var medalView: MedalView!
    var isGraphViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.counter)
        checkTotal()
    }

    @IBAction func pushButtonPress(_ sender: PushButton) {
        if sender.isAddButton{
            counterView.counter += 1
        }else{
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
        
        if isGraphViewShowing{
            containViewTap(nil)
        }
        checkTotal()
    }
    
    //Contain View的Tap 手势
    @IBAction func containViewTap(_ sender: UITapGestureRecognizer?) {
        if isGraphViewShowing{
            UIView.transition(from: graphView,
                              to: counterView,
                              duration: 1.0,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion: nil)
        }else{
            setupGraphDisplay()
            UIView.transition(from: counterView,
                              to: graphView,
                              duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    //绘制GraphView
    func setupGraphDisplay(){
        
        //得到stackView上的Label
        let maxDayIndex = stackView.arrangedSubviews.count - 1
        
        //修改graphPoints的最后一点的数字
        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
        graphView.setNeedsDisplay() //重新绘制
        
        maxLabel.text = "\(graphView.graphPoints.max()!)"
        let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
        averageWater.text = "\(average)"
        
        
        //设置StackView的label
        let today = Date()
        let calendar = Calendar.current

        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        
        for i in 0...maxDayIndex{
            
            if let date = calendar.date(byAdding: .day, value: -i, to: today),
                let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
                label.text = formatter.string(from: date)
            }
            
        }
    }
    
    func checkTotal(){
        if counterView.counter >= 8 {
            medalView.showMedal(show: true)
        }else{
            medalView.showMedal(show: false)
        }
    }
    
}

