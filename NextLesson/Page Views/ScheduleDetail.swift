//
//  ScheduleDetail.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-29.
//

import SwiftUI

struct ScheduleDetail: View {
    var schedule: Schedule
    
    @StateObject private var scheduleStore = ScheduleStore()
    @StateObject private var scheduleManager = ScheduleManager()
    @StateObject private var nickNamesStore = NickNamesStore()
    @StateObject private var favoriteStore = FavoriteStore()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var nextLesson: ScheduleLessonInfo? = nil
    @State private var currentLesson: ScheduleLessonInfo? = nil
    @State private var showNicknameAlert: Bool = false
    @State private var removeClassAlert: Bool = false
    @State private var newNickname: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if let currentLesson = currentLesson {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Current Lesson")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        
                        Text(currentLesson.texts.first ?? "Unknown")
                            .font(.title2)
                        
                        Text("Teacher: \(currentLesson.texts[1])")
                            .font(.subheadline)
                        
                        Text("Classroom: \(currentLesson.texts[2])")
                            .font(.subheadline)
                        
                        if currentLesson.texts.count > 4 && !currentLesson.texts[3].isEmpty {
                            Text("Other: \(currentLesson.texts[3])")
                                .font(.subheadline)
                        }

                        Text("Begins At: \(formatTime(currentLesson.timeStart))")
                            .font(.subheadline)
                        
                        Text("Ends At: \(formatTime(currentLesson.timeEnd))")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
                }
                if let nextLesson = nextLesson {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Next Lesson")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        
                        Text(nextLesson.texts.first ?? "Unknown")
                            .font(.title2)
                        
                        Text("Teacher: \(nextLesson.texts[1])")
                            .font(.subheadline)
                        
                        Text("Classroom: \(nextLesson.texts[2])")
                            .font(.subheadline)
                        
                        if nextLesson.texts.count > 4 && !nextLesson.texts[3].isEmpty {
                            Text("Other: \(nextLesson.texts[3])")
                                .font(.subheadline)
                        }
                        
                        Text("Begins At: \(formatTime(nextLesson.timeStart))")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
                } else {
                    Text("No upcoming lessons today.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            Spacer()
            VStack {
                Text(schedule.municipality)
                    .font(.headline)
                    .foregroundColor(.gray)
                Text("Last edited: \(convertDate(date: schedule.lastPublished))")
                    .font(.headline)
                    .foregroundColor(.gray)
            }.padding()
        }
        .padding()
        .navigationTitle(schedule.className)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if nickNamesStore.hasNickName(for: schedule.className) {
                    Button(action: {
                        nickNamesStore.removeNickName(for: schedule.className)
                    }) {
                        Image(systemName: "pencil.slash")
                    }
                } else {
                    Button(action: {
                        showNicknameAlert = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
                
                Button(action: {
                    scheduleManager.municipality = schedule.municipality
                    scheduleManager.scheduleId = schedule.className
                    scheduleManager.unitGuid = schedule.unitGuid // Triggers refresh automatically
                    
                    scheduleManager.refreshItemsFromNetwork { scheduleData in
                        if let schedule = scheduleData {
                            scheduleStore.saveSchedule(className: schedule.className, schedule: schedule)
                            dismiss()
                        } else {
                            print("Failed to fetch schedule data.")
                        }
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }

                Button(action: {
                    removeClassAlert = true
                }) {
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
                .confirmationDialog("Remove Class", isPresented: $removeClassAlert, titleVisibility: .visible) {
                    Button("Delete Class") {
                        scheduleStore.removeSchedule(for: schedule.className)
                        if favoriteStore.favoriteSchedule == schedule.className {
                            favoriteStore.removeFavorite()
                        }
                        scheduleStore.loadSchedules()
                        dismiss()
                    }
                    
                    Button("Cancel", role: .cancel) {
                        showNicknameAlert = false
                    }
                }
                
                Button(action: {
                    favoriteStore.setFavorite(schedule: schedule)
                    favoriteStore.loadFavoriteSchedule()
                }) {
                    Image(systemName: favoriteStore.favoriteSchedule == schedule.className ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                .foregroundColor(.yellow)
            }
        }
        .alert("Change Nickname", isPresented: $showNicknameAlert, actions: {
            TextField("At least 3 characters", text: $newNickname)
            
            Button("Save Nickname") {
                if newNickname.count >= 3 {
                    nickNamesStore.saveNickName(className: schedule.className, nickName: newNickname)
                }
            }
            Button("Cancel", role: .cancel) {
                showNicknameAlert = false
            }
        }, message: {
            Text("Enter a new nickname for the class.")
        })

        .onAppear {
            findNextLesson()
            findCurrentLesson()
            favoriteStore.loadFavoriteSchedule()
        }
    }
    
    private func convertDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        let dateToReadable = DateFormatter()
        
        dateToReadable.dateFormat = "yyyy-MM-dd HH:mm"
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "sv_SE")
        
        guard let convertedDate = dateFormatter.date(from: date) else {
            return "Unknown Date"
        }
        
        return dateToReadable.string(from: convertedDate)
    }
    
    private func findNextLesson() {
        let currentDate = Date()
        
        let futureLessons = schedule.lessonInfo.filter { lesson in
            if let lessonStart = getLessonStartDate(lessonTime: lesson.timeStart) {
                return lessonStart > currentDate
            }
            return false
        }
        
        let currentDayLessons = futureLessons.filter { lesson in
            return checkLessonDay(dayOfWeekNumber: lesson.dayOfWeekNumber)
        }
        
        if let upcomingLesson = currentDayLessons.sorted(by: { lesson1, lesson2 in
            getLessonStartDate(lessonTime: lesson1.timeStart)! < getLessonStartDate(lessonTime: lesson2.timeStart)!
        }).first {
            nextLesson = upcomingLesson
        }
    }
    
    private func findCurrentLesson() {
        let currentDate = Date()
        
        let currentDayLessons = schedule.lessonInfo.filter { lesson in
            checkLessonDay(dayOfWeekNumber: lesson.dayOfWeekNumber)
        }
        
        let ongoingLessons = currentDayLessons.filter { lesson in
            if let lessonStart = getLessonStartDate(lessonTime: lesson.timeStart),
               let lessonEnd = getLessonEndDate(lessonTime: lesson.timeEnd) {
                return lessonStart <= currentDate && lessonEnd > currentDate
            }
            return false
        }
        
        if let currentLessonTemp = ongoingLessons.first {
            currentLesson = currentLessonTemp
        }
    }

}
