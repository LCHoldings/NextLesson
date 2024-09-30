//
//  SchoolClass.swift
//  NextLesson
//
//  Created by Simon K on 2024-09-26.
//

import Foundation

struct SchoolClassResponse: Decodable {
    let classes: [SchoolClass]
}

struct SchoolClass: Decodable, Identifiable {
    let groupGuid: String
    let groupName: String

    var id: String {
        return self.groupGuid
    }
}