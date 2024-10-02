//
//  SchoolClassDetails.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import SwiftUI

struct SchoolClassDetailsView: View {
    var school: School
    var municipality: Municipality
    
    @StateObject private var schoolClassManager = SchoolClassManager()
    @StateObject private var scheduleManager = ScheduleManager()
    @StateObject private var scheduleStore = ScheduleStore()
    @State private var isLoading: Bool = true
    @State private var hasTimedOut: Bool = false
    @State private var customClassName: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading school classes...")
                    .padding()
            } else if schoolClassManager.schoolClasses.isEmpty {
                Text("No classes available for this school.")
                    .padding()
            } else {
                List {
                    Section(header: Text("Custom Class")) {
                        TextField("Mu22A", text: $customClassName)
                        Button("Submit") {
                            scheduleManager.municipality = municipality.namn
                            scheduleManager.scheduleId = customClassName
                            scheduleManager.unitGuid = school.unitGuid // Triggers refresh automatically
                            
                            scheduleManager.refreshItemsFromNetwork { scheduleData in
                                if let schedule = scheduleData {
                                    scheduleStore.saveSchedule(className: customClassName, schedule: schedule)
                                    dismiss()
                                } else {
                                    print("Failed to fetch schedule data.")
                                }
                            }
                        }.foregroundColor(.primary)
                    }
                    Section(header: Text("Available Classes")) {
                        ForEach(schoolClassManager.schoolClasses) { schoolClass in
                            Button(schoolClass.groupName) {
                                scheduleManager.municipality = municipality.namn
                                scheduleManager.scheduleId = schoolClass.groupName
                                scheduleManager.unitGuid = school.unitGuid // Triggers refresh automatically
                                
                                scheduleManager.refreshItemsFromNetwork { scheduleData in
                                    if let schedule = scheduleData {
                                        scheduleStore.saveSchedule(className: schoolClass.groupName, schedule: schedule)
                                        dismiss()
                                    } else {
                                        print("Failed to fetch schedule data.")
                                    }
                                }
                            }.foregroundColor(.primary)
                        }
                    }
                
                }
            }
        }
        .onAppear {
            schoolClassManager.municipality = municipality.namn
            schoolClassManager.unitGuid = school.unitGuid
            
            // Fetch school classes
            schoolClassManager.refreshItemsFromNetwork()
            
            // Handle timeout
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if schoolClassManager.schoolClasses.isEmpty {
                    hasTimedOut = true
                    isLoading = false
                } else {
                    isLoading = false
                }
            }
        }
        .navigationTitle("Classes in \(school.unitId)") // unitId = School Name
        .navigationBarTitleDisplayMode(.inline)
    }
}

