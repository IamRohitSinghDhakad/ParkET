//
//  PenaltyParkTableViewCell.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 14/12/24.
//

import UIKit

class PenaltyParkTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPendingAmountDesc: UILabel!
    @IBOutlet weak var lblZoneNumber: UILabel!
    @IBOutlet weak var lblBookedOn: UILabel!
    @IBOutlet weak var lblZoneAddress: UILabel!
    @IBOutlet weak var lblTotalPaidAmount: UILabel!
    @IBOutlet weak var vwPayAmountButton: UIView!
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var btnOnShowEvidance: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Method to configure the cell
       func configure(for row: Int) {
           // Configure the cell with data based on the row index
       }
    
}
