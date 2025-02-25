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
//                let message = response["message"] as? String ?? "Something went wrong!"
//                objAlert.showAlert(message: message, title: "", controller: self)
                self.showToast(message: "No Notification Found!!")
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
    
    func showToast(message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let toastLabel = UILabel(frame: CGRect(x: 20, y: window.frame.height - 120, width: window.frame.width - 40, height: 40))
        toastLabel.backgroundColor = .white
        toastLabel.textColor = .red
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true

        window.addSubview(toastLabel)  // Add toast to key window so it's above the tab bar

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
}
