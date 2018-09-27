//
//  WebAuthViewController.swift
//  TianIann
//
//  Created by PinguMac on 2018/6/6.
//  Copyright © 2018年 PinguMac. All rights reserved.
//

import UIKit
import WebKit

class WebAuthViewController: UIViewController {
  
  // MARK: - Properties
  var urlRequest: URLRequest? = nil
  var requestToken: String? = nil
  var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
  
  // MARK: - Outlets
  @IBOutlet weak var webView: WKWebView!
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupWebViewNavigation()
    setupWebViewProperty()
  }
  
  // MARK: - Helper
  func setupWebViewNavigation() {
    navigationItem.title = "The MovieDB Auth"
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
  }
  
  func setupWebViewProperty() {
    webView.navigationDelegate = self
    webView.load(urlRequest!)
  }
  
  @objc func cancelAuth() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - TMDBAuthViewController: UIWebViewDelegate
extension WebAuthViewController: WKNavigationDelegate {
  
  // MARK: - webView(_:didFinish:)
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if webView.url!.absoluteString.contains(ApiClient.Constants.AccountURL) {
      if let urlRequest = urlRequest {
        webView.load(urlRequest)
      }
    }
    
    if webView.url!.absoluteString == "\(ApiClient.Constants.AuthorizationURL)\(requestToken!)/allow" {
      dismiss(animated: true) {
        self.completionHandlerForView!(true,nil)
      }
    }
  }

}
