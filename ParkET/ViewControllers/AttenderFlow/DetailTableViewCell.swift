//
//  DetailTableViewCell.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 22/12/24.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imgvwUser: UIImageView!
    @IBOutlet weak var lblBookedBy: UILabel!
    @IBOutlet weak var lblVehicleNumber: UILabel!
    @IBOutlet weak var lblBookedOn: UILabel!
    @IBOutlet weak var imgVwDropDown: UIImageView!
    @IBOutlet weak var btnOnFines: UIButton!
    @IBOutlet weak var vwTimer: UIView!
    @IBOutlet weak var btnOnShowHide: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Method to configure the cell
       func configure(for row: Int) {
           // Configure the cell with data based on the row index
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
