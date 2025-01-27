//
//  WelcoeViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 11/12/24.
//

import UIKit

class WelcoeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnOnDriver(_ sender: Any) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        vc.strType = "Driver"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnAttender(_ sender: Any) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "LoginWithMobileViewController")as! LoginWithMobileViewController
        vc.strType = "Attender"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
