//
//  TimerView.swift
//  Focus.d
//
//  Created by Ryan Powers on 4/10/23.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var timerStats: TimerStats
    @Binding var isBreakTime: Bool
    
    
    init(timerManager: TimerManager, timerStats: TimerStats, isBreakTime: Binding<Bool>) {
        self.timerManager = timerManager
        self.timerStats = timerStats
        self._isBreakTime = isBreakTime
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text(timerManager.isBreakTime ? "Rest" : "Focus")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                    .padding(.bottom, 20.0)
                    .frame(height: 5.0)
                Text("\(timerManager.timeRemaining / 60):\(timerManager.timeRemaining % 60 < 10 ? "0" : "")\(timerManager.timeRemaining % 60)")
                    .font(.system(size: 90))
                    .fontWeight(.thin)
                    .padding(.bottom, 2.0)
                
                HStack(spacing: 10) {
                    ForEach(0..<4) { index in
                        CircleFill(index: index, totalSessions: timerStats.totalSessions)
                    }
                }
                
                Spacer()
                    .frame(height: 100.0)
                
                Button(action: {
                    timerManager.isRunning.toggle()
                    if timerManager.isRunning {
                        timerManager.startTimer()
                    } else {
                        timerManager.stopTimer()
                    }
                }) {
                    if timerManager.isRunning {
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
            if timerManager.timerStarted {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            timerManager.resetTimer()
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
    }
    
    
    struct CircleFill: View {
        let index: Int
        let totalSessions: Int
        var halfFilled: Bool {
            return totalSessions - 1 == index * 2
        }
        
        var body: some View {
            ZStack {
                if halfFilled {
                    Image(systemName: "circle.lefthalf.fill")
                        .resizable()
                        .frame(width: 10.0, height: 10.0)
                } else if totalSessions > index * 2 {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 10.0, height: 10.0)
                } else {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 10.0, height: 10.0)
                }
            }
        }
    }
    
    
    struct TimerView_Previews: PreviewProvider {
        @AppStorage("focusDuration") static var focusDuration: Int = 25
        static var timerStatsPreview = TimerStats()
        static var timerManagerPreview = TimerManager(isBreakTime: false, timeRemaining: focusDuration * 60, timerStats: timerStatsPreview)
        
        static var previews: some View {
            TimerView(timerManager: timerManagerPreview, timerStats: timerStatsPreview, isBreakTime: .constant(false))
        }
    }
}
