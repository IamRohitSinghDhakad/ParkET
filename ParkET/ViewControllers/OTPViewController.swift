//
//  OTPViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var tfOne: UITextField!
    @IBOutlet weak var tfTwo: UITextField!
    @IBOutlet weak var tfThree: UITextField!
    @IBOutlet weak var tfFour: UITextField!
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
         
         setupTextFields()
     }
    
    @IBAction func btnOnResendCode(_ sender: Any) {
        
    }
    @IBAction func btnOnVerify(_ sender: Any) {
        sendOTPToAPI()
    }
     
     private func setupTextFields() {
         tfOne.delegate = self
         tfTwo.delegate = self
         tfThree.delegate = self
         tfFour.delegate = self
         
         // Ensure only one character can be entered
         [tfOne, tfTwo, tfThree, tfFour].forEach { textField in
             textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
         }
         
         // Open keyboard automatically for the first field
         tfOne.becomeFirstResponder()
     }
     
     @objc func textFieldDidChange(_ textField: UITextField) {
         guard let text = textField.text else { return }
         
         if text.count == 1 { // Move to the next field if available
             switch textField {
             case tfOne: tfTwo.becomeFirstResponder()
             case tfTwo: tfThree.becomeFirstResponder()
             case tfThree: tfFour.becomeFirstResponder()
             case tfFour:
                 tfFour.resignFirstResponder() // Close keyboard
               //  sendOTPToAPI() // Auto-send OTP after entering the last digit
             default: break
             }
         } else if text.isEmpty { // Move back when deleting
             switch textField {
             case tfFour: tfThree.becomeFirstResponder()
             case tfThree: tfTwo.becomeFirstResponder()
             case tfTwo: tfOne.becomeFirstResponder()
             default: break
             }
         }
     }
     
     // Ensure only one digit can be entered
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if string.isEmpty { // Allow backspace
             return true
         }
         return textField.text?.count == 0 // Prevent more than one character
     }
     
     private func sendOTPToAPI() {
         let otpCode = "\(tfOne.text ?? "")\(tfTwo.text ?? "")\(tfThree.text ?? "")\(tfFour.text ?? "")"
         
         if otpCode.count == 4 {
             call_WsVerifyOTP(otp: otpCode)
         } else {
             objAlert.showAlert(message: "Please enter a valid 4-digit OTP.", title: "Error", controller: self)
         }
     }
     
  
     
     func setRootController() {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarAttenderViewController") as? TabBarAttenderViewController)!
         let navController = UINavigationController(rootViewController: vc)
         navController.isNavigationBarHidden = true
         appDelegate.window?.rootViewController = navController
     }
}


extension OTPViewController{
    
    func call_WsVerifyOTP(otp: String) {
        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "otp": otp,
            "user_id": objAppShareData.UserDetail.strUser_id,
            "register_id": objAppShareData.UserDetail.register_id ?? ""
        ]
        
        let url = WsUrl.url_verify_otp
        
        print("Sending OTP: \(params)")
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = response["status"] as? Int
            let message = response["message"] as? String
            
            if status == MessageConstant.k_StatusCode {
                if let _ = response["result"] as? [String: Any] {
                    self.setRootController()
                } else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            } else {
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "Invalid OTP", title: "", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error: \(error)")
        }
    }
    
}
