//
//  HomePage.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-27.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var scheduleStore = ScheduleStore()
    @StateObject private var favoriteStore = FavoriteStore()
    @State private var showingClearAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if scheduleStore.schedules.isEmpty {
                    VStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        Text("No Schedules Available")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                        
                        Text("You haven't added any schedules yet. Try adding one from the schedule section.")
                            .font(.body)
                            .foregroundColor(.gray.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.9))
                } else {
                    List {
                        ForEach(Array(scheduleStore.schedules.keys.sorted()), id: \.self) { key in
                            if let schedule = scheduleStore.schedules[key] {
                                ScheduleCard(schoolClass: SchoolClass(groupGuid: key, groupName: key), schedule: schedule)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal)
                }
            }
            .navigationTitle(currentGreeting())
        }
        .onAppear {
            scheduleStore.loadSchedules()
            favoriteStore.loadFavoriteSchedule()
        }
    }
}
    
private func currentGreeting() -> String {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 0..<12:
        return "Good Morning! ☀️"
    case 12..<18:
        return "Hello There! 👋🏻"
    default:
        return "Good Evening! 🌙"
    }
}

#Preview {
    HomePage()
}
