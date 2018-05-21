//
//  GCDBlackBox.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/21.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
  DispatchQueue.main.async {
    updates()
  }
}
