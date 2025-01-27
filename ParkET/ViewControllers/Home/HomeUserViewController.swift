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
    
    var strZoneId = ""
    var strStatus = "Booked"
    var strHasPenailty = ""
    var activeBookings: [BookingModel] = []
    var historyBookings: [BookingModel] = []
    var penaltyBookings: [BookingModel] = []
    
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
           self.call_WsGetBooking()
           self.vwNoRecord.isHidden = true
           
           self.tblVw.delegate = self
           self.tblVw.dataSource = self
           
           self.tblVw.register(UINib(nibName: "ActiveParkingSessionTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveParkingSessionTableViewCell")
           self.tblVw.register(UINib(nibName: "HistoryParkTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryParkTableViewCell")
           self.tblVw.register(UINib(nibName: "PenaltyParkTableViewCell", bundle: nil), forCellReuseIdentifier: "PenaltyParkTableViewCell")
       }
    
    @IBAction func btnOnTabSelection(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            currentTab = .active
            self.strStatus = "Booking"
            self.strHasPenailty = ""
        case 2:
            currentTab = .history
            self.strStatus = "Complete"
            self.strHasPenailty = ""
        case 3:
            currentTab = .penalty
            self.strStatus = ""
            self.strHasPenailty = "1"
        default:
            break
        }
        self.call_WsGetBooking()
        
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
            return activeBookings.count
        case .history:
            return historyBookings.count
        case .penalty:
            return penaltyBookings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTab {
        case .active:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveParkingSessionTableViewCell", for: indexPath) as? ActiveParkingSessionTableViewCell else {
                return UITableViewCell()
            }
           // cell.configure(for: activeBookings[indexPath.row])
            return cell
        case .history:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryParkTableViewCell", for: indexPath) as? HistoryParkTableViewCell else {
                return UITableViewCell()
            }
           // cell.configure(for: historyBookings[indexPath.row])
            return cell
        case .penalty:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PenaltyParkTableViewCell", for: indexPath) as? PenaltyParkTableViewCell else {
                return UITableViewCell()
            }
           // cell.configure(for: penaltyBookings[indexPath.row])
            return cell
        }
    }
}


extension HomeUserViewController {
    
    func call_WsGetBooking() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id,
            "zone_id": strZoneId,
            "status": strStatus,
            "has_penalty": strHasPenailty
        ]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_get_booking, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [[String: Any]] {
                    let bookings = resultArray.map { BookingModel(from: $0) }
                    
                    // Filter bookings for each tab
                    switch self.currentTab {
                    case .active:
                        self.activeBookings = bookings.filter { $0.status == "Booked" }
                    case .history:
                        self.historyBookings = bookings.filter { $0.status == "Complete" }
                    case .penalty:
                        self.penaltyBookings = bookings.filter { $0.hasPenalty ?? false } // Check if hasPenalty is true
                    }

                    
                    self.tblVw.reloadData()
                    self.vwNoRecord.isHidden = !bookings.isEmpty
                } else {
                    self.vwNoRecord.isHidden = false
                }
            } else {
                let message = response["message"] as? String ?? "Something went wrong!"
                objAlert.showAlert(message: message, title: "", controller: self)
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
}
