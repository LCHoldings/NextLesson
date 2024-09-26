//
//  Municipality.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation

struct MunicipalityResponse: Decodable {
    let municipalities: [Municipality]
}

struct Municipality: Decodable, Identifiable, Hashable {
    let namn: String
    let id = UUID()
}
