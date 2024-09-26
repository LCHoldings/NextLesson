//
//  ScheduleManager.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation
import Alamofire

// 1 million percent broken

class ScheduleManager: ObservableObject {
    
    @Published var scheduleData: ScheduleData? // Changed to hold the data response
    
    var municipality: String = ""
    var scheduleId: String = ""
    var unitGuid: String = "" {
        didSet {
            refreshItemsFromNetwork() // Refresh data whenever the unitGuid changes
        }
    }
    
    init() {}

    // Updated completion handler type to ScheduleData
    func refreshItemsFromNetwork(completion: ((ScheduleData?) -> Void)? = nil) {
        print("1: \(municipality)")
        print("2: \(unitGuid)")
        print("3: \(scheduleId)")

        let urlString = "https://km7jvdrp-3000.euw.devtunnels.ms/api/v1/schedule/\(municipality)/\(unitGuid)/\(scheduleId)"
        
        AF.request(urlString)
            .responseDecodable(of: ScheduleResponse.self) { response in
                switch response.result {
                case .success(let scheduleResponse):
                    // Update the published property with the schedule data
                    self.scheduleData = scheduleResponse.schedule.data
                    print(self.scheduleData)
                    completion?(self.scheduleData) // Pass the data to the completion handler
                    
                case .failure(let error):
                    self.scheduleData = nil // Clear previous data
                    print("Error: \(error)")
                }
            }
    }
}

