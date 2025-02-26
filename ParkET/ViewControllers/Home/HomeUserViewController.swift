//
//  HomeUserViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 13/12/24.
//

import UIKit
import iOSDropDown
import SDWebImage

struct CellState {
    var isTimerVisible: Bool
}

class HomeUserViewController: UIViewController {
    
    @IBOutlet weak var vwNoRecord: UIView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet var subVw: UIView!
    @IBOutlet weak var lblheadingSubVwExtend: UILabel!
    @IBOutlet weak var tfSelectHours: DropDown!
    @IBOutlet var subVwStop: UIView!
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnPenalty: UIButton!
    @IBOutlet var subVwEvidance: UIView!
    @IBOutlet weak var tblVwMedia: UITableView!
    
    var strZoneId = ""
    var strStatus = "Booked"
    var strHasPenailty = "0"
    var activeBookings: [BookingModel] = []
    var historyBookings: [BookingModel] = []
    var penaltyBookings: [BookingModel] = []
    var penaltyBookingsEvidance: [PenaltyModel] = []
    var strSelectedIndex = -1
    var strSelectedIndexForEvidanceList = -1
    
    // Enum to manage tab selection
    enum TabSelection {
        case active, history, penalty, penaltyEvidance
    }
    
    // Property to store the current tab selection
    var currentTab: TabSelection = .active
    
    // Property to track visibility state of vwTimer for active tab
    var activeTabStates: [BookingModel] = []
    var historyTabStates: [CellState] = []
    var penaltyTabStates: [CellState] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.call_WsGetBooking()
        self.vwNoRecord.isHidden = true
        self.subVw.isHidden = false
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.tblVwMedia.delegate = self
        self.tblVwMedia.dataSource = self
        
        self.tblVw.register(UINib(nibName: "ActiveParkingSessionTableViewCell", bundle: nil), forCellReuseIdentifier: "ActiveParkingSessionTableViewCell")
        self.tblVw.register(UINib(nibName: "HistoryParkTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryParkTableViewCell")
        self.tblVw.register(UINib(nibName: "PenaltyParkTableViewCell", bundle: nil), forCellReuseIdentifier: "PenaltyParkTableViewCell")
        
        self.tfSelectHours.delegate = self
        self.tfSelectHours.optionArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        self.tfSelectHours.didSelect { selectedText, index, id in
            self.tfSelectHours.text = selectedText
        }
    }
    @IBAction func btnYesStop(_ sender: Any) {
        self.call_WsStopBooking(strBookingID: self.activeBookings[strSelectedIndex].id)
    }
    
