//
//  ChangePasswordViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 21/12/24.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func btnOnUpdatePassword(_ sender: Any) {
        
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        onBackPressed()
    }
    
}


extension ChangePasswordViewController{
    
    func call_WsAChangePassword() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id,
            "new_password":self.tfNewPassword.text!
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_ChangePassword, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
               
                objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Success", message: "Password chnage successfully", controller: self) {
                    self.onBackPressed()
                }
                
            } else {
                let message = response["message"] as? String ?? "Something went wrong!"
                objAlert.showAlert(message: message, title: "", controller: self)
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
    
}
