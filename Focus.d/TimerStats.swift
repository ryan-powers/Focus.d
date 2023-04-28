//
//  TimerStats.swift
//  Focus.d
//
//  Created by Ryan Powers on 4/28/23.
//

import SwiftUI
import Combine

class TimerStats: ObservableObject {
    @Published var focusSessionsStarted: Int = 0
    @Published var focusSessionsCompleted: Int = 0
    @Published var totalFocusMinutes: Int = 0
    @Published var breakSessionsStarted: Int = 0
    @Published var breakSessionsCompleted: Int = 0
    @Published var totalBreakMinutes: Int = 0
    @Published var interruptions: Int = 0
    @Published var totalSessions: Int = 0
    
    func resetStatistics() {
            focusSessionsStarted = 0
            focusSessionsCompleted = 0
            totalFocusMinutes = 0
            breakSessionsStarted = 0
            breakSessionsCompleted = 0
            totalBreakMinutes = 0
            interruptions = 0
        }
}
