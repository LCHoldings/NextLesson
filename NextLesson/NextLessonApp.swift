//
//  NextLessonApp.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-25.
//

import SwiftUI

@main
struct NextLessonApp: App {
    @AppStorage("appearanceMode") private var appearanceMode: Int = 1
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appearanceMode == 1 ? .none : appearanceMode == 2 ? .dark : .light)
        }
    }
}
