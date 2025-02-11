//
//  AddVehicleViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 20/12/24.
//

import UIKit

class AddVehicleViewController: UIViewController {

    @IBOutlet weak var tfcarBrand: UITextField!
    @IBOutlet weak var tfModelVarient: UITextField!
    @IBOutlet weak var tfCarNumber: UITextField!
    
    var obj : VehicleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        self.tfcarBrand.text =  self.obj?.brand
        self.tfModelVarient.text =  self.obj?.model
        self.tfCarNumber.text =  self.obj?.vehicle_no

    }

    @IBAction func btnOnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    @IBAction func btnOnSubmit(_ sender: Any) {
        self.call_WsAddVehicle(strVehicle_Id: obj?.vehicle_id ?? "")
    }
}


extension AddVehicleViewController {
    
    
    func call_WsAddVehicle(strVehicle_Id: String) {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id,
            "vehicle_id":strVehicle_Id,
            "brand":self.tfcarBrand.text!,
            "model":self.tfModelVarient.text!,
            "vehicle_no":self.tfCarNumber.text!
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_AddVehicle, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
               
                objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Success", message: "Vehicle Added successfully", controller: self) {
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
