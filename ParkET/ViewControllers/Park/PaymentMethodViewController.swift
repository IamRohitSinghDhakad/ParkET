//
//  PaymentMethodViewController.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 14/02/25.
//

import UIKit

class PaymentMethodViewController: UIViewController,MakePaymentDelegate {
    
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
    var strBookingID = ""
    var hours = ""
    var carNumber = ""
    var arrEstimateModel = [EstimateModel]()
    var strIsCommingFrom = ""
    var objZoneModel : ZoneModel?
    var objVehicleModel : VehicleModel?
    var strDate = ""
    var strTime = ""
    var strTotalPayment = ""
    var strPenaltyAmount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblZoneName.text = self.strZone
        self.lblVehicle.text = self.carNumber
        self.lblBookingHours.text = "\(self.hours) Hours"
        self.lblPaymenFor.text = strIsCommingFrom
        self.call_WsGetPaymnetDetails()
        
        if strIsCommingFrom == "Direct"{
            self.call_WsBookParking()
        }
        
    }
    
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnOnPay(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakePaymentViewController") as! MakePaymentViewController
        vc.delegate = self  // Set delegate
        vc.strTotalPayment = self.strTotalPayment
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Delegate Method to Handle Payment Completion
    func paymentDidComplete(success: Bool) {
        if success {
            if self.strIsCommingFrom == "Extend"{
                self.call_WsExtendParking()
            }else if self.strIsCommingFrom == "Penalty"{
                self.call_WsPenaltyParking()
            }else{
                self.call_WsBookParking() // Call API only on success
            }
        }else{
            
        }
    }
}


extension PaymentMethodViewController{
    
    func call_WsGetPaymnetDetails() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        var params: [String: Any] = [String:Any]()
        
        if strIsCommingFrom == "Penalty"{
            params = [
                "zone_id": "",
                "hour":"",
                "amount":self.strPenaltyAmount
            ]
        }else{
            params = [
                "zone_id": self.strZoneID,
                "hour":self.hours,
                "amount":""
            ]
        }
        
        
        
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
                    self.strTotalPayment = obj.total_amount
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
            "time": self.hours.numericPrefix,
            "date": currentDateTime,
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
                    
                    if self.strIsCommingFrom == "Direct"{
                        self.setRootController()
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
                        vc.isComingfrom = "Payment"
                        vc.strBookingID = strBookingID
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
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
    
    func call_WsExtendParking() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        let currentDateTime = Date().formattedDateTime()
        let params: [String: Any] = [
            "booking_id": strBookingID,
            "time": self.hours.numericPrefix,
            "date": currentDateTime,
            "parking_fees": self.lblParkingFee.text!.removingDollarSymbol(),
            "transaction_fee": self.lblTransactionFee.text!.removingDollarSymbol(),
            "taxes_fee": self.lblTaxes.text!.removingDollarSymbol(),
            "total_amount": self.lblTotalAmount.text!.removingDollarSymbol(),
            "pay_method": "Strip"
        ]
        
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_ExtendBooking, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [String: Any] {
                    
                    self.setRootController()
                    
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
    
    func call_WsPenaltyParking() {
        if !objWebServiceManager.isNetworkAvailable() {
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "user_id": objAppShareData.UserDetail.strUser_id,
            "booking_id": strBookingID,
            "type": self.strIsCommingFrom,
            "amount": self.strPenaltyAmount,
            "transaction_fee": self.lblTransactionFee.text!.removingDollarSymbol(),
            "taxes_fee": self.lblTaxes.text!.removingDollarSymbol(),
            "total_amount": self.lblTotalAmount.text!.removingDollarSymbol(),
            "pay_method": "Strip"
        ]
        
        print(params)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_Add_Payment, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            print(response)
            
            if let status = response["status"] as? Int, status == MessageConstant.k_StatusCode {
                if let resultArray = response["result"] as? [String: Any] {
                    
                    self.setRootController()
                    
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
    
    
    func setRootController(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "TabBarUserViewController") as? TabBarUserViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
}

extension String {
    func removingDollarSymbol() -> String {
        return self.replacingOccurrences(of: "$", with: "")
    }
}

extension Date {
    func formattedDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Customize format as needed
        return dateFormatter.string(from: self)
    }
}

extension String {
    var numericPrefix: String {
        let pattern = "^[0-9]+"  // Match only leading numbers
        if let match = self.range(of: pattern, options: .regularExpression) {
            return String(self[match])
        }
        return ""
    }
}
