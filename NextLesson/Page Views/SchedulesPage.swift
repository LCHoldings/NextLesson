//
//  SchedulesView.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import SwiftUI

struct SchedulesPage: View {
    @EnvironmentObject var municipalityManager: MunicipalityManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("test")) {
                        NavigationLink {
                            MunicipalityDetails().environmentObject(MunicipalityManager())
                        } label: {
                            Text("New Schedule")
                        }
                }
            }.navigationTitle("Schedules")
        }
    }
}

#Preview {
    SchedulesPage()
}
