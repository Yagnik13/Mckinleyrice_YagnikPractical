//
//  WebViewController.swift
//  YagnikPractical
//
//  Created by Yagnik Suthar on 14/03/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var webView: WKWebView!
    
    //MARK:- Properties
    var urlToLoad: String = "https://mckinleyrice.com?token="
    var token: String = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Web View"
        webView.backgroundColor = .white
        webView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if IS_INTERNET_AVAILABLE() {
            if let url = URL(string: urlToLoad + token) {
                let urlRequest = URLRequest(url: url)
                ActivityIndicator.sharedInstance.showHUD(show: true, VC: self)
                webView.load(urlRequest)
            }
        }else {
            showAlertWithTitleFromVC(vc: self, andMessage: "Please check your internet connection, Please try again later")
        }
    }
}

//MARK:- WKNavigationDelegate Methods
extension WebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        ActivityIndicator.sharedInstance.showHUD(show: false, VC: self)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ActivityIndicator.sharedInstance.showHUD(show: false, VC: self)
    }
}
