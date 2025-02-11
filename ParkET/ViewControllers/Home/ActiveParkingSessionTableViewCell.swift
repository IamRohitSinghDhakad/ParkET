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
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var vwCountDownTimer: UIView!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.vwCountDownTimer.isHidden = true
        self.lblShowTimer.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with bookingId: String, endTime: String) {
        CountdownTimerManager.shared.startTimer(for: bookingId, endTime: endTime)

        CountdownTimerManager.shared.onUpdate = { [weak self] updatedBookingId, timeString in
            guard let self = self, updatedBookingId == bookingId else { return }
            
            if timeString == "Time's Up" {
                self.vwCountDownTimer.isHidden = true
                self.lblShowTimer.isHidden = false
                self.lblShowTimer.text = "Time's Up"
            } else {
                self.vwCountDownTimer.isHidden = false
                self.lblTimer.text = timeString
                self.lblTimer.isHidden = false
                self.lblShowTimer.isHidden = true
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        lblTimer.text = ""
        lblShowTimer.text = ""
    }
    
//    func configure(with endTime: String, at indexPath: IndexPath) {
//          self.indexPath = indexPath
//          CountdownTimerManager.shared.startTimer(for: indexPath, endTime: endTime)
//          
//          CountdownTimerManager.shared.onUpdate = { [weak self] updatedIndexPath, timeString in
//              guard let self = self, updatedIndexPath == self.indexPath else { return }
//              if timeString == "Time's Up"{
//                  self.vwCountDownTimer.isHidden = true
//                  self.lblShowTimer.isHidden = false
//              }else{
//                  self.vwCountDownTimer.isHidden = false
//                  self.lblTimer.text = timeString
//                  self.lblTimer.isHidden = false
//                  self.lblShowTimer.isHidden = true
//              }
//              
//          }
//      }
//      
//      override func prepareForReuse() {
//          super.prepareForReuse()
//          if let indexPath = indexPath {
//              CountdownTimerManager.shared.stopTimer(for: indexPath)
//          }
//      }
    
    func toggleTimerVisibility() {
            vwTimer.isHidden.toggle()
        }
    
}
