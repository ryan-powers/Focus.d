//
//  SettingsView.swift
//  Focus.d
//
//  Created by Ryan Powers on 4/11/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("focusDuration") var focusDuration: Int = 25
    @AppStorage("breakDuration") var breakDuration: Int = 5
    @AppStorage("longBreakDuration") var longBreakDuration: Int = 10
    @AppStorage("autoFlow") var autoFlow: Bool = true // new AppStorage for auto flow toggle

    let focusDurations = [1, 15, 20, 25, 30, 45, 60]
    let breakDurations = [1, 5, 15, 20]
    let longBreakDurations = [2, 10, 20, 30]

    var body: some View {
        ZStack {
            Color.offWhite
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding()

                VStack(alignment: .leading) {
                    Text("Focus Duration")
                        .font(.headline)
                        .padding(.bottom, 5)
                        .fontWeight(.medium)
                    Menu {
                        ForEach(focusDurations, id: \.self) { duration in
                            Button("\(duration) mins") {
                                focusDuration = duration
                            }
                        }
                    } label: {
                        Text("\(focusDuration) mins")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.offWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.bottom)

                    Text("Short Break")
                        .font(.headline)
                        .padding(.bottom, 5)
                        .fontWeight(.medium)
                    Menu {
                        ForEach(breakDurations, id: \.self) { duration in
                            Button("\(duration) mins") {
                                breakDuration = duration
                            }
                        }
                    } label: {
                        Text("\(breakDuration) mins")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.offWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.bottom)
                    
                    Text("Long Break")
                        .font(.headline)
                        .padding(.bottom, 5)
                        .fontWeight(.medium)
                    Menu {
                        ForEach(longBreakDurations, id: \.self) { duration in
                            Button("\(duration) mins") {
                                longBreakDuration = duration
                            }
                        }
                    } label: {
                        Text("\(longBreakDuration) mins")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.offWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Text("Auto Flow")
                            .font(.headline)
                            .padding(.bottom, 5)
                            .fontWeight(.medium)
                        Spacer()
                        Toggle("", isOn: $autoFlow)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                    }
                    .padding(.bottom)

                }
                .padding()

                Spacer()
            }
        }
    }
}
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
