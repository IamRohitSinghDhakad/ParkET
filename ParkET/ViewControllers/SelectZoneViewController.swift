//
//  SelectZoneViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class SelectZoneViewController: UIViewController {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblVw: UITableView!
    
    var arrZone = [ZoneModel]()
    
    var onZoneSelected: ((ZoneModel) -> Void)? // Closure to pass data back
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        call_WsGetZone() 
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.onBackPressed()
    }

}


extension SelectZoneViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrZone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectZoneTableViewCell", for: indexPath)as! SelectZoneTableViewCell
        
        let obj = self.arrZone[indexPath.row]
        
        cell.lblZoneName.text = obj.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedZone = arrZone[indexPath.row]
           onZoneSelected?(selectedZone) // Call the closure with the selected dictionary
           dismiss(animated: true, completion: nil) // Close the SelectZoneViewController
       }
    
}

extension SelectZoneViewController{
    
    func call_WsGetZone() {
        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "attender_id": objAppShareData.UserDetail.strUser_id
        ]
        
        let url = WsUrl.url_GetZone
        
        print("Sending OTP: \(params)")
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
    
            print(response)
            
            let status = response["status"] as? Int
            let message = response["message"] as? String
            
            if status == MessageConstant.k_StatusCode {
                if let arrZones = response["result"] as? [[String: Any]] {
                    
                    self.arrZone.removeAll()
                    
                    for data in arrZones{
                        let obj = ZoneModel(from: data)
                        self.arrZone.append(obj)
                    }
                    self.tblVw.reloadData()
                    
                    
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
