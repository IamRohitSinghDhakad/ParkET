//
//  EstimateModel.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 14/02/25.
//

import UIKit

class EstimateModel: NSObject {
    
    var chargeable_hours: String = ""
    var current_time: String = ""
    var end_time: String = ""
    var free_time_from: String = ""
    var free_time_to: String = ""
    var freeable_hours: String = ""
    var parking_fees: String = ""
    var taxes_fee: String = ""
    var total_amount: String = ""
    var transaction_fee: String = ""
    var zone_id: String = ""
    var zone_name: String = ""
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["chargeable_hours"] as? String {
            chargeable_hours = value
        } else if let value = dictionary["chargeable_hours"] as? Int {
            chargeable_hours = "\(value)"
        }
        
        if let value = dictionary["current_time"] as? String {
            current_time = value
        } else if let value = dictionary["current_time"] as? Int {
            current_time = "\(value)"
        }
        
        if let value = dictionary["end_time"] as? String {
            end_time = value
        } else if let value = dictionary["end_time"] as? Int {
            end_time = "\(value)"
        }
        
        if let value = dictionary["free_time_from"] as? String {
            free_time_from = value
        } else if let value = dictionary["free_time_from"] as? Int {
            free_time_from = "\(value)"
        }
        
        if let value = dictionary["free_time_to"] as? String {
            free_time_to = value
        } else if let value = dictionary["free_time_to"] as? Int {
            free_time_to = "\(value)"
        }
        
        if let value = dictionary["freeable_hours"] as? String {
            freeable_hours = value
        } else if let value = dictionary["freeable_hours"] as? Int {
            freeable_hours = "\(value)"
        }
        
        if let value = dictionary["parking_fees"] as? String {
            parking_fees = value
        } else if let value = dictionary["parking_fees"] as? Int {
            parking_fees = "\(value)"
        }
        
        if let value = dictionary["taxes_fee"] as? String {
            taxes_fee = value
        } else if let value = dictionary["taxes_fee"] as? Int {
            taxes_fee = "\(value)"
        }
        
        if let value = dictionary["total_amount"] as? String {
            total_amount = value
        } else if let value = dictionary["total_amount"] as? Int {
            total_amount = "\(value)"
        }
        
        if let value = dictionary["transaction_fee"] as? String {
            transaction_fee = value
        } else if let value = dictionary["transaction_fee"] as? Int {
            transaction_fee = "\(value)"
        }
        
        if let value = dictionary["zone_id"] as? String {
            zone_id = value
        } else if let value = dictionary["zone_id"] as? Int {
            zone_id = "\(value)"
        }
        
        if let value = dictionary["zone_name"] as? String {
            zone_name = value
        } else if let value = dictionary["zone_name"] as? Int {
            zone_name = "\(value)"
        }
    }
}
