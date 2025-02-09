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

        self.goToNextController()
        
    }
    
    @IBAction func btnOnDriver(_ sender: Any) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        vc.strType = "User"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnAttender(_ sender: Any) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "LoginWithMobileViewController")as! LoginWithMobileViewController
        vc.strType = "Attender"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Redirection Methods
    func goToNextController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if AppSharedData.sharedObject().isLoggedIn {
            let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarUserViewController") as? TabBarUserViewController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
        else {
//            let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
//            let navController = UINavigationController(rootViewController: vc)
//            navController.isNavigationBarHidden = true
//            appDelegate.window?.rootViewController = navController
        }
    }
}
