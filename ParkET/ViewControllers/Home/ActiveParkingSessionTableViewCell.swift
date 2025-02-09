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
    @IBOutlet weak var lblAddrrss: UILabel!
    @IBOutlet weak var lblZoneNumber: UILabel!
    
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
          
       }
    
    func toggleTimerVisibility() {
            vwTimer.isHidden.toggle()
        }
    
}
