//
//  ScheduleCard.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-27.
//

import SwiftUI

struct ScheduleCard: View {
    @StateObject private var favoriteStore = FavoriteStore()
    @StateObject private var nickNamesStore = NickNamesStore()
    
    @State private var nextLesson: ScheduleLessonInfo? = nil
    @State private var currentLesson: ScheduleLessonInfo? = nil

    var schoolClass: SchoolClass
    var schedule: Schedule
    
    var body: some View {
        NavigationLink(destination: ScheduleDetail(schedule: schedule)) {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(schedule.schoolName)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        if let storedNickname = nickNamesStore.getNickName(for: schedule.className), !storedNickname.isEmpty {
                            Text(storedNickname)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.85))
                        } else {
                            Text("No Nickname")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    Spacer()
                    
                    Text(schoolClass.groupName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                    
                    Image(systemName: favoriteStore.favoriteSchedule == schedule.className ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                .padding(.top, 15)
                .padding(.horizontal, 15)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        if let currentLesson = currentLesson {
                            Text("Current Class: \(currentLesson.texts.first ?? "Unknown")")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("\(currentLesson.timeStart) - \(currentLesson.timeEnd)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        } else {
                            if let nextLesson = nextLesson {
                                Text("Next Class: \(nextLesson.texts.first ?? "Unknown")")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Text("\(formatTime(nextLesson.timeStart)) - \(formatTime(nextLesson.timeEnd))")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            } else {
                                Text("No upcoming classes")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 15)
                .padding(.horizontal, 15)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("AccentColor"), Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
            .frame(height: 140)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 6)
        .onAppear {
            favoriteStore.loadFavoriteSchedule()
            nickNamesStore.loadNickNames()
            findNextLesson()
            findCurrentLesson()
        }
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
