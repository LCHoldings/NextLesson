//
//  SchoolDetails.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import SwiftUI

struct SchoolDetails: View {
    var municipality: Municipality
    
    @StateObject private var schoolManager = SchoolManager()
    @State private var isLoading: Bool = true
    @State private var hasTimedOut: Bool = false

    var body: some View {
        VStack {
            if isLoading {
                // Spinner weeeee
                ProgressView("Loading schools...")
                    .padding()
            } else if schoolManager.schools.isEmpty {
                Text("No schools available.")
                    .padding()
            } else {
                List(schoolManager.schools) { school in
                    NavigationLink(destination: SchoolClassDetailsView(school: school, municipality: municipality)) {
                        Text(school.unitId) // Display school unitID (name)
                    }
                }
            }
        }
        .onAppear {
            schoolManager.municipality = municipality.namn
            
            // Fetch data from the network
            schoolManager.refreshItemsFromNetwork()
            
            // Handle timeout so it won't spin forever
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if schoolManager.schools.isEmpty {
                    hasTimedOut = true
                }
                isLoading = false
            }
        }
        .navigationTitle("Schools in \(municipality.namn)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let sampleMunicipality = Municipality(namn: "Kungälv")
    
    return NavigationView {
        SchoolDetails(municipality: sampleMunicipality)
    }
}
