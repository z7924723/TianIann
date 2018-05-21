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
  var keyboardOnScreen = false

  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
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

