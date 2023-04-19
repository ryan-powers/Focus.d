//
//  ContentView.swift
//  Focus.d
//
//  Created by Ryan Powers on 4/10/23.
//

import SwiftUI

class isBreakTime: ObservableObject {
    @Published var isBreakTime: Bool = false
}

struct ContentView: View {
    @State private var selection: Tab = .home
    @StateObject private var timerStats = TimerStats() // Add this line

    enum Tab {
        case stats, home, settings
    }

    var body: some View {
        ZStack {
            Color.offWhite
                .ignoresSafeArea()
            VStack {
                Spacer()

                switch selection {
                    case .stats:
                        StatsView(timerStats: timerStats) // Modify this line
                    case .home:
                        HomeView(timerStats: timerStats) // Modify this line
                    case .settings:
                        SettingsView()
                }

                Spacer()

                HStack {
                    CustomTabItem(imageName: "bar_chart", selectedImageName: "bar_chart_filled", selectedTab: $selection, tab: .stats)
                    CustomTabItem(imageName: "logo", selectedImageName: "logo", selectedTab: $selection, tab: .home)
                    CustomTabItem(imageName: "user_outlined", selectedImageName: "user_filled", selectedTab: $selection, tab: .settings)

                }
                .frame(height: 50)
            }
        }
    }
}

struct CustomTabItem: View {
    let imageName: String
    let selectedImageName: String
    @Binding var selectedTab: ContentView.Tab
    let tab: ContentView.Tab

    init(imageName: String, selectedImageName: String, selectedTab: Binding<ContentView.Tab>, tab: ContentView.Tab, isSystemImage: Bool = false) {
        self.imageName = imageName
        self.selectedImageName = selectedImageName
        _selectedTab = selectedTab
        self.tab = tab
    }

    var body: some View {
           Button(action: {
               selectedTab = tab
           }) {
               Image(selectedTab == tab ? selectedImageName : imageName)
                   .resizable()
                   .frame(width: 30.0, height: 30)
           }
           .foregroundColor(selectedTab == tab ? .blue : .gray)
           .frame(maxWidth: .infinity)
       }
   }

struct HomeView: View {
    @ObservedObject var timerStats: TimerStats
    @State private var isBreakTime: Bool = false

    var body: some View {
        ZStack {
            TimerView(timerStats: timerStats, isBreakTime: $isBreakTime)
        }
    }
}

extension Color {
    static let offWhite = Color(red: 245/255, green: 245/255, blue: 245/255)
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
