//
//  ListClient.swift
//  DecodeExample
//
//  Created by akio0911 on 2024/02/21.
//

import Foundation

struct ListClient {
    struct ResponseDTO: Decodable {
        struct Kaiin: Decodable {
            let id: Int
            let name: String
            let grade: String
        }

        let members: [Kaiin]
    }

    func fetch() throws -> [Member] {
        let jsonData = """
        {
            "members": [
                {
                    "id": 111,
                    "name": "sako 1",
                    "grade": "gold"
                },
                {
                    "id": 222,
                    "name": "sako 2",
                    "grade": "silver"
                },
                {
                    "id": 333,
                    "name": "sako 3",
                    "grade": "platina"
                }
            ]
        }
        """.data(using: .utf8)!
        // DTO型でデコードする
        let dto = try JSONDecoder().decode(ResponseDTO.self, from: jsonData)
        // Member型の初期化方法を拡張し、dtoでデコードしたものをMember型に変換する
        return [Member](dto: dto.members)
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
    init(dto: ListClient.ResponseDTO.Kaiin) {
        self = .init(
            id: dto.id,
            name: dto.name,
            grade: Member.Grade(dto: dto.grade)
        )
    }
}

private extension [Member] {
    init(dto: [ListClient.ResponseDTO.Kaiin]) {
        self = dto.map { Member(dto: $0) }
    }
}
