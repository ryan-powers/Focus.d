//
//  TimerView.swift
//  Focus.d
//
//  Created by Ryan Powers on 4/10/23.
//

import SwiftUI
import AudioToolbox

class TimerStats: ObservableObject {
    @Published var focusSessionsStarted: Int = 0
    @Published var focusSessionsCompleted: Int = 0
    @Published var totalFocusMinutes: Int = 0
    @Published var breakSessionsStarted: Int = 0
    @Published var breakSessionsCompleted: Int = 0
    @Published var totalBreakMinutes: Int = 0
    @Published var interruptions: Int = 0
    
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

struct TimerView: View {
    @AppStorage("focusDuration") private var focusDuration: Int = 25
    @AppStorage("breakDuration") private var breakDuration: Int = 5
    @AppStorage("longBreakDuration") var longBreakDuration: Int = 10
    @AppStorage("autoFlow") private var autoFlow: Bool = true
    @Binding var isBreakTime: Bool
    @ObservedObject var timerStats: TimerStats
    
    
    @State private var timeRemaining: Int
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    @State private var timerStarted = false
    @State private var completedFocusSessions: Int = 0
    @State private var completedCycles = 0
    @State private var currentCycleIndex: Int = 0
    @State private var progressValues: [CGFloat] = [0, 0, 0, 0]
    @State private var circleProgress: Int = 0
    

    
    init(timerStats: TimerStats, isBreakTime: Binding<Bool>) {
        self._isBreakTime = isBreakTime // Initialize isBreakTime
        self.timerStats = timerStats // Initialize timerStats
        self._timeRemaining = State(initialValue: 0)
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(isBreakTime ? "Rest" : "Focus")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                    .padding(.bottom, 100.0)
                    .frame(height: 5.0)
                Text("\(timeRemaining / 60):\(timeRemaining % 60 < 10 ? "0" : "")\(timeRemaining % 60)")
                    .font(.system(size: 65))
                    .fontWeight(.thin)
                    .padding(.bottom, 2.0)
                
                HStack(spacing: 10) {
                    ForEach(0..<4) { index in
                        ZStack {
                            if progressValues[index] >= 1.0 {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 8.0, height: 8.0)
                            }
                            if progressValues[index] < 2.0 {
                                Image(systemName: "circle.lefthalf.fill")
                                    .resizable()
                                    .frame(width: 8.0, height: 8.0)
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 100.0)
                
                Button(action: {
                    isRunning.toggle()
                    if isRunning {
                        timerStarted = true // update state variable
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }) {
                    if isRunning {
                        Image(systemName: "pause")
                            .resizable()
                            .foregroundColor(Color(red: 0.03137254901960784, green: 0.41568627450980394, blue: 0.7647058823529411))
                            .frame(width: 30, height: 30)
                            .fontWeight(.light)
                    } else {
                        Image(systemName: "play")
                            .resizable()
                            .foregroundColor(Color(red: 0.03137254901960784, green: 0.41568627450980394, blue: 0.7647058823529411))
                            .frame(width: 30, height: 30)
                            .fontWeight(.light)
                    }
                }
                .padding(.bottom, 250.0)
            }
            .padding(.bottom, 5.0)
            if timerStarted { // show reset button if timer started from initial state and is running
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            resetTimer()
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .resizable().frame(width: 20, height: 23)
                                .foregroundColor(.black)
                            
                        }
                        .padding(.trailing, 30.0)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .cornerRadius(5)
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            if isBreakTime {
                timeRemaining = breakDuration * 60
            } else {
                timeRemaining = focusDuration * 60
            }
        }
    }

    private func startTimer() {
        guard timer == nil else { return }

        if isBreakTime {
            timerStats.breakSessionsStarted += 1
        } else {
            timerStats.focusSessionsStarted += 1
        }

        isBreakTime.toggle() // Toggle isBreakTime when timer starts

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                isRunning = false

                if isBreakTime {
                    timerStats.breakSessionsCompleted += 1
                    if currentCycleIndex < 3 {
                        timerStats.totalBreakMinutes += breakDuration
                        timeRemaining = focusDuration * 60
                        currentCycleIndex += 1
                    } else {
                        timerStats.totalBreakMinutes += longBreakDuration
                        timeRemaining = focusDuration * 60
                        currentCycleIndex = 0
                        completedFocusSessions = 0
                        completedCycles = 0 // Reset completedCycles
                    }
                    isBreakTime = false
                } else {
                    timerStats.focusSessionsCompleted += 1
                    timerStats.totalFocusMinutes += focusDuration
                    isBreakTime = true
                    completedFocusSessions += 1
                    completedCycles += 1 // Increment completedCycles when focus session is completed
                    if currentCycleIndex < 3 {
                        timeRemaining = breakDuration * 60
                    } else {
                        timeRemaining = longBreakDuration * 60
                    }
                }

                if autoFlow {
                    isRunning = true
                    startTimer()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        if isRunning {
            if !isBreakTime {
                timerStats.interruptions += 1
            }
        }
    }

    private func resetTimer() {
        stopTimer()
        isRunning = false
        isBreakTime = false
        timeRemaining = focusDuration * 60
        timerStarted = false
        progressValues = [0, 0, 0, 0]
        completedCycles = 0
        circleProgress = 0
    }
}


struct TimerView_Previews: PreviewProvider {
    @State static var isBreakTimePreview = false
    static var timerStatsPreview = TimerStats()
    
    static var previews: some View {
        TimerView(timerStats: timerStatsPreview, isBreakTime: $isBreakTimePreview)
    }
}






