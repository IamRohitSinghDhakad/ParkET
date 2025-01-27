//
//  SelectZoneViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class SelectZoneViewController: UIViewController {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblVw: UITableView!
    
    let zones = [
           ["name": "Zone A", "id": 1],
           ["name": "Zone B", "id": 2],
           ["name": "Zone C", "id": 3],
           ["name": "Zone D", "id": 4],
           ["name": "Zone E", "id": 5]
       ] // Example zones with IDs
    
    var onZoneSelected: (([String: Any]) -> Void)? // Closure to pass data back
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.onBackPressed()
    }

}


extension SelectZoneViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectZoneTableViewCell", for: indexPath)as! SelectZoneTableViewCell
        if let zoneName = zones[indexPath.row]["name"] as? String {
            cell.lblZoneName?.text = zoneName // Assign zone name
             }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let selectedZone = zones[indexPath.row]
           onZoneSelected?(selectedZone) // Call the closure with the selected dictionary
           dismiss(animated: true, completion: nil) // Close the SelectZoneViewController
       }
    
    
    
    
}
