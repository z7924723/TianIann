//
//  ApiClient.swift
//  TianIann
//
//  Created by PinguMac on 2018/6/5.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
  case success
  case authenticationError = "You need to be authenticated first."
  case badRequest = "Bad request"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
}

enum Result<String>{
  case success
  case failure(String)
}

class ApiClient {
  
  // MARK: - Typealias
  typealias completionHandler = (_ result: AnyObject?, _ error: NSError?) -> ()
  
  // MARK: - Properties
  var session = URLSession.shared
  
  // configuration object
  var config = ApiConfig()
  
  // authentication state
  var requestToken: String? = nil
  var sessionID: String? = nil
  var userID: Int? = nil
  
  // MARK: - API GET method
  func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping completionHandler) -> URLSessionDataTask {
    
    var parametersWithApiKey = parameters
    parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
    
    let request = URLRequest(url: tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
    
    let task = session.dataTask(with: request) { (data, response, error) in
      
      func sendError(_ error: String) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
      }
      
      guard (error == nil) else {
        sendError("There was an error with your request: \(error!)")
        return
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let data = data else {
            sendError("No data was returned by the request!")
            return
          }
          self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
          
        case .failure:
          sendError("Your request returned a status code other than 2xx!")
        }
      }
      
    }
    task.resume()
    
    return task
  }
  
  // MARK: - API POST method
  func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
    var parametersWithApiKey = parameters
    parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
    
    var request = URLRequest(url: tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonBody.data(using: String.Encoding.utf8)
    
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
      
      func sendError(_ error: String) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
      }
      
      guard (error == nil) else {
        sendError("There was an error with your request: \(error!)")
        return
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let data = data else {
            sendError("No data was returned by the request!")
            return
          }
          self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
          
        case .failure:
          sendError("Your request returned a status code other than 2xx!")
        }
      }
      
    }
    task.resume()
    
    return task
  }
  
  // MARK: - substituteKeyInMethod
  func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
    if method.range(of: "{\(key)}") != nil {
      return method.replacingOccurrences(of: "{\(key)}", with: value)
    } else {
      return nil
    }
  }
  
  // MARK: - convertDataWithCompletionHandler
  private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
    
    var parsedResult: AnyObject! = nil
    do {
      parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
    } catch {
      let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
      completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
    }
    
    completionHandlerForConvertData(parsedResult, nil)
  }
  
  // MARK: - tmdbURLFromParameters
  private func tmdbURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
    
    var components = URLComponents()
    components.scheme = ApiClient.Constants.ApiScheme
    components.host = ApiClient.Constants.ApiHost
    components.path = ApiClient.Constants.ApiPath + (withPathExtension ?? "")
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
      let queryItem = URLQueryItem(name: key, value: "\(value)")
      components.queryItems!.append(queryItem)
    }
    
    return components.url!
  }
  
  fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
    switch response.statusCode {
    case 200...299:
      return .success
    case 401...500:
      return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599:
      return .failure(NetworkResponse.badRequest.rawValue)
    case 600:
      return .failure(NetworkResponse.outdated.rawValue)
    default:
      return .failure(NetworkResponse.failed.rawValue)
    }
  }
  
  // MARK: - Shared Instance
  class func sharedInstance() -> ApiClient {
    struct Singleton {
      static var sharedInstance = ApiClient()
    }
    return Singleton.sharedInstance
  }
}
