//
//  ProfileViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 21/12/24.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var tfmobileNumber: UITextField!
    
    var objUser = UserModel(from: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgVwUser.cornerRadius = self.imgVwUser.frame.height/2
        self.call_WsGetProfile()
    }
    

    @IBAction func btnOnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnonUpdate(_ sender: Any) {
        
    }
    @IBAction func btnOnOpencamera(_ sender: Any) {
        MediaPicker.shared.pickMedia(from: self) { image in
            self.imgVwUser.image = image
        }
    }
    
}


extension ProfileViewController{
    
    func call_WsGetProfile() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "login_user_id": objAppShareData.UserDetail.strUser_id
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let user_details = response["result"] as? [String: Any] {
                  
                    self.objUser = UserModel.init(from: user_details)
                    
                    self.tfFullName.text = self.objUser.name
                    self.tfmobileNumber.text = self.objUser.mobile
                    self.tfEmailAddress.text = self.objUser.strEmail
                    
                    let imageUrl  = self.objUser.user_image
                    if imageUrl != "" {
                        let url = URL(string: imageUrl)
                        self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
                       
                    }else{
                        self.imgVwUser.image = #imageLiteral(resourceName: "logo")
                        
                    }
                    
                    
                } else {
                  
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
