//
//  PaymentMethodViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 14/02/25.
//

import UIKit

class PaymentMethodViewController: UIViewController {

    @IBOutlet weak var lblZoneName: UILabel!
    @IBOutlet weak var lblVehicle: UILabel!
    @IBOutlet weak var lblBookingHours: UILabel!
    @IBOutlet weak var lblPaymenFor: UILabel!
    @IBOutlet weak var lblParkingFee: UILabel!
    @IBOutlet weak var lblTransactionFee: UILabel!
    @IBOutlet weak var lblTaxes: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    
    var strZone = ""
    var strZoneID = ""
    var hours = ""
    var carNumber = ""
    var arrEstimateModel = [EstimateModel]()
    var strIsCommingFrom = ""
    var objZoneModel : ZoneModel?
    var objVehicleModel : VehicleModel?
    var strDate = ""
    var strTime = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(self.objZoneModel?.name ?? "")
        print(self.objZoneModel?.id ?? "")
        print(self.objVehicleModel?.vehicle_no ?? "")
        print(self.objVehicleModel?.vehicle_id ?? "")
        
        self.lblZoneName.text = self.strZone
        self.lblVehicle.text = self.carNumber
        self.lblBookingHours.text = "\(self.hours) Hours"
        self.lblPaymenFor.text = strIsCommingFrom
        self.call_WsGetPaymnetDetails()
    }
    

    @IBAction func btnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnOnPay(_ sender: Any) {
        self.call_WsBookParking()
    }
    
}


extension PaymentMethodViewController{
    
    func call_WsGetPaymnetDetails() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "zone_id": self.strZoneID,
            "hour":self.hours,
            "amount":""
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetEstimate, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [String: Any] {
                        let obj = EstimateModel(from: resultArray)
                    
                    self.lblParkingFee.text = "$\(obj.parking_fees)"
                    self.lblTransactionFee.text = "$\(obj.transaction_fee)"
                    self.lblTaxes.text = "$\(obj.taxes_fee)"
                    self.lblTotalAmount.text = "$\(obj.total_amount)"
                    self.strDate = obj.current_time
        
                } else {
                  
                }
            } else {
               
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
    
    
    func call_WsBookParking() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        let currentDateTime = Date().formattedDateTime()
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id,
            "zone_id": self.objZoneModel?.id ?? "",
            "vehicle_id": self.objVehicleModel?.vehicle_id ?? "",
            "time": currentDateTime.time,
            "date": currentDateTime.date,
            "parking_fees": self.lblParkingFee.text!.removingDollarSymbol(),
            "transaction_fee": self.lblTransactionFee.text!.removingDollarSymbol(),
            "taxes_fee": self.lblTaxes.text!.removingDollarSymbol(),
            "total_amount": self.lblTotalAmount.text!.removingDollarSymbol(),
            "pay_method": "Strip"
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_BookParking, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [String: Any] {
                    
                    var strBookingID = ""
                    
                    if let bookingID = resultArray["id"]as? String{
                        strBookingID = bookingID
                    }else if let bookingID = resultArray["id"]as? Int{
                        strBookingID = "\(bookingID)"
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
                    vc.isComingfrom = "Payment"
                    vc.strBookingID = strBookingID
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                } else {
                    
                }
            } else {
                // let message = response["message"] as? String ?? "Something went wrong!"
                //objAlert.showAlert(message: message, title: "", controller: self)
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Request failed. Please try again.", title: "", controller: self)
        }
    }
}

extension String {
    func removingDollarSymbol() -> String {
        return self.replacingOccurrences(of: "$", with: "")
    }
}

extension Date {
    func formattedDateTime() -> (date: String, time: String) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd" // Customize as needed
        let date = dateFormatter.string(from: self)
        
        dateFormatter.dateFormat = "HH:mm:ss" // Customize as needed
        let time = dateFormatter.string(from: self)
        
        return (date, time)
    }
}
