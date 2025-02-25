//
//  HomeAttenderViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class HomeAttenderViewController: UIViewController {
    
    @IBOutlet weak var tfParkingLotNumber: UITextField!
    
    var obj:ZoneModel?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    @IBAction func btnOnSearch(_ sender: Any) {
        
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "DetailsZoneViewController")as! DetailsZoneViewController
        vc.objZone = self.obj
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @IBAction func btnOpenList(_ sender: Any) {
        if let selectZoneVC = storyboard?.instantiateViewController(withIdentifier: "SelectZoneViewController") as? SelectZoneViewController {
            selectZoneVC.onZoneSelected = { [weak self] selectedZone in
                self?.obj = selectedZone
                if let zoneName = selectedZone.name,
                   let zoneId = selectedZone.id {
                    self?.tfParkingLotNumber.text = "\(zoneName) (ID: \(zoneId))" // Update the text field
                }
            }
            present(selectZoneVC, animated: true, completion: nil)
        }
    }
}

extension HomeAttenderViewController{
    

    
}
