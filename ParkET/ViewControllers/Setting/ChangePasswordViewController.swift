//
//  ChangePasswordViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 21/12/24.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOnUpdatePassword(_ sender: Any) {
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        onBackPressed()
    }
    
}
