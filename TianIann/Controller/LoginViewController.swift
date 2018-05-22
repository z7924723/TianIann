//
//  ViewController.swift
//  TianIann
//
//  Created by PinguMac on 2018/5/19.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var errorDisplayeLabel: UILabel!
  @IBOutlet weak var loginButton: CustomButton!
  
  // MARK: - Properties
  var apiConfiguration: ApiConfiguration!
  var keyboardOnScreen = false

  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    apiConfiguration = ApiConfiguration.shared
    
    configureUI()
    
    subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
    subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
    subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
    subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromAllNotifications()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: - LoginViewController: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  
  // MARK: - UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // MARK: - Show/Hide Keyboard
  @objc func keyboardWillShow(_ notification: Notification) {
    if !keyboardOnScreen {
      view.frame.origin.y -= keyboardHeight(notification)
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    if keyboardOnScreen {
      view.frame.origin.y += keyboardHeight(notification)
    }
  }
  
  @objc func keyboardDidShow(_ notification: Notification) {
    keyboardOnScreen = true
  }
  
  @objc func keyboardDidHide(_ notification: Notification) {
    keyboardOnScreen = false
  }
  
  private func keyboardHeight(_ notification: Notification) -> CGFloat {
    let userInfo = (notification as NSNotification).userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.cgRectValue.height
  }
  
  @IBAction func userDidTapView(_ sender: AnyObject) {
    resignIfFirstResponder(userNameTextField)
    resignIfFirstResponder(passwordTextField)
  }
  
  private func resignIfFirstResponder(_ textField: UITextField) {
    if textField.isFirstResponder {
      textField.resignFirstResponder()
    }
  }
}

// MARK: - LoginViewController (Configure UI)
private extension LoginViewController {
  private func configureUI() {
    configureTextField(userNameTextField)
    configureTextField(passwordTextField)
  }
  
  private func configureTextField(_ textField: UITextField) {
    textField.delegate = self
  }
  
  func setUIEnabled(_ enabled: Bool) {
    userNameTextField.isEnabled = enabled
    passwordTextField.isEnabled = enabled
    loginButton.isEnabled = enabled
    errorDisplayeLabel.text = ""
    errorDisplayeLabel.isEnabled = enabled
    
    // adjust login button alpha
    if enabled {
      loginButton.alpha = 1.0
    } else {
      loginButton.alpha = 0.5
    }
  }
}

