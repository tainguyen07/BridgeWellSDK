//
//  Post.swift
//  BridgeWell
//
//  Created by Tai Nguyen on 06/01/2024.
//

import Foundation

class Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    var comments: [Comment] = []
    
    private enum CodingKeys: String, CodingKey {
        case userId, id, title, body
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(Int.self, forKey: .userId)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
    }
}

