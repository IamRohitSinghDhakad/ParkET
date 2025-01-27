//
//  EnhancedFineViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class EnhancedFineViewController: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var tfFineamount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnback(_ sender: Any) {
        self.onBackPressed()
    }
    
  
    @IBAction func btnOnSubmit(_ sender: Any) {
    }
    
    @IBAction func btnAddImage(_ sender: Any) {
        MediaPicker.shared.pickMedia(from: self) { image in
            self.imgVw.image = image
        }
    }
}
