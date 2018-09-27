//
//  ApiManager.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/24.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import Foundation

// MARK: - Data Manager Status
//enum DataManagerStatus: String, Error {
//  case unknown = "Unknown"
//  case failedRequest = "Failed Request"
//  case invalidResponse = "invalid Response"
//  case dBStatusError = "Parsing Data Status Error"
//  case dBRequestTokenFetchError = "Request Token Fetch Error"
//  case dBRequestTokenParseError = "Request Token Parse Error"
//  case dBLoginWithTokenFetchError = "Login With Token Fetch Error"
//  case dBLoginWithTokenParseError = "Login With Token Parse Error"
//  case dBSessionIDFetchError = "Session ID Fetch Error"
//  case dBSessionIDParseError = "Session ID Parse Error"
//  case dBUserIDFetchError = "User ID Fetch Error"
//  case dBUserIDParseError = "User ID Parse Error"
//}
enum DataManagerStatus: Error {
  case unknown
  case failedRequest
  case invalidResponse
  case dBStatusError
  case dBRequestTokenFetchError
  case dBRequestTokenParseError
  case dBLoginWithTokenFetchError
  case dBLoginWithTokenParseError
  case dBSessionIDFetchError
  case dBSessionIDParseError
  case dBUserIDFetchError
  case dBUserIDParseError
}

class DataManager {
  
  typealias StatusCompletion = (DataManagerStatus?) -> ()
  
  typealias fetchCompletion = ([String:AnyObject]?, DataManagerStatus?) -> ()
  
  // MARK: - Methods
//  func login(userName: String, password: String, completion: @escaping StatusCompletion) {
//    let task = DispatchQueue(label: "LoginTask")
//    let dispatchGroup = DispatchGroup()
//    let semaphore = DispatchSemaphore(value: 0)
//
//    // Step 1: get request token
//    task.async(group: dispatchGroup, execute: DispatchWorkItem(block: {
//      self.getRequestToken(completion: { (status) in
//        guard status == nil else {
//          completion(status)
//          DispatchWorkItem.cancel()
//          return
//        }
//      })
//    }))
//    task.async() {
//      self.getRequestToken(completion: { (status) in
//        guard status == nil else {
//          completion(status)
//          return
//        }
//
//        completion(nil)
//        semaphore.signal()
//
//      })
//    }
//    semaphore.wait()
//    
//    // Step 2: confirm token vaild
//    task.async() {
//      self.loginWithToken(userName: userName, password: password, completion: { (status) in
//        guard status == nil else {
//          completion(status)
//          return
//        }
//        
//        completion(nil)
//        semaphore.signal()
//        
//      })
//    }
//    semaphore.wait()
//    
//    // Step 3: get session ID
//    task.async {
//      self.getSessionID(completion: { (status) in
//        guard status == nil else {
//          completion(status)
//          return
//        }
//        
//        completion(nil)
//        semaphore.signal()
//        
//      })
//    }
//    semaphore.wait()
//    
//    // Step 4: get User ID
//    task.async {
//      self.getUserID(completion: { (status) in
//        guard status == nil else {
//          completion(status)
//          return
//        }
//        
//        completion(nil)
//      })
//    }
//  }


//  private func didFetchData(data: Data?, response: URLResponse?, error: Error?, completion: fetchCompletion) {
//    if let _ = error {
//      completion(nil, .failedRequest)
//    } else if let data = data, let response = response as? HTTPURLResponse {
//      if response.statusCode >= 200 && response.statusCode <= 299 {
//        // Parse the data
//        let parsedResult: [String:AnyObject]!
//        do {
//          parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
//
//          // GUARD: TheMovieDB return an error
//          if let _ = parsedResult[ApiConstants.TMDBResponseKeys.StatusCode] as? Int {
//            completion(nil, .dBStatusError)
//          }
//
//          completion(parsedResult, nil)
//
//        } catch {
//          completion(nil, .invalidResponse)
//        }
//      } else {
//        completion(nil, .failedRequest)
//      }
//    } else {
//      completion(nil, .unknown)
//    }
//  }
}
