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
        let urlString = "https://api.nextlesson.lcholdings.net/v1/classes/\(municipality)/\(unitGuid)"
        AF.request(urlString)
            .validate()
            .responseDecodable(of: [SchoolClass].self) { response in
                switch response.result {
                case .success(let schoolClassesTemp):
                    self.schoolClasses = schoolClassesTemp
                case .failure(let error):
                    self.schoolClasses = [] // Clear previous data
                    print("Error: \(error)")
                }
            }
    }
}
