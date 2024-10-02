//
//  Favorite.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-30.
//

import Foundation

class FavoriteStore: ObservableObject {
    @Published var favoriteSchedule: String?
    
    private let fileName = "favorite_schedule.json"
    
    init() {
        loadFavoriteSchedule()
    }
    
    func setFavorite(schedule: Schedule) {
        favoriteSchedule = schedule.className
        saveToFile()
    }
    
    func removeFavorite() {
        favoriteSchedule = nil
        saveToFile()
    }
    
    private func saveToFile() {
        do {
            let data = try JSONEncoder().encode(favoriteSchedule)
            try data.write(to: getDocumentsDirectory().appendingPathComponent(fileName))
        } catch {
            print("Error saving favorite schedule: \(error)")
        }
    }
    
    func loadFavoriteSchedule() {
        guard let data = readFromFile() else { return }
        
        do {
            favoriteSchedule = try JSONDecoder().decode(String?.self, from: data)
        } catch {
            // Fix: Shits errors when it decodes null.
            print("Error loading favorite schedule: \(error)")
        }
    }
    
    private func readFromFile() -> Data? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return try? Data(contentsOf: fileURL)
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
