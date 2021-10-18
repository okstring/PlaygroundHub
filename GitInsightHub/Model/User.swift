//
//  User.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import Foundation

struct User: Decodable {
    let id: Int
    let nickname: String
    let imageURL: String
    let name: String
    var identity: Int {
        return id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname = "login"
        case imageURL = "avatar_url"
        case name
    }
}
