//
//  Municipality.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation

struct Municipality: Decodable, Identifiable, Hashable {
    let namn: String
    var id: String {
        return self.namn
    }
}
