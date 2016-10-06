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
    
  var parentFrame :CGRect = CGRect.zero
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
    
    Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(HolderView.wobbleOval), userInfo: nil, repeats: false)
  }
    
 func wobbleOval() {
    // 1
    layer.addSublayer(triangleLayer) // Add this line
    ovalLayer.wobble()
    
    // 2
    // Add the code below
    Timer.scheduledTimer(timeInterval: 0.9, target: self,selector: #selector(HolderView.drawAnimatedTriangle), userInfo: nil,repeats: false)
}
    
func drawAnimatedTriangle() {
        triangleLayer.animate()
    
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(HolderView.spinAndTransform),userInfo: nil, repeats: true)
}
func spinAndTransform() {
        // 1
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.6)
        
        // 2
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(M_PI * 2.0)
        rotationAnimation.duration = 0.45
        rotationAnimation.isRemovedOnCompletion = true
        layer.add(rotationAnimation, forKey: nil)
        
        // 3
        ovalLayer.contract()
}
    
}
