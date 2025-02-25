//
//  CountdownTimerManager.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 11/02/25.
//

import Foundation

struct TimeRemaining {
    let hours: Int
    let minutes: Int
    let seconds: Int
    var totalSeconds: Int {
        return hours * 3600 + minutes * 60 + seconds
    }
    
    func formattedCountdown() -> String {
        return totalSeconds > 0 ? String(format: "%02d:%02d:%02d", hours, minutes, seconds) : "Time's Up"
    }
}

class CountdownTimerManager {
    static let shared = CountdownTimerManager()

    private var timers: [IndexPath: Timer] = [:]
    private var endTimes: [IndexPath: Date] = [:]
    private var onUpdateHandlers: [IndexPath: (String) -> Void] = [:]

    func startTimer(for indexPath: IndexPath, endTime: String, onUpdate: @escaping (String) -> Void) {
        guard let targetDate = convertToDate(endTime) else { return }

        // Prevent duplicate timers
        if timers[indexPath] != nil {
            return
        }

        endTimes[indexPath] = targetDate
        onUpdateHandlers[indexPath] = onUpdate

        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let now = Date()
            if let targetDate = self.endTimes[indexPath] {
                let remainingTime = max(targetDate.timeIntervalSince(now), 0)
                let timeString = self.formatTime(remainingTime)

                DispatchQueue.main.async {
                    self.onUpdateHandlers[indexPath]?(timeString)
                }
            }
        }

        timers[indexPath] = timer
    }

    private func convertToDate(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: timeString)
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let seconds = Int(seconds) % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

