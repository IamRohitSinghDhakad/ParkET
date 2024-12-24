//
//  WebViewController.swift
//  Bubble
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 24/09/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var btnOnBack: UIButton!
    @IBOutlet weak var webVw: WKWebView!
    @IBOutlet weak var lblHeadingTitle: UILabel!
    
    var isComingfrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeadingTitle.text = self.isComingfrom
        
        self.webVw.navigationDelegate = self
        self.webVw.uiDelegate = self
        
        var loadUrl = ""
        switch isComingfrom {
        case "Privacy Policy":
            loadUrl = "page/Privacy"
        case "Terms & Conditions":
            loadUrl = "page/Terms"
        default:
            break
        }
        
        
        // Do any additional setup after loading the view.
        if let url = URL(string: BASE_URL + loadUrl) {
            print(url)
            
            let request = URLRequest(url: url)
            self.webVw.load(request)
            
        }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
}



extension WebViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler{
    
    // WKNavigationDelegate methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Called when the web view finishes loading a page
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Called when the web view fails to load a page
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // Called when the web view begins to receive content
    }
    
    // WKUIDelegate methods
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Called when a link with target="_blank" is clicked
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        // Called when a web view that was created programmatically is closed
    }
    
    // WKScriptMessageHandler methods
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Called when a JavaScript message is received from the web view
    }
}
