//
//  ContentView.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var municipalityManager: MunicipalityManager
    
    var body: some View {
        
        TabView {
            HomePage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Homepage")
                }
            SchedulesPage()
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Schedules")
                }
            SettingsPage()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView().environmentObject(MunicipalityManager())
}
