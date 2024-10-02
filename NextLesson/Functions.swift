//
//  Functions.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-30.
//

import Foundation

func formatTime(_ time: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "HH:mm:ss"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "HH:mm"
    
    if let date = inputFormatter.date(from: time) {
        return outputFormatter.string(from: date)
    }
    
    return time
}

func getLessonStartDate(lessonTime: String) -> Date? {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    
    guard let timeDate = formatter.date(from: lessonTime) else { return nil }
    
    let lessonComponents = calendar.dateComponents([.hour, .minute, .second], from: timeDate)
    
    return calendar.date(bySettingHour: lessonComponents.hour ?? 0,
                         minute: lessonComponents.minute ?? 0,
                         second: lessonComponents.second ?? 0,
                         of: Date())
}

func getLessonEndDate(lessonTime: String) -> Date? {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    
    guard let timeDate = formatter.date(from: lessonTime) else { return nil }
    
    let lessonComponents = calendar.dateComponents([.hour, .minute, .second], from: timeDate)
    
    let currentDate = Date()
    
    return calendar.date(bySettingHour: lessonComponents.hour ?? 0,
                         minute: lessonComponents.minute ?? 0,
                         second: lessonComponents.second ?? 0,
                         of: currentDate)
}


func checkLessonDay(dayOfWeekNumber: Int) -> Bool {
    let weekday = Calendar.current.component(.weekday, from: Date()) - 1
    return weekday == dayOfWeekNumber
}
