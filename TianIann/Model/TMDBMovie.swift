//
//  TMDBMovie.swift
//  TianIann
//
//  Created by PinguMac on 2018/6/7.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import Foundation

struct TMDBMovie {
  
  // MARK: - Properties
  let title: String
  let id: Int
  let posterPath: String?
  let releaseYear: String?
  
  // MARK: - Initializers
  
  // construct a TMDBMovie from a dictionary
  init(dictionary: [String:AnyObject]) {
    title = dictionary[ApiClient.JSONResponseKeys.MovieTitle] as! String
    id = dictionary[ApiClient.JSONResponseKeys.MovieID] as! Int
    posterPath = dictionary[ApiClient.JSONResponseKeys.MoviePosterPath] as? String
    
    if let releaseDateString = dictionary[ApiClient.JSONResponseKeys.MovieReleaseDate] as? String, releaseDateString.isEmpty == false {
      let stringIndex = releaseDateString.index(of: "-")!
      releaseYear = String(releaseDateString.prefix(upTo: stringIndex))
    } else {
      releaseYear = ""
    }
  }
  
  static func moviesFromResults(_ results: [[String:AnyObject]]) -> [TMDBMovie] {
    
    var movies = [TMDBMovie]()
    
    // iterate through array of dictionaries, each Movie is a dictionary
    for result in results {
      movies.append(TMDBMovie(dictionary: result))
    }
    
    return movies
  }
}
