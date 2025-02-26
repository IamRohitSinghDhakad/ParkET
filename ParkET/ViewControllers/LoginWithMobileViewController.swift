//
//  LoginWithMobileViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class LoginWithMobileViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnRememberMe: UIButton!
    
    var strType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnRememberMe(_ sender: Any) {
        
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
//        if self.validateFields(){
//            self.view.endEditing(true)
//           // self.call_WsLogin()
//        }
    }
   
    

}

extension LoginWithMobileViewController{
    
//    func call_WsLogin(){
//        
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//        
//        objWebServiceManager.showIndicator()
//        
//        var dicrParam = [String:Any]()
//        
//        var url = ""
//        
//        dicrParam = ["mobile":self.tfMobileNumber.text!]as [String:Any]
//            
//        url = WsUrl.url_Attender
//        
//        
//        print(dicrParam)
//        
//        
//        
//        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
//            objWebServiceManager.hideIndicator()
//            
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//            print(response)
//            if status == MessageConstant.k_StatusCode{
//                if let user_details  = response["result"] as? [String:Any] {
//                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
//                    objAppShareData.fetchUserInfoFromAppshareData()
//                    self.pushVc(viewConterlerId: "OTPViewController")
//                }
//                else {
//                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
//                }
//            }else{
//                objWebServiceManager.hideIndicator()
//                if let msgg = response["result"]as? String{
//                    objAlert.showAlert(message: msgg, title: "", controller: self)
//                }else{
//                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
//                }
//                
//                
//            }
//            
//            
//        } failure: { (Error) in
//            //  print(Error)
//            objWebServiceManager.hideIndicator()
//        }
//    }
    
}
