//
//  HomeUserViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 13/12/24.
//

import UIKit

struct CellState {
    var isTimerVisible: Bool
}

class HomeUserViewController: UIViewController {
    
    @IBOutlet weak var vwNoRecord: UIView!
    @IBOutlet weak var tblVw: UITableView!
    
    // Enum to manage tab selection
    enum TabSelection {
        case active, history, penalty
    }
    
    // Property to store the current tab selection
    var currentTab: TabSelection = .active
    
    // Property to track visibility state of vwTimer for active tab
    var activeTabStates: [CellState] = []
    var historyTabStates: [CellState] = []
    var penaltyTabStates: [CellState] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwNoRecord.isHidden = true
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        // Registering cells
        self.tblVw.register(UINib(nibName: "ActiveParkingSessionTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveParkingSessionTableViewCell")
        self.tblVw.register(UINib(nibName: "HistoryParkTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryParkTableViewCell")
        self.tblVw.register(UINib(nibName: "PenaltyParkTableViewCell", bundle: nil), forCellReuseIdentifier: "PenaltyParkTableViewCell")
        
        // Initialize state arrays with default values
        activeTabStates = Array(repeating: CellState(isTimerVisible: false), count: 3) // Example: 3 rows
        historyTabStates = Array(repeating: CellState(isTimerVisible: false), count: 5) // Example: 5 rows
        penaltyTabStates = Array(repeating: CellState(isTimerVisible: false), count: 2) // Example: 2 rows
    }
    
    @IBAction func btnOnTabSelection(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            currentTab = .active
        case 2:
            currentTab = .history
        case 3:
            currentTab = .penalty
        default:
            break
        }
        tblVw.reloadData()
    }
    
    @objc func btnOnShowHideTimer(_ sender: UIButton) {
        // Find the cell's index path
        let point = sender.convert(CGPoint.zero, to: tblVw)
        guard let indexPath = tblVw.indexPathForRow(at: point) else {
            print("Failed to find indexPath")
            return
        }
        
        // Update the state based on the current tab
        switch currentTab {
        case .active:
            activeTabStates[indexPath.row].isTimerVisible.toggle()
        case .history:
            historyTabStates[indexPath.row].isTimerVisible.toggle()
        case .penalty:
            penaltyTabStates[indexPath.row].isTimerVisible.toggle()
        }
        
        tblVw.reloadRows(at: [indexPath], with: .automatic) // Reload the specific row
    }
}

extension HomeUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentTab {
        case .active:
            return activeTabStates.count
        case .history:
            return historyTabStates.count
        case .penalty:
            return penaltyTabStates.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTab {
        case .active:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveParkingSessionTableViewCell", for: indexPath) as? ActiveParkingSessionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(for: indexPath.row)
            cell.vwTimer.isHidden = !activeTabStates[indexPath.row].isTimerVisible
            cell.btnOnShowHideTimer.addTarget(self, action: #selector(btnOnShowHideTimer(_:)), for: .touchUpInside)
            return cell
        case .history:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryParkTableViewCell", for: indexPath) as? HistoryParkTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(for: indexPath.row)
            return cell
        case .penalty:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PenaltyParkTableViewCell", for: indexPath) as? PenaltyParkTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(for: indexPath.row)
            return cell
        }
    }
}
