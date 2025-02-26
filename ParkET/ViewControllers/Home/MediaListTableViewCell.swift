//
//  MediaListTableViewCell.swift
//  ParkET
//
//  Created by Rohit SIngh Dhakad on 26/02/25.
//

import UIKit

class MediaListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var btnVw: UIButton!
    @IBOutlet weak var lblFinType: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblFineAmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
