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
    let imageData: Data
    let followers: Int
    let following: Int
    var identity: Int {
        return id
    }
    
    internal init(id: Int, nickname: String, imageURL: String, name: String, imageData: Data, following: Int, followers: Int) {
        self.id = id
        self.nickname = nickname
        self.imageURL = imageURL
        self.imageData = imageData
        self.followers = followers
        self.following = following
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.imageData = try container.decodeIfPresent(Data.self, forKey: .imageData) ?? Data()
        self.following = try container.decode(Int.self, forKey: .following)
        self.followers = try container.decode(Int.self, forKey: .followers)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname = "login"
        case imageURL = "avatar_url"
        case imageData
        case followers
        case following
    }
}

extension User {
    static var EMPTY: User {
        return User.init(id: 0, nickname: "", imageURL: "", name: "", imageData: Data(), following: 0, followers: 0)
    }
}
