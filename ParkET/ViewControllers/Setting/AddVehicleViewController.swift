//
//  AddVehicleViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 20/12/24.
//

import UIKit

class AddVehicleViewController: UIViewController {

    @IBOutlet weak var tfcarBrand: UITextField!
    @IBOutlet weak var tfModelVarient: UITextField!
    @IBOutlet weak var tfCarNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

    }

    @IBAction func btnOnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    @IBAction func btnOnSubmit(_ sender: Any) {
    }
}
