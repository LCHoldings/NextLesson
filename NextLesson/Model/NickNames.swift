//
//  NickNames.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-30.
//

import Foundation

struct NickName: Codable, Identifiable {
    let className: String
    let nickName: String

    var id: String {
        return self.className
    }
}

class NickNamesStore: ObservableObject {
    @Published var nickNames: [String: NickName] = [:]
    
    private let fileName = "nicknames.json"
    
    init() {
        loadNickNames()
    }
    
    func saveNickName(className: String, nickName: String) {
        let newNickName = NickName(className: className, nickName: nickName)
        nickNames[className] = newNickName
        saveToFile()
    }
    
    func getNickName(for className: String) -> String? {
        return nickNames[className]?.nickName
    }
    
    func hasNickName(for className: String) -> Bool {
        if let nickname = nickNames[className], !nickname.nickName.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func loadNickNames() {
        guard let data = readFromFile() else { return }
        
        do {
            let loadedNickNames = try JSONDecoder().decode([String: NickName].self, from: data)
            self.nickNames = loadedNickNames
        } catch {
            print("Error loading nicknames: \(error)")
        }
    }
    
    private func saveToFile() {
        do {
            let data = try JSONEncoder().encode(nickNames)
            try data.write(to: getDocumentsDirectory().appendingPathComponent(fileName))
        } catch {
            print("Error saving nicknames: \(error)")
        }
    }
    
    private func readFromFile() -> Data? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        return try? Data(contentsOf: fileURL)
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func clearAllNickNames() {
        nickNames.removeAll()
        saveToFile()
    }
    
    func removeNickName(for className: String) {
        nickNames.removeValue(forKey: className)
        saveToFile()
    }
}
