//
//  ViewEvidanceViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 26/02/25.
//

import UIKit
import WebKit

class ViewEvidanceViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webVw: WKWebView!
    
    var objImageUrl = ""
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           webVw.navigationDelegate = self
           loadImage()
       }
       
       func loadImage() {
           guard let imageUrl = URL(string: objImageUrl) else { return }
           
           let htmlString = """
           <html>
           <head>
           <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=yes">
           <style>
           body {
               margin: 0;
               padding: 0;
               text-align: center;
               background-color: black;
           }
           img {
               width: 100%;
               height: auto;
           }
           </style>
           </head>
           <body>
           <img src="\(imageUrl.absoluteString)" alt="Image">
           </body>
           </html>
           """
           
           webVw.loadHTMLString(htmlString, baseURL: nil)
           webVw.scrollView.bounces = false
       }
    

    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
}
