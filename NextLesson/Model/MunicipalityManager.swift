//
//  MunicipalityManager.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation
import Alamofire

class MunicipalityManager: ObservableObject {
    
    @Published var municipalities: [Municipality] = []
    
    init() {
        refreshItemsFromNetwork()
    }
    
    func refreshItemsFromNetwork() {
        AF.request("https://nextlesson-api-iqmm.onrender.com/v1/municipalities")
            .validate()
            .responseDecodable(of: [Municipality].self) { response in
                switch response.result {
                case .success(let municipalities):
                    self.municipalities = municipalities
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
