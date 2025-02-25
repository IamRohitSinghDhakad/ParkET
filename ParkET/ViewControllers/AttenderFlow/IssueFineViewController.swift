//
//  IssueFineViewController.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class IssueFineViewController: UIViewController {

    @IBOutlet weak var tfViolationNumber: UITextField!
    @IBOutlet weak var tfFineAmount: UITextField!
    @IBOutlet weak var txtVwNotes: RDTextView!
    @IBOutlet weak var tfDueDate: UITextField!
    
    var obj : BookingModel?
    let datePicker = UIDatePicker()

      override func viewDidLoad() {
          super.viewDidLoad()
          setupDatePicker()
          
          print(obj?.id)
      }
      
      func setupDatePicker() {
          // Configure DatePicker
          datePicker.datePickerMode = .date
          datePicker.preferredDatePickerStyle = .wheels // Old-style wheel picker
          datePicker.minimumDate = Date() // Restrict past dates

          // Assign DatePicker to TextField
          tfDueDate.inputView = datePicker
          
          // Add toolbar with Done button
          let toolbar = UIToolbar()
          toolbar.sizeToFit()
          
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
          let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          toolbar.setItems([space, doneButton], animated: false)
          
          tfDueDate.inputAccessoryView = toolbar
      }
      
      @objc func doneDatePicker() {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          tfDueDate.text = formatter.string(from: datePicker.date)
          tfDueDate.resignFirstResponder() // Dismiss picker
      }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
        
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        self.call_WsIssueFine()
    }
    
}

extension IssueFineViewController{
    
    func call_WsIssueFine() {
        if !objWebServiceManager.isNetworkAvailable() {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let params: [String: Any] = [
            "booking_id": obj?.id ?? "",
            "attender_id": objAppShareData.UserDetail.strUser_id,
            "fine_type":"Parking",
            "ticket_number":self.tfViolationNumber.text!,
            "fine_amount":self.tfFineAmount.text!,
            "description":self.txtVwNotes.text!,
            "due_date":self.tfDueDate.text!
        ]
        
        let url = WsUrl.url_AddFine
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: params, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
    
            print(response)
            
            let status = response["status"] as? Int
            let message = response["message"] as? String
            
            if status == MessageConstant.k_StatusCode {
                if let arrZoneBookings = response["result"] as? [String: Any] {
                   
                    
                    self.onBackPressed()
                    
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
