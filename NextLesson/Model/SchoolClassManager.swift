//
//  SchoolClassManager.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation
import Alamofire

class SchoolClassManager: ObservableObject {
    
    @Published var schoolClasses: [SchoolClass] = []
    
    var municipality: String = ""
    var unitGuid: String = "" {
        didSet {
            refreshItemsFromNetwork() // Refresh data whenever the unitGuid changes
        }
    }
    
    init() {
        // Not really needed
    }
    
    func refreshItemsFromNetwork() {
        let urlString = "https://km7jvdrp-3000.euw.devtunnels.ms/api/v1/classes/\(municipality)/\(unitGuid)"
        
        AF.request(urlString)
            .responseDecodable(of: SchoolClassResponse.self) { response in
                switch response.result {
                case .success(let schoolClassResponse):
                    self.schoolClasses = schoolClassResponse.classes
                case .failure(let error):
                    self.schoolClasses = [] // Clear previous data
                    print("Error: \(error)")
                }
            }
    }
}
