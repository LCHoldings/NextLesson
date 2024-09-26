//
//  School.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation

struct SchoolResponse: Decodable {
    let schools: [School]
}

struct School: Decodable, Identifiable {
    let unitGuid: String
    let unitId: String
    
    var id: String {
        return self.unitGuid
    }
}
