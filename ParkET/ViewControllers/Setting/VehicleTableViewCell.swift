//
//  VehicleTableViewCell.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 20/12/24.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVwCar: UIImageView!
    @IBOutlet weak var lblCarNumber: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblDefault: UILabel!
    @IBOutlet weak var veDefault: UIView!
    @IBOutlet weak var imgvwArrow: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgVwCar.setImageColor(color: .darkGray)
        self.imgvwArrow.setImageColor(color: .darkGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
