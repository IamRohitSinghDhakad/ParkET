//
//  DetailsZoneViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class DetailsZoneViewController: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var vwIssuefine: UIView!
    
    // Property to track visibility state of vwTimer for active tab
    //  var activeTabStates: [CellState] = []
    // Track which rows have the vwTimer visible
    var isTimerVisible: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwIssuefine.isHidden = true
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        // Register the Nib
        let nib = UINib(nibName: "DetailTableViewCell", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "DetailTableViewCell")
        
        // Initialize visibility state for all rows (set to false initially)
        isTimerVisible = Array(repeating: false, count: 5) // Match the number of rows in your table view
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    @IBAction func btnHideView(_ sender: Any) {
        self.vwIssuefine.isHidden = true
    }
    
    @IBAction func btnOnissuefine(_ sender: Any) {
        self.vwIssuefine.isHidden = true
        self.pushVc(viewConterlerId: "IssueFineViewController")
    }
    
    @IBAction func btnOnEnhanceFine(_ sender: Any) {
        self.vwIssuefine.isHidden = true
        self.pushVc(viewConterlerId: "EnhancedFineViewController")
    }
}

extension DetailsZoneViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // Number of rows in the table view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        
        // Configure the cell
        cell.configure(for: indexPath.row)
        
        // Update the visibility of vwTimer based on the stored state
        cell.vwTimer.isHidden = !isTimerVisible[indexPath.row]
        
        // Add target for the Show/Hide button
        cell.btnOnShowHide.tag = indexPath.row // Use the tag to identify the row
        cell.btnOnShowHide.addTarget(self, action: #selector(btnOnShowHideTimer(_:)), for: .touchUpInside)
        
        cell.btnOnFines.tag = indexPath.row // Use the tag to identify the row
        cell.btnOnFines.addTarget(self, action: #selector(btnOnFine(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnOnShowHideTimer(_ sender: UIButton) {
        // Identify the row of the button clicked
        let row = sender.tag
        
        // Toggle the visibility state for the selected row
        isTimerVisible[row].toggle()
        
        // Reload the specific row to update the UI
        let indexPath = IndexPath(row: row, section: 0)
        tblVw.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc func btnOnFine(_ sender: UIButton) {
        // Identify the row of the button clicked
        let row = sender.tag
        
        // Reload the specific row to update the UI
        let indexPath = IndexPath(row: row, section: 0)
        
        self.vwIssuefine.isHidden = false
       
    }
}