// MARK: - LoginViewController (Actions)
private extension LoginViewController {
  @IBAction func loginPressed(_ sender: Any) {
    userDidTapView(self)
    
    if userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
      errorDisplayeLabel.text = "Username or Password Empty."
    } else {
      setUIEnabled(false)
      
      /*
       Steps for Authentication...
       https://www.themoviedb.org/documentation/api/sessions
       
       Step 1: Create a request token
       Step 2: Ask the user for permission via the API ("login")
       Step 3: Create a session ID
       
       Extra Steps...
       Step 4: Get the user id ;)
       Step 5: Go to the next view!
       */
      getRequestToken()
    }
  }
  
  // MARK: TheMovieDB
  private func getRequestToken() {
    /* TASK: Get a request token, then store it (apiConfiguration.requestToken) and login with the token */
    
    // 1. Set the parameters
    let methodParameters = [
      ApiConfiguration.TMDBParameterKeys.ApiKey: ApiConfiguration.TMDBParameterValues.ApiKey
    ]
    
    // 2/3. Build the URL, Configure the request
    let request = URLRequest(url: apiConfiguration.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/authentication/token/new"))

    // 4. Make the request
    let task = apiConfiguration.sharedSession.dataTask(with: request) { (data, response, error) in
      
      // If an error occurs, print it and re-enable the UI
      func displayError(_ error: String) {
        print(error)
        performUIUpdatesOnMain {
          self.setUIEnabled(true)
          self.errorDisplayeLabel.text = "Login Failed (Request Token)."
        }
      }

      // GUARD: Error occur
      guard (error == nil) else {
        displayError("There was an error with your request: \(error!)")
        return
      }
      
      // GUARD: Get a successful 2XX response
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        displayError("Your request returned a status code other than 2xx!")
        return
      }
      
      // GUARD: Any data returned
      guard let data = data else {
        displayError("No data was returned by the request!")
        return
      }
      
      // 5. Parse the data
      let parsedResult: [String:AnyObject]!
      do {
        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
      } catch {
        displayError("Could not parse the data as JSON: '\(data)'")
        return
      }
      
      // GUARD: TheMovieDB return an error
      if let _ = parsedResult[ApiConfiguration.TMDBResponseKeys.StatusCode] as? Int {
        displayError("TheMovieDB returned an error. See the '\(ApiConfiguration.TMDBResponseKeys.StatusCode)' and '\(ApiConfiguration.TMDBResponseKeys.StatusMessage)' in \(parsedResult)")
        return
      }
      
      // GUARD: Received the "request_token" key in parsedResult
      guard let requestToken = parsedResult[ApiConfiguration.TMDBResponseKeys.RequestToken] as? String else {
        displayError("Cannot find key '\(ApiConfiguration.TMDBResponseKeys.RequestToken)' in \(parsedResult)")
        return
      }
      
      self.apiConfiguration.requestToken = requestToken
      self.loginWithToken(self.apiConfiguration.requestToken!)
    }
    
    task.resume()
  }
  
  private func loginWithToken(_ requestToken: String) {
    /* TASK: Login, then get a session id */
    
    let methodParameters = [
      ApiConfiguration.TMDBParameterKeys.ApiKey: ApiConfiguration.TMDBParameterValues.ApiKey,
      ApiConfiguration.TMDBParameterKeys.RequestToken: requestToken,
      ApiConfiguration.TMDBParameterKeys.Username: userNameTextField.text!,
      ApiConfiguration.TMDBParameterKeys.Password: passwordTextField.text!
    ]
    
    let request = URLRequest(url: apiConfiguration.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/authentication/token/validate_with_login"))

    let task = apiConfiguration.sharedSession.dataTask(with: request) { (data, response, error) in
      
      func displayError(_ error: String) {
        print(error)
        performUIUpdatesOnMain {
          self.setUIEnabled(true)
          self.errorDisplayeLabel.text = "Login Failed (Session ID)."
        }
      }
      
      guard (error == nil) else {
        displayError("There was an error with your request: \(error!)")
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        displayError("Your request returned a status code other than 2xx!")
        return
      }
      
      guard let data = data else {
        displayError("No data was returned by the request!")
        return
      }
      
      let parsedResult: [String:AnyObject]!
      do {
        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
      } catch {
        displayError("Could not parse the data as JSON: '\(data)'")
        return
      }
      
      print(parsedResult)
      if let _ = parsedResult[ApiConfiguration.TMDBResponseKeys.StatusCode] as? Int {
        displayError("TheMovieDB returned an error. See the '\(ApiConfiguration.TMDBResponseKeys.StatusCode)' and '\(ApiConfiguration.TMDBResponseKeys.StatusMessage)' in \(parsedResult)")
        return
      }
      
      guard let success = parsedResult[ApiConfiguration.TMDBResponseKeys.Success] as? Bool, success == true else {
        displayError("Cannot find key '\(ApiConfiguration.TMDBResponseKeys.Success)' in \(parsedResult)")
        return
      }
      
      self.getSessionID(self.apiConfiguration.requestToken!)
      
    }
    task.resume()
  }
  
  private func getSessionID(_ requestToken: String) {
    let methodParameters = [
      ApiConfiguration.TMDBParameterKeys.ApiKey: ApiConfiguration.TMDBParameterValues.ApiKey,
      ApiConfiguration.TMDBParameterKeys.RequestToken: requestToken
    ]
    
    let request = URLRequest(url: apiConfiguration.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/authentication/session/new"))

    let task = apiConfiguration.sharedSession.dataTask(with: request) { (data, response, error) in
      
      func displayError(_ error: String, debugLabelText: String? = nil) {
        print(error)
        performUIUpdatesOnMain {
          self.setUIEnabled(true)
          self.errorDisplayeLabel.text = "Login Failed (Session ID)."
        }
      }
      
      guard (error == nil) else {
        displayError("There was an error with your request: \(error!)")
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        displayError("Your request returned a status code other than 2xx!")
        return
      }
      
      guard let data = data else {
        displayError("No data was returned by the request!")
        return
      }
      
      let parsedResult: [String:AnyObject]!
      do {
        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
      } catch {
        displayError("Could not parse the data as JSON: '\(data)'")
        return
      }
      
      if let _ = parsedResult[ApiConfiguration.TMDBResponseKeys.StatusCode] as? Int {
        displayError("TheMovieDB returned an error. See the '\(ApiConfiguration.TMDBResponseKeys.StatusCode)' and '\(ApiConfiguration.TMDBResponseKeys.StatusMessage)' in \(parsedResult)")
        return
      }
      
      guard let sessionID = parsedResult[ApiConfiguration.TMDBResponseKeys.SessionID] as? String else {
        displayError("Cannot find key '\(ApiConfiguration.TMDBResponseKeys.SessionID)' in \(parsedResult)")
        return
      }
      
      self.apiConfiguration.sessionID = sessionID
//      self.getUserID(self.appDelegate.sessionID!)
    }
    task.resume()
  }
}

// MARK: - LoginViewController (Notifications)
private extension LoginViewController {
  
  func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
    NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
  }
  
  func unsubscribeFromAllNotifications() {
    NotificationCenter.default.removeObserver(self)
  }
}

