//
//  VehicleModel.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 27/01/25.
//

import UIKit

class VehicleModel: NSObject {
    
    var brand : String?
    var default_vehicle : String?
    var entrydt : String?
    var is_default : String?
    var model : String?
    var owner : String?
    var owner_email : String?
    var owner_mobile : String?
    var status : String?
    var user_id : String?
    var vehicle_no : String?
    var vehicle_id : String?
    
    
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["brand"] as? String {
            brand = value
        }
        
        if let value = dictionary["model"] as? String {
            model = value
        }
        
        if let value = dictionary["vehicle_id"] as? String {
            vehicle_id = value
        }else if let value = dictionary["vehicle_id"] as? Int {
            vehicle_id = "\(value)"
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        }else if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        }
        
        if let value = dictionary["owner_mobile"] as? String {
            owner_mobile = value
        }else if let value = dictionary["owner_mobile"] as? Int {
            owner_mobile = "\(value)"
        }
        
        if let value = dictionary["default_vehicle"] as? String {
            default_vehicle = value
        }else if let value = dictionary["default_vehicle"] as? Int {
            default_vehicle = "\(value)"
        }
        
        if let value = dictionary["is_default"] as? String {
            is_default = value
        }else if let value = dictionary["is_default"] as? Int {
            is_default = "\(value)"
        }
        
        if let value = dictionary["entrydt"] as? String {
            entrydt = value
        }
        
        if let value = dictionary["owner"] as? String {
            owner = value
        }
        
        if let value = dictionary["owner_email"] as? String {
            owner_email = value
        }
        
        if let value = dictionary["vehicle_no"] as? String {
            vehicle_no = value
        }
    }
}

/*
 brand = 1;
 "default_vehicle" = 2;
 entrydt = "2024-11-12 19:09:10";
 "is_default" = 0;
 model = 1;
 owner = "Arun Goswami";
 "owner_email" = "user@gmail.com";
 "owner_mobile" = 8871179252;
 status = 1;
 "user_id" = 49;
 "vehicle_id" = 1;
 "vehicle_no" = MP45SS870;
 */
