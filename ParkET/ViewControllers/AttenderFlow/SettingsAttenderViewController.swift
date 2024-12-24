//
//  SettingsAttenderViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class SettingsAttenderViewController: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    
    var arrSettings = ["Privacy Policy", "Contact Us", "About Us", "Logout", "Delete Account"]
    var arrSettingsImages = [#imageLiteral(resourceName: "car 2"), #imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "privacy"), #imageLiteral(resourceName: "privacy"), #imageLiteral(resourceName: "contact"), #imageLiteral(resourceName: "about"), #imageLiteral(resourceName: "logout"), #imageLiteral(resourceName: "active")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension SettingsAttenderViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath)as! SettingTableViewCell
        
        cell.lblTitle.text = self.arrSettings[indexPath.row]
        cell.imgVw.image = self.arrSettingsImages[indexPath.row]
        cell.imgVw.setImageColor(color: .darkGray)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingfrom = "Privacy Policy"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            pushVc(viewConterlerId: "ContactUsViewController")
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingfrom = "About Us"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            objAlert.showAlertCallBack(alertLeftBtn: "Yes".localized(), alertRightBtn: "No".localized(), title: "Logout alert".localized(), message: "Are you sure you want to logout?".localized(), controller: self) {
                objAppShareData.signOut()
            }
        case 4:
            objAlert.showAlertCallBack(alertLeftBtn: "Yes".localized(), alertRightBtn: "No".localized(), title: "Delete Account".localized(), message: "Are you sure you want to delete your account It will erashe all your records and never restore back?".localized(), controller: self) {
                objAppShareData.signOut()
            }
        default:
            break
        }
    }
    
    
    
}
