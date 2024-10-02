//
//  SchedulesView.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import SwiftUI

struct SchedulesPage: View {
    @StateObject private var scheduleStore = ScheduleStore()
    @StateObject private var favoriteStore = FavoriteStore()
    @StateObject private var nickNamesStore = NickNamesStore()
    
    @EnvironmentObject var municipalityManager: MunicipalityManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add Schedule")) {
                        NavigationLink {
                            MunicipalityDetails().environmentObject(MunicipalityManager())
                        } label: {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                    .frame(width: 20, height: 0)
                                Text("New Schedule")
                            }
                        }
                }
                Section(header: Text("Saved Schedules")) {
                    ForEach(Array(scheduleStore.schedules.keys.sorted()), id: \.self) { key in
                        if let schedule = scheduleStore.schedules[key] {
                            NavigationLink {
                                ScheduleDetail(schedule: schedule)
                            } label: {
                                if nickNamesStore.hasNickName(for: schedule.className) {
                                    HStack {
                                        Image(systemName: favoriteStore.favoriteSchedule == schedule.className ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .frame(width: 5, height: 0)
                                            .padding()
                                        Text(nickNamesStore.getNickName(for: schedule.className) ?? "Error")
                                        Text("(\(schedule.className))")
                                            .foregroundColor(Color.gray)
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: favoriteStore.favoriteSchedule == schedule.className ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .frame(width: 5, height: 0)
                                            .padding()
                                        Text(schedule.className)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Schedules 🗓️")
            .onAppear {
                scheduleStore.loadSchedules()
                nickNamesStore.loadNickNames()
                favoriteStore.loadFavoriteSchedule()
            }
        }
    }
}

#Preview {
    SchedulesPage()
}
