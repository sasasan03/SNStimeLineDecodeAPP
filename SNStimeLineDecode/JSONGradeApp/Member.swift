//
//  Member.swift
//  DecodeExample
//
//  Created by akio0911 on 2024/02/21.
//

import Foundation

struct Member {
    enum Grade {
        case gold
        case silver
        case bronze
        case unknown(name: String)
    }

    let id: Int
    let name: String
    let grade: Grade
}
