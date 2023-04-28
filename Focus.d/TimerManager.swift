//
//  TimerManager.swift
//  Focus.d
//
//  Created by Ryan Powers on 4/28/23.
//

import Foundation

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int
    @Published var isRunning = false
    @Published var isBreakTime: Bool
    @Published var timerStats: TimerStats

    private var focusDuration: Int {
        return UserDefaults.standard.integer(forKey: "focusDuration")
    }
    private var breakDuration: Int {
        return UserDefaults.standard.integer(forKey: "breakDuration")
    }
    private var longBreakDuration: Int {
        return UserDefaults.standard.integer(forKey: "longBreakDuration")
    }
    private var autoFlow: Bool {
        return UserDefaults.standard.bool(forKey: "autoFlow")
    }

    var timer: Timer? = nil
    var timerStarted = false
    var completedFocusSessions: Int = 0
    var currentCycleIndex: Int = 0
    var pauseActivated = false

    init(isBreakTime: Bool, timeRemaining: Int, timerStats: TimerStats) {
        let defaultValues: [String: Any] = [
            "focusDuration": 25,
            "breakDuration": 5,
            "longBreakDuration": 10,
            "autoFlow": true
        ]
        UserDefaults.standard.register(defaults: defaultValues)

        self.isBreakTime = isBreakTime
        self.timeRemaining = timeRemaining
        self.timerStats = timerStats
    }

    func startTimer() {
        guard timer == nil else { return }

        if isBreakTime {
            timerStats.breakSessionsStarted += 1
        } else {
            timerStats.focusSessionsStarted += 1
        }

        if !pauseActivated {
            timerStats.totalSessions += 1
        }
        
        timerStarted = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.isRunning = false

                if self.isBreakTime {
                    self.timerStats.breakSessionsCompleted += 1
                    if self.currentCycleIndex < 6 {
                        self.timerStats.totalBreakMinutes += self.breakDuration
                        self.timeRemaining = self.focusDuration * 60
                        self.currentCycleIndex += 2
                    } else {
                        self.timerStats.totalBreakMinutes += self.longBreakDuration
                        self.resetTimer()
                        return
                    }
                    self.isBreakTime = false
                }
                else {
                    self.timerStats.focusSessionsCompleted += 1
                    self.timerStats.totalFocusMinutes += self.focusDuration
                    self.isBreakTime = true
                    self.completedFocusSessions += 1
                    if self.currentCycleIndex < 6 {
                        self.timeRemaining = self.breakDuration * 60
                    } else {
                        self.timeRemaining = self.longBreakDuration * 60
                    }
                }

                if self.autoFlow {
                    self.isRunning = true && self.currentCycleIndex < 7
                    self.startTimer()
                } else {
                    self.stopTimer()
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        if isRunning {
            if !isBreakTime {
                timerStats.interruptions += 1
            }
        }
    }

    func resetTimer() {
        stopTimer()
        isRunning = false
        isBreakTime = false
        timeRemaining = focusDuration * 60
        timerStarted = false
        timerStats.totalSessions = 0
        currentCycleIndex = 0
        completedFocusSessions = 0
    }
}

