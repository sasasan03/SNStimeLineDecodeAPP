//
//  ContentView.swift
//  SNStimeLineDecode
//
//  Created by sako0602 on 2024/03/14.
//

import SwiftUI

// 🟦Post型をインスタンス化させるときは、ResponseDTOを使ってインスタンス化させる。
// 🟦Extensionを使って初期化の方法を決める。

//③
struct ResponseDTO: Decodable {
    let posts: [Post]
    
    struct Post: Decodable {
        let name: String // JSONで必要な構造
        let postType: String // JSONで必要な構造
        let textDetail: TextDetail?
        let imageDetail: ImageDetail?
        let textAndImageDetail: TextAndImageDetail?
        let questionnaire: Questionnaire?
        
        // JSONは、swiftのEnum型はないので、caseをstructで作る。
        struct TextDetail: Decodable {
            let text: String
        }
        struct ImageDetail: Decodable {
            let image: URL
        }
        struct TextAndImageDetail: Decodable {
            let text: String
            let image: URL
        }
        struct Questionnaire: Decodable {
            let coices: [String]
        }
    }
}


//① Entityを作成する
struct Post {
    let name: String
    let postType: PostType
}

//① Entityを作成する
enum PostType {
    case text(String)
    case image(URL)
    case textAndImage(String, URL)
    case questionnaire([String])
    case unknown(type: String)
    case invalid(reason: String)
}

// ResponseDTO型を受け取ってインスタンス化させる。
extension [Post] {
    init(dto: ResponseDTO) {
        self = dto.posts.map{ Post(dto: $0)} // ResponseDTOのデータの変換
    }
}

extension Post {
    init(dto: ResponseDTO.Post){
        self = Post(
            name: dto.name,
            postType: PostType(dto: dto)
        )
    }
}

// PostType（decode）
extension PostType {
    init(dto: ResponseDTO.Post){
        switch dto.postType {
        case "text":
            if let detail = dto.textDetail {
                self = .text(detail.text)
            } else {
                self = .invalid(reason: "detail in nil.")
            }
        case "image":
            if let detail = dto.imageDetail {
                self = .image(detail.image)
            } else {
                self = .invalid(reason: "detail in nil.")
            }
        case "textAndImage":
            if let detail = dto.textAndImageDetail {
                self = .textAndImage(detail.text, detail.image)
            } else {
                self = .invalid(reason: "detail in nil.")
            }
        case "Questionnaire":
            if let detail = dto.questionnaire {
                self = .questionnaire(detail.coices)
            } else {
                self = .invalid(reason: "detail in nil.")
            }
        default:
            self = .unknown(type: dto.postType)
        }
    }
}


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// 🍔必要に応じて実装する
//enum DecodingError {
//    case invalid(reson: String)
//}
// 🍔使用方法
//let posts: [Post] = [
//    .init(name: "A", postType: .text("爆睡")),
//    .init(name: "B", postType: .image(URL(string: "https://yahoo.co.jp")!))
//]
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

struct PostClient {
    func fetch() -> [Post]{
        let jsonData = """
        {
            "posts": [
                {
                    "name": "田中",
                    "postType": "text",
                    "textDetail": {
                        "text": "今日の晩御飯はカレー"
                    }
                },
                {
                    "name": "佐藤",
                    "postType": "image",
                    "imageDetail": {
                        "image": "https://yahoo.co.jp"
                    }
                },
                {
                    "name": "鈴木",
                    "postType": "textAndImage",
                    "textAndImageDetail": {
                        "text": "らーめん",
                        "image": "https://yahoo.co.jp"
                    }
                },
                {
                    "name": "中村",
                    "postType": "Questionnaire",
                    "questionnaire": {
                        "coices":["良い", "普通", "悪い"]
                    }
                },
                {
                    "name": "山下",
                    "postType": "NewVersion"
                }
            ]
        }
        """.data(using: .utf8)!
        
        do {
            let dto = try JSONDecoder().decode(ResponseDTO.self, from: jsonData)
            return dto.posts.map { Post(dto: $0) }
        } catch {
            print("🍟",error.localizedDescription)
            return []
        }
    }
}



// ---------------------------------------- View

struct ContentView: View {
    @State private var posts:[Post] = []
    
    var body: some View {
        Group {
            Text("Hello, world!")
            List(posts, id: \.name) { post in
                HStack{
                    Text("\(post.name)")
                    switch post.postType {
                    case .text(let text):
                        Text("\(text)")
                    case .image(let url):
                        Text("\(url)")
                    case .textAndImage(let text, let url):
                        VStack{
                            Text("\(text)")
                            Text("\(url)")
                        }
                    case .questionnaire(let choices):
                        HStack{
                            ForEach(choices, id: \.self){ choice in
                                Button("\(choice)"){ print("ボタンが押された")}
                            }
                        }
                    case .unknown(type: let type):
                        Text("\(type)")
                    case .invalid(reason: let reason):
                        Text("\(reason)")
                    }
                }
            }
            .onAppear{
                let client = PostClient()
                posts = client.fetch()
            }
        }
    }
}

// ---------------------------------------- View

#Preview {
    ContentView()
}
