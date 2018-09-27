//
//  ApiConvenience.swift
//  TianIann
//
//  Created by PinguMac on 2018/6/6.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

extension ApiClient {
  
  // MARK: - Authentication Methods
  func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    
    getRequestToken { (success, requestToken, errorString) in
      if success {
        self.requestToken = requestToken
        
        self.loginWithToken(requestToken, hostViewController: hostViewController, completionHandlerForLogin: { (success, errorString) in
          if success {
            self.getSessionID(requestToken, completionHandlerForSession: { (success, sessionID, errorString) in
              
              if success {
                self.sessionID = sessionID
                
                self.getUserID({ (success, userID, errorString) in
                  if success {
                    if let userID = userID {
                      self.userID = userID
                    }
                  }
                  completionHandlerForAuth(success, errorString)
                })
              } else {
                completionHandlerForAuth(success, errorString)
              }
            })
          } else {
            completionHandlerForAuth(success, errorString)
          }
        })
      } else {
        completionHandlerForAuth(success, errorString)
      }
    }
  }
  
  // MARK: - getRequestToken
  private func getRequestToken(_ completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
    
    let parameters = [String:AnyObject]()
    
    let _ = taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) { (results, error) in
      
      if let error = error {
        print(error)
        completionHandlerForToken(false, nil, "Login Failed (Request Token).")
      } else {
        if let requestToken = results?[ApiClient.JSONResponseKeys.RequestToken] as? String {
          completionHandlerForToken(true, requestToken, nil)
        } else {
          print("Could not find \(ApiClient.JSONResponseKeys.RequestToken) in \(results!)")
          completionHandlerForToken(false, nil, "Login Failed (Request Token).")
        }
      }
    }
  }
  
  // MARK: - loginWithToken
  private func loginWithToken(_ requestToken: String?, hostViewController: UIViewController, completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    
    let authorizationURL = URL(string: "\(ApiClient.Constants.AuthorizationURL)\(requestToken!)")
    
    let request = URLRequest(url: authorizationURL!)
    print(request)
    
    let webAuthViewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "WebAuthViewController") as! WebAuthViewController
    webAuthViewController.urlRequest = request
    webAuthViewController.requestToken = requestToken
    webAuthViewController.completionHandlerForView = completionHandlerForLogin
    
    let webAuthNavigationController = UINavigationController()
    webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
    
    performUIUpdatesOnMain {
      hostViewController.present(webAuthNavigationController, animated: true, completion: nil)
    }
  }
  
  // MARK: - getSessionID
  private func getSessionID(_ requestToken: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
    
    let parameters = [ApiClient.ParameterKeys.RequestToken: requestToken!]
    
    let _ = taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters as [String:AnyObject]) { (results, error) in
      
      if let error = error {
        print(error)
        completionHandlerForSession(false, nil, "Login Failed (Session ID).")
      } else {
        if let sessionID = results?[ApiClient.JSONResponseKeys.SessionID] as? String {
          completionHandlerForSession(true, sessionID, nil)
        } else {
          print("Could not find \(ApiClient.JSONResponseKeys.SessionID) in \(results!)")
          completionHandlerForSession(false, nil, "Login Failed (Session ID).")
        }
      }
    }
  }
  
  // MARK: - getUserID
  private func getUserID(_ completionHandlerForUserID: @escaping (_ success: Bool, _ userID: Int?, _ errorString: String?) -> Void) {
    
    let parameters = [ApiClient.ParameterKeys.SessionID: ApiClient.sharedInstance().sessionID!]
    
    let _ = taskForGETMethod(Methods.Account, parameters: parameters as [String:AnyObject]) { (results, error) in
      
      if let error = error {
        print(error)
        completionHandlerForUserID(false, nil, "Login Failed (User ID).")
      } else {
        if let userID = results?[ApiClient.JSONResponseKeys.UserID] as? Int {
          completionHandlerForUserID(true, userID, nil)
        } else {
          print("Could not find \(ApiClient.JSONResponseKeys.UserID) in \(results!)")
          completionHandlerForUserID(false, nil, "Login Failed (User ID).")
        }
      }
    }
  }
  
  // MARK: - GET Convenience Methods
  func getFavoriteMovies(_ completionHandlerForFavMovies: @escaping (_ result: [TMDBMovie]?, _ error: NSError?) -> Void) {
    
    let parameters = [ApiClient.ParameterKeys.SessionID: ApiClient.sharedInstance().sessionID!]
    
    var mutableMethod: String = Methods.AccountIDFavoriteMovies
    mutableMethod = substituteKeyInMethod(mutableMethod, key: ApiClient.URLKeys.UserID, value: String(ApiClient.sharedInstance().userID!))!

    let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String:AnyObject]) { (results, error) in
      
      if let error = error {
        completionHandlerForFavMovies(nil, error)
      } else {
        
        if let results = results?[ApiClient.JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
          
          let movies = TMDBMovie.moviesFromResults(results)
          completionHandlerForFavMovies(movies, nil)
        } else {
          completionHandlerForFavMovies(nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
        }
      }
    }
  }
}
