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
  
  private lazy var dataManager = {
    return DataManager()
  }()

  
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
  
  func displayError(_ errorString: String?) {
    if let errorString = errorString {
      errorDisplayeLabel.text = errorString
    }
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
  
  // MARK: - loginPressed
  @IBAction func loginPressed(_ sender: Any) {
    ApiClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
      performUIUpdatesOnMain {
        if success {
          self.completeLogin()
        } else {
          self.displayError(errorString)
        }
      }
    }
  }
  
  private func completeLogin() {
    errorDisplayeLabel.text = ""
//    let controller = storyboard!.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    let ViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    present(ViewController, animated: true, completion: nil)
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

