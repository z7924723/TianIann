//
//  ApiConfiguration.swift
//  TianIann
//
//  Created by PinguMac on 2018/6/5.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import Foundation

class ApiConfig {
  
  // MARK: Properties
  var baseImageURLString = "http://image.tmdb.org/t/p/"
  var secureBaseImageURLString =  "https://image.tmdb.org/t/p/"
  var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
  var profileSizes = ["w45", "w185", "h632", "original"]
  var dateUpdated: Date? = nil
  
  // returns the number days since the config was last updated
  var daysSinceLastUpdate: Int? {
    if let lastUpdate = dateUpdated {
      return Int(Date().timeIntervalSince(lastUpdate)) / 60*60*24
    } else {
      return nil
    }
  }
  
  
}
