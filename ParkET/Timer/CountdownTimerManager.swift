//
//  CountdownTimerManager.swift
//  ParkET
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 11/02/25.
//

import Foundation

//struct TimeRemaining {
//    let hours: Int
//    let minutes: Int
//    let seconds: Int
//    var totalSeconds: Int {
//        return hours  3600 + minutes  60 + seconds
//    }
//    
//    func formattedCountdown() -> String {
//        return totalSeconds > 0 ? String(format: "%02d:%02d:%02d", hours, minutes, seconds) : "Time's Up"
//    }
//}

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

//class CountdownTimerManager {
//    static let shared = CountdownTimerManager()
//    
//    private var timers: [IndexPath: Timer] = [:]
//    private var endTimes: [IndexPath: Date] = [:]
//    
//    var onUpdate: ((IndexPath, String) -> Void)?
//    
//    func startTimer(for indexPath: IndexPath, endTime: String) {
//        stopTimer(for: indexPath) // Stop any existing timer
//        
//        if let date = endTime.toDate() {
//            endTimes[indexPath] = date
//            
//            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//                guard let self = self else { return }
//                self.updateCountdown(for: indexPath)
//            }
//            timers[indexPath] = timer
//        }
//    }
//    
//    func stopTimer(for indexPath: IndexPath) {
//        print(indexPath)
//        timers[indexPath]?.invalidate()
//        timers.removeValue(forKey: indexPath)
//        endTimes.removeValue(forKey: indexPath)
//    }
//    
//    func updateCountdown(for indexPath: IndexPath) {
//        guard let endTime = endTimes[indexPath] else { return }
//        
//        let remainingTime = endTime.timeRemaining()
//        let formattedTime = remainingTime.formattedCountdown()
//        
//        DispatchQueue.main.async {
//            self.onUpdate?(indexPath, formattedTime)
//        }
//        
//        if remainingTime.totalSeconds <= 0 {
//            stopTimer(for: indexPath)
//        }
//    }
//    
//    func stopAllTimers() {
//        for indexPath in timers.keys {
//            stopTimer(for: indexPath)
//        }
//    }
//}

class CountdownTimerManager {
    static let shared = CountdownTimerManager()
    
    private var timers: [String: Timer] = [:]  // Use bookingId as the key
    private var endTimes: [String: Date] = [:]
    
    var onUpdate: ((String, String) -> Void)? // (bookingId, formatted time)

    func startTimer(for bookingId: String, endTime: String) {
        stopTimer(for: bookingId) // Ensure we don't create duplicate timers
        
        guard let endDate = getDate(from: endTime) else { return }
        endTimes[bookingId] = endDate
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer(bookingId: bookingId)
        }
        timers[bookingId] = timer
    }

    func stopTimer(for bookingId: String) {
        timers[bookingId]?.invalidate()
        timers.removeValue(forKey: bookingId)
        endTimes.removeValue(forKey: bookingId)
    }
    
    private func updateTimer(bookingId: String) {
        guard let endDate = endTimes[bookingId] else { return }
        
        let remainingTime = endDate.timeIntervalSinceNow
        if remainingTime <= 0 {
            stopTimer(for: bookingId)
            onUpdate?(bookingId, "Time's Up")
        } else {
            let timeString = formatTime(remainingTime)
            onUpdate?(bookingId, timeString)
        }
    }
    
    private func getDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = .current
        return formatter.date(from: string)
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func clearAllTimers() {
        timers.values.forEach { $0.invalidate() }
        timers.removeAll()
        endTimes.removeAll()
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = .current
        return formatter.date(from: self)
    }
}

extension Date {
    func timeRemaining() -> TimeRemaining {
        let now = Date()
        let difference = Int(self.timeIntervalSince(now))
        
        if difference <= 0 {
            return TimeRemaining(hours: 0, minutes: 0, seconds: 0)
        }
        
        let hours = difference / 3600
        let minutes = (difference % 3600) / 60
        let seconds = difference % 60
        return TimeRemaining(hours: hours, minutes: minutes, seconds: seconds)
    }
}
