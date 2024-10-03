//
//  SchoolManager.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation
import Alamofire

class SchoolManager: ObservableObject {
    
    @Published var schools: [School] = []
    
    var municipality: String = "" {
        didSet {
            refreshItemsFromNetwork() // Refresh data whenever the municipality changes
        }
    }
    
    init() {
        // Not really needed
    }
    
    func refreshItemsFromNetwork() {
        let urlString = "https://api.nextlesson.lcholdings.net/v1/schools/\(municipality)"
        
        AF.request(urlString)
            .responseDecodable(of: [School].self) { response in
                switch response.result {
                case .success(let schoolResponse):
                    self.schools = schoolResponse
                case .failure(let error):
                    self.schools = []
                    print("Error: \(error)")
                }
            }
    }
}
