//
//  HomeAttenderViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class HomeAttenderViewController: UIViewController {

    @IBOutlet weak var tfParkingLotNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnOnSearch(_ sender: Any) {
        self.pushVc(viewConterlerId: "DetailsZoneViewController")
    }
    @IBAction func btnOpenList(_ sender: Any) {
        self.presentVC(viewConterlerId: "SelectZoneViewController")
    }
}
