//
//  ScreenTimeManager.swift
//  MindNest
//
//  Created by Vanessa Wartemberg on 5/20/25.
//

import SwiftUI
import DeviceActivity
import ManagedSettings
import FamilyControls

class ScreenTimeManager {
    static let shared = ScreenTimeManager()
    
    // Request authorization from the user
    func requestAuthorization() async -> Bool {
        do {
            // Request authorization
            let authorized: () = try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            return true
        } catch {
            print("Authorization error: \(error)")
            return false
        }
    }
}

// MARK: – Name your schedule
extension DeviceActivityName {
    static let daily = DeviceActivityName("daily-monitor")
}

// MARK: – Monitor start/stop logic
class ScreenTimeMonitor {
    static let shared = ScreenTimeMonitor()
    
    func start() {
        // builds a daily schedule (24hrs repeating)
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd:   DateComponents(hour: 23, minute: 59),
            repeats:       true
        )
        // tells the system to start monitoring under the name we set (daily)
        do {
            try DeviceActivityCenter().startMonitoring(.daily, during: schedule)
            print("Monitoring started")
        } catch {
            print("Monitor failed: \(error)")
        }
    }

    func stop() {
        // stopMonitoring takes in an array of names
        DeviceActivityCenter().stopMonitoring([.daily])
    }
}
