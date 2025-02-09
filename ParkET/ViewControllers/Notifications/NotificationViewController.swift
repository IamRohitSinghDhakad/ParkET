//
//  NotificationViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 20/12/24.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    
    var arrNotification = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_WsGetNotificationList()
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath)as! NotificationTableViewCell
        
        let obj = self.arrNotification[indexPath.row]
        
        cell.lbltiutle.text = obj.message
        
        return cell
        
    }
    
}


extension NotificationViewController{
    
    func call_WsGetNotificationList() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetNotofication, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [[String: Any]] {
                    self.arrNotification = resultArray.map { NotificationModel(from: $0) }
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
