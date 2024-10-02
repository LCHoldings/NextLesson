//
//  NextLessonWidgets.swift
//  NextLessonWidgets
//
//  Created by Simon K on 2024-10-01.
//

import WidgetKit
import SwiftUI

import WidgetKit
import SwiftUI

struct FavoriteScheduleEntry: TimelineEntry {
    let date: Date
    let schedule: String?
}

struct FavoriteScheduleWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "FavoriteScheduleWidget", provider: FavoriteScheduleProvider()) { entry in
            VStack {
                if let schedule = entry.schedule {
                    Text(schedule)
                        .font(.headline)
                } else {
                    Text("No favorite schedule")
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .configurationDisplayName("Favorite Schedule")
        .description("Displays your favorite class schedule.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    FavoriteScheduleWidget()
} timeline: {
    let sampleEntry = FavoriteScheduleEntry(date: Date(), schedule: "Math Class") // Example schedule
    Timeline(entries: [sampleEntry], policy: .atEnd)
}
