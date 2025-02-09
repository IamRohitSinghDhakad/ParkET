//
//  BookingModel.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 26/01/25.
//

import UIKit

class BookingModel: NSObject {
    
    var endTime: String?
    var entryDate: String?
    var status: String?
    var hasPenalty: Bool?
    var hourly: Int = 0
    var id: Int = 0
    var mobile: String?
    var payments: [PaymentModel] = []
    var penalties: [PenaltyModel] = []
    var pendingPenaltyAmount: String?
    var remainingDays: Int?
    var startTime: String?
  // var status: String?
    var totalPaidAmount: String?
    var totalPenaltyPaidAmount: Double = 0.0
    var userId: Int = 0
    var username: String?
    var vehicleId: Int = 0
    var vehicleNo: String?
    var zone: String?
    var zoneAddress: String?
    var zoneId: Int = 0
    var isTimerVisible = false
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        endTime = dictionary["end_time"] as? String
        entryDate = dictionary["entrydt"] as? String
       // hasPenalty = (dictionary["has_penalty"] as? Int ?? 0) == 1
        hourly = dictionary["hourly"] as? Int ?? 0
        id = dictionary["id"] as? Int ?? 0
        mobile = "\(dictionary["mobile"] ?? "")"
        if let paymentsArray = dictionary["payments"] as? [[String: Any]] {
            payments = paymentsArray.map { PaymentModel(from: $0) }
        }
        if let penaltiesArray = dictionary["penalties"] as? [[String: Any]] {
            penalties = penaltiesArray.map { PenaltyModel(from: $0) }
        }
       // pendingPenaltyAmount = Double(dictionary["pending_penalty_amount"] as? String ?? "0") ?? 0.0
        remainingDays = dictionary["remaining_days"] as? Int
        startTime = dictionary["start_time"] as? String
        status = dictionary["status"] as? String ?? ""
        hasPenalty = (dictionary["has_penalty"] as? String ?? "0") == "1"
        //totalPaidAmount = dictionary["total_paid_amount"] as! String
        
        if let total_PaidAmount = dictionary["total_paid_amount"]as? String{
            self.totalPaidAmount = total_PaidAmount
        }else if let total_PaidAmount = dictionary["total_paid_amount"]as? Int{
            self.totalPaidAmount = "\(total_PaidAmount)"
        }else if let total_PaidAmount = dictionary["total_paid_amount"] as? Double {
            self.totalPaidAmount = String(format: "%.2f", total_PaidAmount)
        }
        
        if let paid_penalty_Amount = dictionary["pending_penalty_amount"]as? String{
            self.pendingPenaltyAmount = paid_penalty_Amount
        }else if let paid_penalty_Amount = dictionary["pending_penalty_amount"]as? Int{
            self.pendingPenaltyAmount = "\(paid_penalty_Amount)"
        }else if let paid_penalty_Amount = dictionary["pending_penalty_amount"] as? Double {
            self.pendingPenaltyAmount = String(format: "%.2f", paid_penalty_Amount)
        }
        
        totalPenaltyPaidAmount = Double(dictionary["total_penalty_paid_amount"] as? String ?? "0") ?? 0.0
        
        userId = dictionary["user_id"] as? Int ?? 0
        username = dictionary["username"] as? String
        vehicleId = dictionary["vehicle_id"] as? Int ?? 0
        vehicleNo = dictionary["vehicle_no"] as? String
        zone = dictionary["zone"] as? String
        zoneAddress = dictionary["zone_address"] as? String
        zoneId = dictionary["zone_id"] as? Int ?? 0
    }
}

class PaymentModel: NSObject {
    
    var parkingFees: Double = 0.0
    var payMethod: String?
    var paymentId: Int = 0
    var taxesFee: Double = 0.0
    var totalAmount: Double = 0.0
    var transactionFee: Double = 0.0
    var type: String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        parkingFees = Double(dictionary["parking_fees"] as? String ?? "0") ?? 0.0
        payMethod = dictionary["pay_method"] as? String
        paymentId = dictionary["payment_id"] as? Int ?? 0
        taxesFee = Double(dictionary["taxes_fee"] as? String ?? "0") ?? 0.0
        totalAmount = Double(dictionary["total_amount"] as? String ?? "0") ?? 0.0
        transactionFee = Double(dictionary["transaction_fee"] as? String ?? "0") ?? 0.0
        type = dictionary["type"] as? String
    }
}

class PenaltyModel: NSObject {
    
    var attenderId: Int = 0
    var bookingId: Int = 0
    var descriptionText: String?
    var dueDate: String?
    var entryDate: String?
    var fineAmount: Double = 0.0
    var fineType: String?
    var id: Int = 0
    var image: String?
    var paymentId: Int = 0
    var status: Int = 0
    var ticketNumber: String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        attenderId = dictionary["attender_id"] as? Int ?? 0
        bookingId = dictionary["booking_id"] as? Int ?? 0
        descriptionText = dictionary["description"] as? String
        dueDate = dictionary["due_date"] as? String
        entryDate = dictionary["entrydt"] as? String
        fineAmount = Double(dictionary["fine_amount"] as? String ?? "0") ?? 0.0
        fineType = dictionary["fine_type"] as? String
        id = dictionary["id"] as? Int ?? 0
        image = dictionary["image"] as? String
        paymentId = dictionary["payment_id"] as? Int ?? 0
        status = dictionary["status"] as? Int ?? 0
        ticketNumber = dictionary["ticket_number"] as? String
    }
}

