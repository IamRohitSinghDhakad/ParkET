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

        self.pushVc(viewConterlerId: "LoginViewController")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
