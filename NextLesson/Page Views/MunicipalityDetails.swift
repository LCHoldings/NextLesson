//
//  MunicipalityDetails.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import SwiftUI

struct MunicipalityDetails: View {
    @EnvironmentObject var municipalityManager: MunicipalityManager
    
    @State private var customHostName: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Custom Hostname")) {
                    TextField("kungalv.skola24.se", text: $customHostName)
                    NavigationLink(value: Municipality(namn: removeSkola24(text: customHostName))) {
                        Text("Submit")
                    }
                }
                
                Section(header: Text("Municipalities")) {
                    if municipalityManager.municipalities.isEmpty {
                        VStack {
                            Image(systemName: "wifi.exclamationmark")
                            Text("Check your internet connection.")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    } else {
                        ForEach(municipalityManager.municipalities) { municipality in
                            NavigationLink(value: municipality) {
                                Text(municipality.namn)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Hostname")
            .navigationDestination(for: Municipality.self) { municipality in
                SchoolDetails(municipality: municipality)
            }
        }
    }
    
    private func removeSkola24(text: String) -> String {
        if text.contains(".skola24.se") {
            let municipalityName = customHostName.replacingOccurrences(of: ".skola24.se", with: "")
            return municipalityName
        } else {
            return text
        }
    }
}

#Preview {
    MunicipalityDetails().environmentObject(MunicipalityManager())
}
