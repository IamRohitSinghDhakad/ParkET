//
//  SignUpViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 13/12/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnSignUp(_ sender: Any) {
    }
    @IBAction func btnOnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
}
