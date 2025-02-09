//
//  VehicleViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 20/12/24.
//

import UIKit

class VehicleViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    
    var arrVehicle = [VehicleModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_WsGetVehicleList()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
   
    @IBAction func btnOnAddVehicle(_ sender: Any) {
        pushVc(viewConterlerId: "AddVehicleViewController")
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
    
}
