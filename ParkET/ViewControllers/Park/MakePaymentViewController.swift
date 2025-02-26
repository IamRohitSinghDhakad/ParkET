//
//  MakePaymentViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 25/02/25.
//

import UIKit
@preconcurrency import WebKit


protocol MakePaymentDelegate: AnyObject {
    func paymentDidComplete(success: Bool)
}

class MakePaymentViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webVw: WKWebView!
    weak var delegate: MakePaymentDelegate?
    var strTotalPayment = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "https://ambitious.in.net/Shubham/parket/index.php/api/card_view?amount=\(self.strTotalPayment)") else {
            print("Invalid URL")
            return
        }
        
        print(url)
        
        let request = URLRequest(url: url)
        webVw.navigationDelegate = self  // Set delegate to handle responses
        webVw.load(request)
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    // Handle Navigation Response
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url?.absoluteString {
            print(url)
            if url.contains("success") {  // Replace with actual success URL pattern
                handlePaymentSuccess()
            } else if url.contains("cancel") {  // Replace with actual cancel URL pattern
                handlePaymentCancel()
            }
        }
        decisionHandler(.allow)
    }
    
    private func handlePaymentSuccess() {
        let alert = UIAlertController(title: "Payment Successful", message: "Your payment has been processed successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.delegate?.paymentDidComplete(success: true)  // Notify about success
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func handlePaymentCancel() {
        let alert = UIAlertController(title: "Payment Canceled", message: "Your payment was not completed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.delegate?.paymentDidComplete(success: false)  // Notify about cancellation
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}
