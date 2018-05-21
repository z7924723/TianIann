//
//  UITextField.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/20.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
  @IBInspectable public var placeholderColor: UIColor = .lightGray {
    didSet {
      self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
    }
  }
  
  @IBInspectable var leftImage: UIImage = UIImage() {
    didSet {
      self.leftViewMode = .always
      let imageView = UIImageView(image: leftImage)
      imageView.contentMode = .scaleToFill
      self.leftView = imageView
    }
  }
  
//  @IBInspectable var leftViewWidth: CGFloat = 0 {
//    didSet {
//      self.leftView?.frame = CGRect(x: 0, y: 0, width: leftViewWidth, height: leftViewHeight)
//    }
//  }
//
//  @IBInspectable var leftViewHeight: CGFloat = 0 {
//    didSet {
//      self.leftView?.frame = CGRect(x: 0, y: 0, width: leftViewWidth, height: leftViewHeight)
//    }
//  }
  
  @IBInspectable var rightImage: UIImage = UIImage() {
    didSet {
      self.rightViewMode = .always
      let imageView = UIImageView(image: rightImage)
      imageView.contentMode = .scaleAspectFit
      self.rightView = imageView
    }
  }

}