    @IBAction func btnOnParkNow(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    @IBAction func btnCloseSubVwEvidance(_ sender: Any) {
        
        self.addSubviewEvidance(isAdd: false)
    }
    
    
    @IBAction func btnOnTabSelection(_ sender: UIButton) {
        
        resetTabButtonStyles()
        
        // Highlight the selected button
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = UIColor(named: "AppColor")
        
        switch sender.tag {
        case 1:
            currentTab = .active
            self.strStatus = "Booked"
            self.strHasPenailty = "0"
        case 2:
            currentTab = .history
            self.strStatus = "Complete"
            self.strHasPenailty = ""
        case 3:
            currentTab = .penalty
            self.strStatus = ""
            self.strHasPenailty = "1"
        default:
            currentTab = .penaltyEvidance
        }
        self.call_WsGetBooking()
        
    }
    
    func resetTabButtonStyles() {
        let tabButtons = [btnActive, btnHistory, btnPenalty]  // Replace with actual button outlets
        for button in tabButtons {
            button?.setTitleColor(.black, for: .normal)
            button?.backgroundColor = UIColor(named: "AppColor")
        }
    }
    
    
    @IBAction func btnContinueExtend(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController")as! PaymentMethodViewController
        vc.strZone = self.activeBookings[strSelectedIndex].zone ?? ""
        vc.carNumber = self.activeBookings[strSelectedIndex].vehicleNo ?? ""
        vc.strZoneID = "\(self.activeBookings[strSelectedIndex].zoneId)"
        vc.hours = self.tfSelectHours.text!
        vc.strBookingID = self.activeBookings[strSelectedIndex].id
        vc.strIsCommingFrom = "Extend"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnCloseSubVwExtend(_ sender: Any) {
        self.addSubview(isAdd: false)
        self.addSubviewStop(isAdd: false)
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
            self.activeBookings[indexPath.row].isTimerVisible.toggle()
        case .history:
            historyTabStates[indexPath.row].isTimerVisible.toggle()
        case .penalty:
            penaltyTabStates[indexPath.row].isTimerVisible.toggle()
        case .penaltyEvidance:
            print("penaltyEvidance")
        }
        
        tblVw.reloadRows(at: [indexPath], with: .automatic) // Reload the specific row
    }
    
    @objc func btnOnExtend(_ sender: UIButton) {
        // Find the cell's index path
        let point = sender.convert(CGPoint.zero, to: tblVw)
        guard let indexPath = tblVw.indexPathForRow(at: point) else {
            print("Failed to find indexPath")
            return
        }
        self.strSelectedIndex = indexPath.row
        self.addSubview(isAdd: true)
        
        
    }
    
    @objc func btnOnStop(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tblVw)
        guard let indexPath = tblVw.indexPathForRow(at: point) else {
            print("Failed to find indexPath")
            return
        }
        self.strSelectedIndex = indexPath.row
        self.addSubviewStop(isAdd: true)
        
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
        case .penaltyEvidance:
            return self.penaltyBookings[strSelectedIndexForEvidanceList].penalties.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTab {
        case .active:
            guard let cell = self.tblVw.dequeueReusableCell(withIdentifier: "ActiveParkingSessionTableViewCell", for: indexPath) as? ActiveParkingSessionTableViewCell else {
                return UITableViewCell()
            }
            let obj = self.activeBookings[indexPath.row]
            cell.lblZoneNumber.text = obj.zone
            cell.lblAddrrss.text = obj.zoneAddress
            
            // Configure countdown timer with end time and index path
            if let endTime = obj.endTime {
                cell.configure(with: obj.endTime ?? "")
            }
            
            //cell.configure(with: obj.endTime ?? "", at: indexPath)
            
            cell.vwTimer.isHidden = !self.activeBookings[indexPath.row].isTimerVisible
            cell.btnOnShowHideTimer.addTarget(self, action: #selector(btnOnShowHideTimer(_:)), for: .touchUpInside)
            cell.btnExtended.tag = indexPath.row
            cell.btnExtended.addTarget(self, action: #selector(btnOnExtend(_:)), for: .touchUpInside)
            cell.btnStop.tag = indexPath.row
            cell.btnStop.addTarget(self, action: #selector(btnOnStop(_:)), for: .touchUpInside)
            
            // cell.configure(for: activeBookings[indexPath.row])
            return cell
        case .history:
            guard let cell = self.tblVw.dequeueReusableCell(withIdentifier: "HistoryParkTableViewCell", for: indexPath) as? HistoryParkTableViewCell else {
                return UITableViewCell()
            }
            
            let obj = self.historyBookings[indexPath.row]
            cell.lblZoneNumber.text = obj.zone
            cell.lblAddress.text = obj.zoneAddress
            cell.lblBooKedOn.text = obj.entryDate
            cell.lblTotalPaidAmount.text = "$\(obj.totalPaidAmount ?? "0.0") USD"
            
            return cell
        case .penalty:
            guard let cell = self.tblVw.dequeueReusableCell(withIdentifier: "PenaltyParkTableViewCell", for: indexPath) as? PenaltyParkTableViewCell else {
                return UITableViewCell()
            }
            
            let obj = self.penaltyBookings[indexPath.row]
            
            if obj.totalPenaltyPaidAmount == "0"{
                cell.lblPendingAmountDesc.text = "Pending Penalty Amount of $\(obj.pendingPenaltyAmount ?? "0.0") USD for this booking in \(obj.remainingDays ?? 0) days"
                cell.lblPendingAmountDesc.textColor = .red
                cell.vwPayAmountButton.isHidden = false
            }else{
                cell.lblPendingAmountDesc.text = "Paid Penalty Amount of $\(obj.totalPenaltyPaidAmount ?? "0.0") USD for this booking"
                cell.lblPendingAmountDesc.textColor = .orange
                cell.vwPayAmountButton.isHidden = true
            }
            
            
            cell.lblZoneNumber.text = obj.zone
            cell.lblZoneAddress.text = obj.zoneAddress
            cell.lblBookedOn.text = obj.entryDate
            cell.lblTotalPaidAmount.text = "$\(obj.totalPaidAmount ?? "0.0") USD"
            cell.btnPayNow.setTitle("$\(obj.pendingPenaltyAmount ?? "0.0")", for: .normal)
            
            cell.btnPayNow.tag = indexPath.row
            cell.btnPayNow.addTarget(self, action: #selector(btnOnPayNow(_:)), for: .touchUpInside)
            
            cell.btnOnShowEvidance.tag = indexPath.row
            cell.btnOnShowEvidance.addTarget(self, action: #selector(btnOnShowEvidance(_:)), for: .touchUpInside)
            
            
            return cell
        case .penaltyEvidance:
            guard let cell = self.tblVwMedia.dequeueReusableCell(withIdentifier: "MediaListTableViewCell", for: indexPath) as? MediaListTableViewCell else {
                return UITableViewCell()
            }
            
            let obj = self.penaltyBookings[strSelectedIndexForEvidanceList].penalties[indexPath.row]
            
            let imageUrl  = BASE_URL_Image + (obj.image ?? "")
            if imageUrl != "" {
                let url = URL(string: imageUrl)
                cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }else{
                cell.imgVw.image = #imageLiteral(resourceName: "logo")
            }
            
            if obj.fineType == "Parking"{
                cell.btnVw.isHidden = true
            }else{
                cell.btnVw.isHidden = false
            }
            
            cell.lblFinType.text = "Fine type is \(obj.fineType ?? "")"
            cell.lblDueDate.text = "Due Date is \(obj.dueDate ?? "")"
            cell.lblFineAmount.text = "Fine amount is $\(obj.fineAmount)"
            
            cell.btnVw.tag = indexPath.row
            cell.btnVw.addTarget(self, action: #selector(btnOnShowEvidanceOnFullScreen(_:)), for: .touchUpInside)
            
            
            return cell
        }
    }
    
    @objc func btnOnShowEvidanceOnFullScreen(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tblVwMedia)
        guard let indexPath = tblVwMedia.indexPathForRow(at: point) else {
            print("Failed to find indexPath")
            return
        }
        let obj = self.penaltyBookings[strSelectedIndexForEvidanceList].penalties[indexPath.row]
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "ViewEvidanceViewController")as! ViewEvidanceViewController
        vc.objImageUrl = BASE_URL_Image + (obj.image ?? "")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
   
    @objc func btnOnShowEvidance(_ sender: UIButton) {
        currentTab = .penaltyEvidance
        let point = sender.convert(CGPoint.zero, to: tblVw)
        guard let indexPath = tblVw.indexPathForRow(at: point) else {
            print("Failed to find indexPath")
            return
        }
        self.strSelectedIndexForEvidanceList = indexPath.row
        self.tblVwMedia.reloadData()
        self.addSubviewEvidance(isAdd: true)
    }
    
    @objc func btnOnPayNow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tblVw)
        guard let indexPath = tblVw.indexPathForRow(at: point) else {
            print("Failed to find indexPath")
            return
        }
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController")as! PaymentMethodViewController
        vc.strPenaltyAmount =  self.penaltyBookings[indexPath.row].pendingPenaltyAmount ?? ""
        vc.strIsCommingFrom = "Penalty"
        vc.strZone = self.penaltyBookings[indexPath.row].zone ?? ""
        vc.carNumber = self.penaltyBookings[indexPath.row].vehicleNo ?? ""
        vc.strZoneID = "\(self.penaltyBookings[indexPath.row].zoneId)"
        vc.strBookingID = self.penaltyBookings[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_get_booking, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                
                if let resultArray = response["result"] as? [[String: Any]] {
                    
                    let bookings = resultArray.map { BookingModel(from: $0) }
                    
                    self.activeBookings.removeAll()
                    self.historyBookings.removeAll()
                    self.penaltyBookings.removeAll()
                    
                    // Filter bookings for each tab
                    switch self.currentTab {
                    case .active:
                        self.activeBookings = bookings.filter { $0.status == "Booked" }
                    case .history:
                        self.historyBookings = bookings.filter { $0.status == "Complete" }
                        
                    case .penalty:
                        print(bookings.filter { $0.hasPenalty ?? false })
                        self.penaltyBookings = bookings.filter { $0.hasPenalty ?? false } // Check if hasPenalty is true
                    case .penaltyEvidance:
                        print("Do Nothing")
                       // self.penaltyBookingsEvidance = bookings.flatMap { $0.penalties } // Check if hasPenalty is true
                    }
                    
                    self.tblVw.reloadData()
                    self.vwNoRecord.isHidden = !bookings.isEmpty
                } else {
                    self.vwNoRecord.isHidden = false
                }
            } else {
                self.activeBookings.removeAll()
                self.historyBookings.removeAll()
                self.penaltyBookings.removeAll()
                self.tblVw.reloadData()
                self.vwNoRecord.isHidden = false
                //  objAlert.showAlert(message: message, title: "", controller: self)
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
    
    
    func call_WsStopBooking(strBookingID:String) {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "booking_id": strBookingID,
            "status": "Complete"
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_ChnageBookingStatus, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [String: Any] {
                    self.addSubviewStop(isAdd: false)
                    self.call_WsGetBooking()
                    
                } else {
                    
                }
            } else {
               
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
    
    
    func addSubview(isAdd: Bool) {
        if isAdd {
            self.subVw.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(subVw)
            
            UIView.animate(withDuration: 0.5) {
                self.subVw.frame.origin.y = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.subVw.frame.origin.y = self.view.frame.height
            } completion: { y in
                self.subVw.removeFromSuperview()
            }
        }
    }
    
    func addSubviewStop(isAdd: Bool) {
        if isAdd {
            self.subVwStop.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(subVwStop)
            
            UIView.animate(withDuration: 0.5) {
                self.subVwStop.frame.origin.y = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.subVwStop.frame.origin.y = self.view.frame.height
            } completion: { y in
                self.subVwStop.removeFromSuperview()
            }
        }
    }
    
    
    func addSubviewEvidance(isAdd: Bool) {
        if isAdd {
            self.subVwEvidance.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(subVwEvidance)
            
            UIView.animate(withDuration: 0.5) {
                self.subVwEvidance.frame.origin.y = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.subVwEvidance.frame.origin.y = self.view.frame.height
            } completion: { y in
                self.subVwEvidance.removeFromSuperview()
            }
        }
    }
}
