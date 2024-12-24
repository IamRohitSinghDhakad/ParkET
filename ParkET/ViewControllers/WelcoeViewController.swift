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
        self.pushVc(viewConterlerId: "LoginViewController")
    }
    
    @IBAction func btnOnAttender(_ sender: Any) {
        self.pushVc(viewConterlerId: "LoginWithMobileViewController")
    }
    
}
