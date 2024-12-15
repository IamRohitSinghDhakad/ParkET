//
//  HomeUserViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 13/12/24.
//

import UIKit

class HomeUserViewController: UIViewController {
    
    @IBOutlet weak var vwNoRecord: UIView!
    @IBOutlet weak var tblVw: UITableView!
    
    // Enum to manage tab selection
    enum TabSelection {
        case active, history, penalty
    }
    
    // Property to store the current tab selection
    var currentTab: TabSelection = .active
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwNoRecord.isHidden = true
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        // Registering cells
        self.tblVw.register(UINib(nibName: "ActiveParkingSessionTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveParkingSessionTableViewCell")
        self.tblVw.register(UINib(nibName: "HistoryParkTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryParkTableViewCell")
        self.tblVw.register(UINib(nibName: "PenaltyParkTableViewCell", bundle: nil), forCellReuseIdentifier: "PenaltyParkTableViewCell")
        
    }
    
    
    
    @IBAction func btnOnTabSelection(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            print("Active")
            currentTab = .active
        case 2:
            print("History")
            currentTab = .history
        case 3:
            print("Penalty")
            currentTab = .penalty
        default:
            break
        }
        
        // Reload table view for the selected tab
        tblVw.reloadData()
        
    }
    
    @IBAction func btnOnParkNow(_ sender: Any) {
    }
    
}

extension HomeUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows based on the current tab
        switch currentTab {
        case .active:
            return 3 // Example count for active tab
        case .history:
            return 5 // Example count for history tab
        case .penalty:
            return 2 // Example count for penalty tab
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTab {
        case .active:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveParkingSessionTableViewCell", for: indexPath) as? ActiveParkingSessionTableViewCell else {
                return UITableViewCell()
            }
            // Configure the cell for Active tab
            cell.configure(for: indexPath.row)
            
            cell.btnOnShowHideTimer.tag = indexPath.row
            cell.btnOnShowHideTimer.addTarget(self, action: #selector(btnOnShowHideTimer(_:)), for: .touchUpInside)
            
            return cell
            
        case .history:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryParkTableViewCell", for: indexPath) as? HistoryParkTableViewCell else {
                return UITableViewCell()
            }
            // Configure the cell for History tab
            cell.configure(for: indexPath.row)
            return cell
            
        case .penalty:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PenaltyParkTableViewCell", for: indexPath) as? PenaltyParkTableViewCell else {
                return UITableViewCell()
            }
            // Configure the cell for Penalty tab
            cell.configure(for: indexPath.row)
            return cell
        }
    }
    
    @objc func btnOnShowHideTimer(_ sender: UIButton) {
        // Your code here
        // Find the cell containing the button
        let point = sender.convert(CGPoint.zero, to: tblVw)
        guard let indexPath = tblVw.indexPathForRow(at: point),
              let cell = tblVw.cellForRow(at: indexPath) as? ActiveParkingSessionTableViewCell else { return }
        
        // Toggle the visibility of vwTimer
        cell.toggleTimerVisibility()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection
        print("Selected row: \(indexPath.row) in \(currentTab) tab")
    }
}
