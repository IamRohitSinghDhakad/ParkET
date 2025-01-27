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
        if let selectZoneVC = storyboard?.instantiateViewController(withIdentifier: "SelectZoneViewController") as? SelectZoneViewController {
            selectZoneVC.onZoneSelected = { [weak self] selectedZone in
                if let zoneName = selectedZone["name"] as? String,
                   let zoneId = selectedZone["id"] as? Int {
                    self?.tfParkingLotNumber.text = "\(zoneName) (ID: \(zoneId))" // Update the text field
                }
            }
            present(selectZoneVC, animated: true, completion: nil)
        }
    }
}
