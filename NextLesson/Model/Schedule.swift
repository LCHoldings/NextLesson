//
//  Schedule.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import SwiftData
import Foundation

struct Schedule: Codable, Identifiable {
    let date: ScheduleDate
    let lessonInfo: [ScheduleLessonInfo]
    let schoolName: String
    let lastPublished: String
    let className: String
    let municipality: String
    let unitGuid: String
    
    var id: String {
        return self.className
    }
}

struct ScheduleDate: Codable {
    let year: Int
    let week: Int
    let day: Int
}

struct ScheduleLessonInfo: Codable, Identifiable {
    let dayOfWeekNumber: Int
    let guidId: String
    let texts: [String]
    let timeEnd: String
    let timeStart: String
    let blockName: String
    
    var id: String {
        return self.guidId
    }
}

// Beyond my understanding currently
class ScheduleStore: ObservableObject {
    @Published var schedules: [String: Schedule] = [:]
    @Published var favorites: [String: Bool] = [:]
    
    private let fileName = "schedules.json"
    
    init() {
        loadSchedules()
    }
    
    func saveSchedule(className: String, schedule: Schedule) {
        schedules[className] = schedule
        saveToFile()
    }
    
    func loadSchedules() {
        guard let data = readFromFile(fileName: fileName) else { return }
        
        do {
            let loadedSchedules = try JSONDecoder().decode([String: Schedule].self, from: data)
            self.schedules = loadedSchedules
            objectWillChange.send()
        } catch {
            print("Error loading schedules: \(error)")
        }
    }
    
    private func saveToFile() {
        do {
            let data = try JSONEncoder().encode(schedules)
            try data.write(to: getDocumentsDirectory().appendingPathComponent(fileName))
        } catch {
            print("Error saving schedules: \(error)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
    private func readFromFile(fileName: String) -> Data? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return try? Data(contentsOf: fileURL)
    }
    
    func clearAllSchedules() {
        schedules.removeAll()
        saveToFile()
    }
    
    func removeSchedule(for className: String) {
        schedules.removeValue(forKey: className)
        saveToFile()
    }
}
