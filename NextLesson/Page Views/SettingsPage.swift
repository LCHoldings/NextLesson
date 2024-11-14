//
//  SettingsPage.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import SwiftUI

struct SettingsPage: View {
    
    // 1:Automatic 2:Dark 3:Light
    @AppStorage("appearanceMode") private var appearanceMode: Int = 1
        
    @StateObject private var scheduleStore = ScheduleStore()
    @StateObject private var nickNamesStore = NickNamesStore()
    @StateObject private var favoriteStore = FavoriteStore()
    
    @State private var showingClearAllAlert: Bool = false
    
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var appBuild: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    HStack{
                        Image(systemName: "moon.fill")
                            .frame(width: 20, height: 0)
                        Picker(selection: $appearanceMode, label: Text("Color Scheme")) {
                            Text("Automatic").tag(1)
                            Text("Dark").tag(2)
                            Text("Light").tag(3)
                        }
                    }
                    Button(action: {
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .frame(width: 20, height: 0)
                            Text("App Language")
                        }
                    }
                    .foregroundColor(.primary)
                }
                
                // I need to get smarter first
                /*Section(header: Text("Preferences")) {
                    HStack{
                        Image(systemName: "clock.fill")
                            .frame(width: 20, height: 0)
                        Picker(selection: $useCountdowns, label: Text("Use Countdowns")) {
                            Text("Enable").tag(true)
                            Text("Disable").tag(false)
                        }
                    }
                }*/
                
                Section(header: Text("Information")) {
                    Button(action: {
                        if let url = URL(string: "https://github.com/LCHoldings/NextLesson") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "folder.fill.badge.gearshape")
                                .frame(width: 20, height: 0)
                            Text("GitHub Repository")
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/LCHoldings/NextLesson/issues/new?assignees=&labels=bug&projects=&template=bug_report.yml") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "ladybug.fill")
                                .frame(width: 20, height: 0)
                            Text("Issue/Bug Reporting")
                        }
                        .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/LCHoldings/NextLesson/issues/new?assignees=&labels=enhancement&projects=&template=feature_request.yml") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "rectangle.3.group.bubble.fill")
                                .frame(width: 20, height: 0)
                            Text("Feature Request")
                        }
                    }.foregroundColor(.primary)
                }
                
                Section(header: Text("AppData")) {
                    Button(action: {
                        showingClearAllAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Clear All Data")
                        }
                    }
                    .foregroundColor(.primary)
                    .alert("Are you sure?", isPresented: $showingClearAllAlert) {
                        Button("Clear All Data", role: .destructive) {
                            scheduleStore.clearAllSchedules()
                            nickNamesStore.clearAllNickNames()
                            favoriteStore.removeFavorite()
                        }
                        Button("Cancel", role: .cancel) {}
                    }

                }

                Section(header: Text("Credits")) {
                    Button(action: {
                        if let url = URL(string: "https://github.com/Lazylllama") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "swift")
                                .frame(width: 20, height: 0)
                            Text("Simon K - App Development")
                        }
                    }.foregroundColor(.primary)
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/cyberdev-tech") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "apple.terminal.fill")
                                .frame(width: 20, height: 0)
                            Text("Cyber - Backend")
                        }
                    }.foregroundColor(.primary)
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/balazshevesi") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .frame(width: 20, height: 0)
                            Text("Balazs H - Skola24 API Reference")
                        }
                    }.foregroundColor(.primary)
                }
                
                Section(header: Text("Build: \(appBuild)  |  Version: \(appVersion)")) {}
            }
            .navigationBarTitle("Settings ⚙️")
        }
    }
}

#Preview {
    SettingsPage()
}
