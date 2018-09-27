//
//  FavortiesViewController.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/23.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

class FavortiesViewController: UIViewController {
  
  // Mark: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print(ApiData.shared.sessionID!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
