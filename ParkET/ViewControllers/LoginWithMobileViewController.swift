//
//  LoginWithMobileViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class LoginWithMobileViewController: UIViewController {

    @IBOutlet weak var tfMobileNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnSubmit(_ sender: Any) {
        
        self.pushVc(viewConterlerId: "OTPViewController")
        
    }
   

}
