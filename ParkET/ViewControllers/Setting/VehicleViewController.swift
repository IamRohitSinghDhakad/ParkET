//
//  VehicleViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 20/12/24.
//

import UIKit

class VehicleViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var vwSubVw: UIView!
    
    var arrVehicle = [VehicleModel]()
    var strSelectedIndex = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.call_WsGetVehicleList()
        self.vwSubVw.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_WsGetVehicleList()
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.strSelectedIndex = -1
        self.onBackPressed()
    }
    
    @IBAction func btnCloseSubvw(_ sender: Any) {
        self.vwSubVw.isHidden = true
        self.strSelectedIndex = -1
    }
    
    @IBAction func btnOnAddVehicle(_ sender: Any) {
        pushVc(viewConterlerId: "AddVehicleViewController")
    }
    
    @IBAction func btnEditVehicle(_ sender: Any) {
        self.vwSubVw.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVehicleViewController")as! AddVehicleViewController
        vc.obj = self.arrVehicle[strSelectedIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSetAsDefault(_ sender: Any) {
        self.call_WsSetDefault(strVehicle_Id: self.arrVehicle[strSelectedIndex].vehicle_id ?? "")
    }
    
    
}

extension VehicleViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVehicle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleTableViewCell", for: indexPath)as! VehicleTableViewCell
        
       
        let obj = self.arrVehicle[indexPath.row]
        
        cell.lblModel.text = "\(obj.brand ?? "") (\(obj.model ?? ""))"
        cell.lblCarNumber.text = obj.vehicle_no
        
        if obj.is_default == "1"{
            cell.lblDefault.isHidden = false
        }else{
            cell.lblDefault.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.vwSubVw.isHidden = false
        strSelectedIndex = indexPath.row
    }
}



extension VehicleViewController{
    
    func call_WsGetVehicleList() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetVehicle, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                self.arrVehicle.removeAll()
                if let resultArray = response["result"] as? [[String: Any]] {
                    self.arrVehicle = resultArray.map { VehicleModel(from: $0) }
                    self.tblVw.reloadData()
                    
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
    
    
    
    func call_WsSetDefault(strVehicle_Id: String) {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id,
            "default_vehicle":strVehicle_Id
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_UpdateProfile, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                self.vwSubVw.isHidden = true
                self.call_WsGetVehicleList()
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
