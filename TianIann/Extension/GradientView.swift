//
//  UIView.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/20.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
  var gradientLayer = CAGradientLayer()
  
  @IBInspectable
  var topColor: UIColor = .clear {
    didSet {
      gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
  }
  
  @IBInspectable
  var bottomColor: UIColor = .clear {
    didSet {
      gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
  }
  
  @IBInspectable
  var beginLocation: NSNumber = 0.0 {
    didSet {
      gradientLayer.locations = [beginLocation, endLocation]
    }
  }
  
  @IBInspectable
  var endLocation: NSNumber = 0.0 {
    didSet {
      gradientLayer.locations = [beginLocation, endLocation]
    }
  }
  
  override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  override func awakeFromNib() {
    setupLayer()
  }
  
  override func prepareForInterfaceBuilder() {
    setupLayer()
  }
  
  private func setupLayer() {
    gradientLayer.frame = self.bounds
//    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.borderColor = layer.borderColor
    gradientLayer.borderWidth = layer.borderWidth
    gradientLayer.cornerRadius = layer.cornerRadius

//    layer.addSublayer(gradientLayer)
    layer.insertSublayer(gradientLayer, at: 0)

    self.clipsToBounds = true
  }
}
