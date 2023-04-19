//
//  StatsView.swift
//  Focus.d
//
//  Created by Ryan Powers on 4/11/23.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var timerStats: TimerStats
    
    init(timerStats: TimerStats) {
        self.timerStats = timerStats
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Statistics")
                .font(.largeTitle)
                .fontWeight(.medium)
            
            Group {
                Text("Focus Sessions")
                    .font(.title2)
                    .fontWeight(.regular)
                    .padding(.top)
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Started:")
                            .padding(.bottom)
                        Text("Completed:")
                            .padding(.bottom)
                        Text("Total Minutes:")
                            .padding(.bottom)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(timerStats.focusSessionsStarted)")
                            .padding(.bottom)
                        Text("\(timerStats.focusSessionsCompleted)")
                            .padding(.bottom)
                        Text("\(timerStats.totalFocusMinutes)")
                            .padding(.bottom)
                    }
                }
                .padding()
            }
            
            Group {
                Text("Break Sessions")
                    .font(.title2)
                    .fontWeight(.regular)
                    .padding(.top)
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Started:")
                            .padding(.bottom)
                        Text("Completed:")
                            .padding(.bottom)
                        Text("Total Minutes:")
                            .padding(.bottom)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(timerStats.breakSessionsStarted)")
                            .padding(.bottom)
                        Text("\(timerStats.breakSessionsCompleted)")
                            .padding(.bottom)
                        Text("\(timerStats.totalBreakMinutes)")
                            .padding(.bottom)
                    }
                }
                .padding()
            }
            
            Group {
                Text("Interruptions")
                    .font(.title2)
                    .fontWeight(.regular)
                    .padding(.top)
                Divider()
                
                HStack {
                    Text("Total:")
                    Spacer()
                    Text("\(timerStats.interruptions)")
                }
                .padding()
            }
            HStack {
                Spacer()
                Button(action: {
                    timerStats.resetStatistics()
                }) {
                    Text("Reset Statistics")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding()
        }
        .padding(.leading)
    }
}
struct StatsView_Previews: PreviewProvider {
    static var timerStats = TimerStats()
    
    static var previews: some View {
        StatsView(timerStats: timerStats)
    }
}
