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
    @State private var isLoading: Bool = true
    @State private var hasTimedOut: Bool = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading school classes...")
                    .padding()
            } else if schoolClassManager.schoolClasses.isEmpty {
                Text("No classes available for this school.")
                    .padding()
            } else {
                List(schoolClassManager.schoolClasses) { schoolClass in
                    Button(schoolClass.groupName) {
                        print("Get and save schedule: \(schoolClass.groupName)")
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
        .navigationTitle("Classes in \(school.unitId)") // unitID = School Name
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let sampleMunicipality = Municipality(namn: "Kungälv")
    let sampleSchool = School(unitGuid: "ZTE5NGJjMmUtYTY3Yi1mY2I1LWJmNjAtNzgyMDI0Zjg1ODJi", unitId: "Munkegärdeskolan")
    
    NavigationView {
        SchoolClassDetailsView(school: sampleSchool, municipality: sampleMunicipality)
    }
}
