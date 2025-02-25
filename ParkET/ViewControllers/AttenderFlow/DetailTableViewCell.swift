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
    @IBOutlet weak var vwCountDownTimer: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblShowTimer: UILabel!
    
    
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
