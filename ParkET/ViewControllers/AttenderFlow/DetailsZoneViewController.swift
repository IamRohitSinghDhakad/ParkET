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
    
    var objZone:ZoneModel?
    var arrZoneBookings = [BookingModel]()
    var selectedIndex = -1
    
    // Property to track visibility state of vwTimer for active tab
    //  var activeTabStates: [CellState] = []
    // Track which rows have the vwTimer visible
   // var isTimerVisible: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.vwIssuefine.isHidden = true
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        // Register the Nib
        let nib = UINib(nibName: "DetailTableViewCell", bundle: nil)
        tblVw.register(nib, forCellReuseIdentifier: "DetailTableViewCell")
        
        // Initialize visibility state for all rows (set to false initially)
       // isTimerVisible = Array(repeating: false, count: 5) // Match the number of rows in your table view
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        call_WsGetZoneBookings()
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
    @IBAction func btnHideView(_ sender: Any) {
        self.vwIssuefine.isHidden = true
    }
    
    @IBAction func btnOnissuefine(_ sender: Any) {
        self.vwIssuefine.isHidden = true
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "IssueFineViewController")as! IssueFineViewController
        vc.obj = self.arrZoneBookings[selectedIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnEnhanceFine(_ sender: Any) {
        self.vwIssuefine.isHidden = true
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "EnhancedFineViewController")as! EnhancedFineViewController
        vc.obj = self.arrZoneBookings[selectedIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailsZoneViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrZoneBookings.count // Number of rows in the table view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        
        let obj = self.arrZoneBookings[indexPath.row]
        
        cell.lblBookedBy.text = "Booked by\(obj.username ?? "")"
        cell.lblVehicleNumber.text = obj.vehicleNo ?? ""
        cell.lblBookedOn.text = "Booked on \(obj.startTime ?? "")"
        
        // Configure countdown timer with end time and index path
        if let endTime = obj.endTime {
            cell.configure(with: obj.endTime ?? "")
        }
        
        //cell.configure(with: obj.endTime ?? "", at: indexPath)
        
        cell.vwTimer.isHidden = !self.arrZoneBookings[indexPath.row].isTimerVisibleForAttender
        
        // Add target for the Show/Hide button
        cell.btnOnShowHide.tag = indexPath.row // Use the tag to identify the row
        cell.btnOnShowHide.addTarget(self, action: #selector(btnOnShowHideTimer(_:)), for: .touchUpInside)
        
        cell.btnOnFines.tag = indexPath.row // Use the tag to identify the row
        cell.btnOnFines.addTarget(self, action: #selector(btnOnFine(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnOnShowHideTimer(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tblVw)
        guard let indexPath = tblVw.indexPathForRow(at: point) else {
            print("Failed to find indexPath")
            return
        }
        // Toggle the visibility state for the selected row
        self.arrZoneBookings[indexPath.row].isTimerVisibleForAttender.toggle()
        self.tblVw.reloadRows(at: [indexPath], with: .automatic) // Reload the specific row
    }
    
    @objc func btnOnFine(_ sender: UIButton) {
        // Identify the row of the button clicked
        let point = sender.convert(CGPoint.zero, to: tblVw)
        guard let indexPath = tblVw.indexPathForRow(at: point) else {
            print("Failed to find indexPath")
            return
        }
        self.selectedIndex = indexPath.row
        self.vwIssuefine.isHidden = false
       
    }
}


extension DetailsZoneViewController{
    
    func call_WsGetZoneBookings() {
        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": "",
            "zone_id": self.objZone?.id ?? "",
            "status":"",
            "has_penalty":""
        ]
        
        let url = WsUrl.url_get_booking
        
        print("Sending OTP: \(params)")
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
    
            print(response)
            
            let status = response["status"] as? Int
            let message = response["message"] as? String
            
            if status == MessageConstant.k_StatusCode {
                if let arrZoneBookings = response["result"] as? [[String: Any]] {
                    self.arrZoneBookings.removeAll()
                    for data in arrZoneBookings{
                        let obj = BookingModel(from: data)
                        self.arrZoneBookings.append(obj)
                    }
                    
                    self.tblVw.reloadData()
                    
                } else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            } else {
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "Invalid OTP", title: "", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error: \(error)")
        }
    }
    
}
