//
//  Repository.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/24.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let title: String
    let fullTitle: String
    let repositoryDescription: String
    let topics: [String]
    let starCount: Int
    let language: String
    let loginName: String
    let isStarred: Bool
    var identity: Int {
        return id
    }
    
    var abbreviateStarCount: String {
        let count = String(starCount).count
        if count > 4 {
            return "\(starCount / 1000)k"
        } else {
            return "\(starCount.decimal)"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.fullTitle = try container.decode(String.self, forKey: .fullTitle)
        self.repositoryDescription = try container.decodeIfPresent(String.self, forKey: .repositoryDescription) ?? ""
        self.topics = try container.decodeIfPresent([String].self, forKey: .topics) ?? [String]()
        self.starCount = try container.decode(Int.self, forKey: .starCount)
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        self.isStarred = try container.decodeIfPresent(Bool.self, forKey: .isStarred) ?? false
        let ownerContainer = try container.nestedContainer(keyedBy: OwnerInfoKeys.self, forKey: .owner)
        self.loginName = try ownerContainer.decode(String.self, forKey: .loginName)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case fullTitle = "full_name"
        case repositoryDescription = "description"
        case topics
        case starCount = "stargazers_count"
        case language
        case license
        case owner
        case isStarred
    }
    
    enum OwnerInfoKeys: String, CodingKey {
        case loginName = "login"
        case starredURL = "starred_url"
    }
}

