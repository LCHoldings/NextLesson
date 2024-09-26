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
        let urlString = "https://km7jvdrp-3000.euw.devtunnels.ms/api/v1/schools/\(municipality)"
        
        AF.request(urlString)
            .responseDecodable(of: SchoolResponse.self) { response in
                switch response.result {
                case .success(let schoolResponse):
                    self.schools = schoolResponse.schools
                
                case .failure(let error):
                    self.schools = []
                    print("Error: \(error)")
                }
            }
    }
}
