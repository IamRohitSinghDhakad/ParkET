//
//  ProfileViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 21/12/24.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmailAddress: UITextField!
    @IBOutlet weak var tfmobileNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgVwUser.cornerRadius = self.imgVwUser.frame.height/2
    }
    

    @IBAction func btnOnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnonUpdate(_ sender: Any) {
        
    }
    @IBAction func btnOnOpencamera(_ sender: Any) {
        MediaPicker.shared.pickMedia(from: self) { image in
            self.imgVwUser.image = image
        }
    }
    
}
