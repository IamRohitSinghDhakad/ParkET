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

        self.tfEmail.text = "8871179252"
        self.tfPassword.text = "Qwerty@123"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSavedLoginDetails()
    }
    
    @IBAction func btnOnRememberMe(_ sender: UIButton) {
        sender.isSelected.toggle()  // Toggle selection state
           
           if sender.isSelected {
               // Save login details
               UserDefaults.standard.set(tfEmail.text, forKey: "savedEmail_attender")
               UserDefaults.standard.set(tfPassword.text, forKey: "savedPassword_attender")
               UserDefaults.standard.set(true, forKey: "isRemembered")
               btnRememberMe.setImage(UIImage(named: "square_fill"), for: .normal)
           } else {
               // Remove login details
               UserDefaults.standard.removeObject(forKey: "savedEmail_attender")
               UserDefaults.standard.removeObject(forKey: "savedPassword_attender")
               UserDefaults.standard.set(false, forKey: "isRemembered")
               btnRememberMe.setImage(UIImage(named: "square"), for: .normal)
           }
    }
    
    func loadSavedLoginDetails() {
        let isRemembered = UserDefaults.standard.bool(forKey: "isRemembered")
        
        if isRemembered {
            tfEmail.text = UserDefaults.standard.string(forKey: "savedEmail_attender")
            tfPassword.text = UserDefaults.standard.string(forKey: "savedPassword_attender")
            btnRememberMe.isSelected = true
            btnRememberMe.setImage(UIImage(named: "square_fill"), for: .normal)
        } else {
            tfEmail.text = ""
            tfPassword.text = ""
            btnRememberMe.isSelected = false
            btnRememberMe.setImage(UIImage(named: "square"), for: .normal)
        }
    }

    
    @IBAction func btnSubmit(_ sender: Any) {

        self.call_WsLogin()
        
    }
   
    

}

extension LoginWithMobileViewController{
    
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
      
        dicrParam = ["username":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "type":strType,
                         "register_id":objAppShareData.strFirebaseToken]as [String:Any]
            
        url = WsUrl.url_Attender_login
        
        
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
    
    func setRootController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarAttenderViewController") as? TabBarAttenderViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
}
