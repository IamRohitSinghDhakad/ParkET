//
//  ActiveParkingSessionTableViewCell.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 13/12/24.
//

import UIKit

class ActiveParkingSessionTableViewCell: UITableViewCell {

    @IBOutlet weak var btnOnShowHideTimer: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnExtended: UIButton!
    @IBOutlet weak var lblShowTimer: UILabel!
    @IBOutlet weak var vwTimer: UIView!
    
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
    
    func toggleTimerVisibility() {
            vwTimer.isHidden.toggle()
        }
    
}
