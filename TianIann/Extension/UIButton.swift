//
//  UIButton.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/19.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
  @IBInspectable public var borderColor: UIColor = .clear {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }
  
  @IBInspectable public var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable public var cornerRadius: CGFloat = 0{
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }
}
