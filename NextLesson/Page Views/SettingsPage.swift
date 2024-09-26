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
                }
                
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
                        if let url = URL(string: "https://github.com/LCHoldings/NextLesson/issues/new?assignees=&labels=&projects=&template=bug_report.yml") {
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
                        // TODO
                    }) {
                        HStack {
                            Image(systemName: "rectangle.3.group.bubble.fill")
                                .frame(width: 20, height: 0)
                            Text("Feature Request")
                        }
                    }.foregroundColor(.primary)
                }
                
                Section(header: Text("Cache")) {
                    Button(action: {
                        // TODO: Clear and refetch cache
                        print("Clear Cache Func")
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Clear Cache")
                        }
                    }.foregroundColor(.primary)
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
                            Text("Lazyllama - App Development")
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
            .navigationBarTitle("Settings")
        }
    }
}

#Preview {
    SettingsPage()
}
