//
//  Schedule.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation

// 1 million percent broken

struct ScheduleResponse: Codable {
    let schedule: Schedule
}

struct Schedule: Codable, Identifiable {
    let data: ScheduleData
    let unitId: String
    
    var id: String {
        return self.unitId
    }
}

struct ScheduleData: Codable {
    let lessonInfo: [ScheduleLessonInfo]
    let metadata: [ScheduleMetadata]
}

struct ScheduleLessonInfo: Codable, Identifiable {
    let dayOfWeekNumber: Int
    let guidId: String
    let texts: [String]
    let timeEnd: String
    let timeStart: String
    
    var id: String {
        return self.guidId
    }
}

struct ScheduleMetadata: Codable {
    let lastPublished: String
    let schoolName: String
}
