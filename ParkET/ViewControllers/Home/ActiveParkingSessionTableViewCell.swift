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
    
    var timer: Timer?
        var endTime: Date?

        override func awakeFromNib() {
            super.awakeFromNib()
            self.vwCountDownTimer.isHidden = true
            self.lblShowTimer.isHidden = true
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }

        func configure(with endTime: String) {
            // Convert endTime string to Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust format as needed
            guard let endDate = dateFormatter.date(from: endTime) else { return }
            self.endTime = endDate

            // **Immediately update UI to prevent delay**
            updateTimerLabel()

            // Start the timer
            startTimer()
        }

        private func startTimer() {
            timer?.invalidate() // Stop any existing timer

            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.updateTimerLabel()
            }
        }

        private func updateTimerLabel() {
            guard let endTime = self.endTime else { return }

            let remainingTime = endTime.timeIntervalSinceNow
            if remainingTime <= 0 {
                self.lblTimer.text = "00:00"
                self.vwCountDownTimer.isHidden = true
                self.lblShowTimer.isHidden = false
                self.lblTimer.isHidden = true
                timer?.invalidate()
            } else {
                self.lblTimer.text = formatTime(remainingTime)
                self.vwCountDownTimer.isHidden = false
                self.lblTimer.isHidden = false
                self.lblShowTimer.isHidden = true
            }
        }

        private func formatTime(_ interval: TimeInterval) -> String {
            let hours = Int(interval) / 3600
            let minutes = (Int(interval) % 3600) / 60
            let seconds = Int(interval) % 60
            return String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            timer?.invalidate()
            lblTimer.text = nil
        }
}
    
