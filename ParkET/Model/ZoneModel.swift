//
//  ZoneModel.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 11/02/25.
//

import UIKit

class ZoneModel: NSObject {
    var id: String?
    var createdBy: String?
    var name: String?
    var address: String?
    var lat: String?
    var lng: String?
    var attenderId: String?
    var fromTime: String?
    var toTime: String?
    var freeDates: String?
    var hourlyRate: String?
    var createdAt: String?
    var updatedAt: String?
    var status: String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["id"] as? String {
            id = value
        } else if let value = dictionary["id"] as? Int {
            id = "\(value)"
        }
        
        if let value = dictionary["created_by"] as? String {
            createdBy = value
        } else if let value = dictionary["created_by"] as? Int {
            createdBy = "\(value)"
        }
        
        if let value = dictionary["name"] as? String {
            name = value
        }
        
        if let value = dictionary["address"] as? String {
            address = value
        }
        
        if let value = dictionary["lat"] as? String {
            lat = value
        } else if let value = dictionary["lat"] as? Double {
            lat = "\(value)"
        }
        
        if let value = dictionary["lng"] as? String {
            lng = value
        } else if let value = dictionary["lng"] as? Double {
            lng = "\(value)"
        }
        
        if let value = dictionary["attender_id"] as? String {
            attenderId = value
        } else if let value = dictionary["attender_id"] as? Int {
            attenderId = "\(value)"
        }
        
        if let value = dictionary["from_time"] as? String {
            fromTime = value
        }
        
        if let value = dictionary["to_time"] as? String {
            toTime = value
        }
        
        if let value = dictionary["freeDates"] as? String {
            freeDates = value
        }
        
        if let value = dictionary["hourly_rate"] as? String {
            hourlyRate = value
        } else if let value = dictionary["hourly_rate"] as? Int {
            hourlyRate = "\(value)"
        }
        
        if let value = dictionary["created_at"] as? String {
            createdAt = value
        }
        
        if let value = dictionary["updated_at"] as? String {
            updatedAt = value
        }
        
        if let value = dictionary["status"] as? String {
            status = value
        } else if let value = dictionary["status"] as? Int {
            status = "\(value)"
        }
    }
}
