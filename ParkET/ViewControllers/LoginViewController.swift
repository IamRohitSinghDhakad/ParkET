//
//  LoginViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 11/12/24.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        setRootController()
    }
    
    func setRootController(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarUserViewController") as? TabBarUserViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    @IBAction func btnOnSignUp(_ sender: Any) {
        self.pushVc(viewConterlerId: "SignUpViewController")
    }
    
}
