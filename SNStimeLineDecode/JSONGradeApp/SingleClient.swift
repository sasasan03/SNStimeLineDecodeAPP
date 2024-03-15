//
//  SingleClient.swift
//  DecodeExample
//
//  Created by akio0911 on 2024/02/21.
//

import Foundation

struct SingleClient {
    struct ResponseDTO: Decodable {
        let id: Int
        let name: String
        let grade: String
    }

    func fetch() throws -> Member {
        let jsonData = """
        {
            "id": 111,
            "name": "sako",
            "grade": "xxx"
        }
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(ResponseDTO.self, from: jsonData)
        return Member(dto: dto)
    }
}

private extension Member.Grade {
    init(dto: String) {
        switch dto {
        case "gold":
            self = .gold
        case "silver":
            self = .silver
        case "bronze":
            self = .bronze
        default:
            self = .unknown(name: dto)
        }
    }
}

private extension Member {
    init(dto: SingleClient.ResponseDTO) {
        self = .init(
            id: dto.id,
            name: dto.name,
            grade: Member.Grade(dto: dto.grade)
        )
    }
}
