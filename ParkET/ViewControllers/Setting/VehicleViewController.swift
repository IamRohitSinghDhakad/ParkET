//
//  VehicleViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 20/12/24.
//

import UIKit

class VehicleViewController: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    
   
    @IBAction func btnOnAddVehicle(_ sender: Any) {
        pushVc(viewConterlerId: "AddVehicleViewController")
    }
    
}

extension VehicleViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleTableViewCell", for: indexPath)as! VehicleTableViewCell
        
        if indexPath.row == 2{
            cell.veDefault.isHidden = false
        }else{
            cell.veDefault.isHidden = true
        }
        
        return cell
    }
    
    
    
    
    
}
