//
//  Constants.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/19.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

// MARK: - Configuration
struct Configuration {
  
  private init() {}
  
  // MARK: TMDB
  struct TMDB {
    static let ApiScheme = "http"
    static let ApiHost = "api.themoviedb.org"
    static let ApiPath = "/3"
  }
  
  // MARK: TMDB Parameter Keys
  struct TMDBParameterKeys {
    static let ApiKey = "api_key"
    static let RequestToken = "request_token"
    static let SessionID = "session_id"
    static let Username = "username"
    static let Password = "password"
  }
  
  // MARK: TMDB Parameter Values
  struct TMDBParameterValues {
    static let ApiKey = "fd904e19d94fec2082de9ea1ef917560"
  }
  
  // MARK: TMDB Response Keys
  struct TMDBResponseKeys {
    static let Title = "title"
    static let ID = "id"
    static let PosterPath = "poster_path"
    static let StatusCode = "status_code"
    static let StatusMessage = "status_message"
    static let SessionID = "session_id"
    static let RequestToken = "request_token"
    static let Success = "success"
    static let UserID = "id"
    static let Results = "results"
  }
  
  func tmdbURLFromParameters(_ parameters: [String:AnyObject],
                             withPathExtension: String? = nil) -> URL {
    
    var components = URLComponents()
    components.scheme = Configuration.TMDB.ApiScheme
    components.host = Configuration.TMDB.ApiHost
    components.path = Configuration.TMDB.ApiPath + (withPathExtension ?? "")
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
      let queryItem = URLQueryItem(name: key, value: "\(value)")
      components.queryItems!.append(queryItem)
    }
    
    return components.url!
  }
}

