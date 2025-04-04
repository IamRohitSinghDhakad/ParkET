//
//  LoginViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 11/12/24.
//

import UIKit

class LoginViewController: UIViewController {

    var strType = ""
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnRememberMe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSavedLoginDetails()
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        if self.validateFields(){
            self.view.endEditing(true)
            self.call_WsLogin()
        }
    }
    @IBAction func btnOnForgotPassword(_ sender: Any) {
        
    }
    @IBAction func btnOnGoogleSignIn(_ sender: Any) {
        
    }
    
    @IBAction func btnOnRememberMe(_ sender: UIButton) {
        sender.isSelected.toggle()  // Toggle selection state
           
           if sender.isSelected {
               // Save login details
               UserDefaults.standard.set(tfUserName.text, forKey: "savedEmail")
               UserDefaults.standard.set(tfPassword.text, forKey: "savedPassword")
               UserDefaults.standard.set(true, forKey: "isRemembered")
               btnRememberMe.setImage(UIImage(named: "square_fill"), for: .normal)
           } else {
               // Remove login details
               UserDefaults.standard.removeObject(forKey: "savedEmail")
               UserDefaults.standard.removeObject(forKey: "savedPassword")
               UserDefaults.standard.set(false, forKey: "isRemembered")
               btnRememberMe.setImage(UIImage(named: "square"), for: .normal)
           }
    }
    
    func loadSavedLoginDetails() {
        let isRemembered = UserDefaults.standard.bool(forKey: "isRemembered")
        
        if isRemembered {
            tfUserName.text = UserDefaults.standard.string(forKey: "savedEmail")
            tfPassword.text = UserDefaults.standard.string(forKey: "savedPassword")
            btnRememberMe.isSelected = true
            btnRememberMe.setImage(UIImage(named: "square_fill"), for: .normal)
        } else {
            tfUserName.text = ""
            tfPassword.text = ""
            btnRememberMe.isSelected = false
            btnRememberMe.setImage(UIImage(named: "square"), for: .normal)
        }
    }


    func setRootController(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarUserViewController") as? TabBarUserViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    @IBAction func btnOnSignUp(_ sender: Any) {
        self.pushVc(viewConterlerId: "SignUpViewController")
    }
    
    func validateFields() -> Bool {
        guard let email = tfUserName.text, !email.isEmpty else {
            // Show an error message for empty email
            objAlert.showAlert(message: "Please Enter Username".localized(), controller: self)
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        guard emailPred.evaluate(with: email) else {
            // Show an error message for invalid email format
            objAlert.showAlert(message: "Username is not valid".localized(), controller: self)
            return false
        }
        
        guard let password = tfPassword.text, !password.isEmpty else {
            // Show an error message for empty password
            objAlert.showAlert(message: "Please Enter Password".localized(), controller: self)
            return false
        }
        
        // All validations pass
        return true
    }
    
}

extension LoginViewController{
    
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        
        dicrParam = ["username":self.tfUserName.text!,
                         "password":self.tfPassword.text!,
                         "type":strType,
                         "register_id":objAppShareData.strFirebaseToken]as [String:Any]
            
            url = WsUrl.url_Login
        
        
        print(dicrParam)
        
        
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.setRootController()
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
                
                
            }
            
            
        } failure: { (Error) in
            //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
