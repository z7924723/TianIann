//
//  ApiManager.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/24.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import Foundation

final class ApiData {
  
  // MARK: - Porperties
  static let shared = ApiData()

  var sharedSession = URLSession.shared
  var requestToken: String? = nil
  var sessionID: String? = nil
  var userID: Int? = nil
  
  // MARK: - Initializers
  private init() {
    print("Create Api Data")
  }
  
//  // MARK: - Helper Methods
//  func tmdbURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
//    var components = URLComponents()
//    components.scheme = ApiConstants.TMDB.ApiScheme
//    components.host = ApiConstants.TMDB.ApiHost
//    components.path = ApiConstants.TMDB.ApiPath + (withPathExtension ?? "")
//    components.queryItems = [URLQueryItem]()
//    
//    for (key, value) in parameters {
//      let queryItem = URLQueryItem(name: key, value: "\(value)")
//      components.queryItems!.append(queryItem)
//    }
//    
//    return components.url!
//  }
}
