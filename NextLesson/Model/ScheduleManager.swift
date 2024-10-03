//
//  ScheduleManager.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation
import Alamofire

class ScheduleManager: ObservableObject {
    
    @Published var scheduleData: Schedule?
    
    var municipality: String = ""
    var scheduleId: String = ""
    var unitGuid: String = "" {
        didSet {
            refreshItemsFromNetwork() // Refresh data whenever the unitGuid changes
        }
    }
    
    init() {}

    func refreshItemsFromNetwork(completion: ((Schedule?) -> Void)? = nil) {
        guard !municipality.isEmpty, !unitGuid.isEmpty, !scheduleId.isEmpty else {
            print("Invalid parameters: municipality, unitGuid, or scheduleId is missing.")
            completion?(nil)
            return
        }

        let urlString = "https://api.nextlesson.lcholdings.net/v1/schedule/\(municipality)/\(unitGuid)/\(scheduleId)"
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: Schedule.self) { response in
                switch response.result {
                case .success(let schedule):
                    self.scheduleData = schedule
                    completion?(self.scheduleData)
                    
                case .failure(let error):
                    self.scheduleData = nil
                    print("Error fetching schedule: \(error.localizedDescription)")
                    completion?(nil)
                }
            }
    }
}
