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
        AF.request("https://km7jvdrp-3000.euw.devtunnels.ms/api/v1/municipalities")
            .responseDecodable(of: MunicipalityResponse.self) { response in
                switch response.result {
                case .success(let municipalityResponse):
                    // Update the municipalities with data from the network
                    self.municipalities = municipalityResponse.municipalities
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
