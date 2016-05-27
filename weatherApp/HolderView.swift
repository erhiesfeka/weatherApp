//
//  HolderView.swift
//  SBLoader
//
//  Created by Satraj Bambra on 2015-03-17.
//  Copyright (c) 2015 Satraj Bambra. All rights reserved.
//

import UIKit

protocol HolderViewDelegate:class {
  func animateLabel()
}

class HolderView: UIView {
 let ovalLayer = OvalLayer()
 let triangleLayer = TriangleLayer()
    
  var parentFrame :CGRect = CGRectZero
  weak var delegate:HolderViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Colors.clear
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
    
  func addOval() {
        layer.addSublayer(ovalLayer)
        ovalLayer.expand()
    
    NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(HolderView.wobbleOval), userInfo: nil, repeats: false)
  }
    
 func wobbleOval() {
    // 1
    layer.addSublayer(triangleLayer) // Add this line
    ovalLayer.wobble()
    
    // 2
    // Add the code below
    NSTimer.scheduledTimerWithTimeInterval(0.9, target: self,selector: #selector(HolderView.drawAnimatedTriangle), userInfo: nil,repeats: false)
}
    
func drawAnimatedTriangle() {
        triangleLayer.animate()
    
        NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(HolderView.spinAndTransform),userInfo: nil, repeats: true)
}
func spinAndTransform() {
        // 1
        layer.anchorPoint = CGPointMake(0.5, 0.6)
        
        // 2
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(M_PI * 2.0)
        rotationAnimation.duration = 0.45
        rotationAnimation.removedOnCompletion = true
        layer.addAnimation(rotationAnimation, forKey: nil)
        
        // 3
        ovalLayer.contract()
}
    
}