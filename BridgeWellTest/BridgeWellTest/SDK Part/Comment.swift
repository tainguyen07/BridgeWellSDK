//
//  Post.swift
//  BridgeWell
//
//  Created by Tai Nguyen on 06/01/2024.
//

import Foundation

struct Comment: Decodable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
    private enum CodingKeys: String, CodingKey {
        case postId, id, name, email, body
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postId = try container.decode(Int.self, forKey: .postId)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        body = try container.decode(String.self, forKey: .body)
    }
}

