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
    let profileImageURL: String
    let forkCount: Int
    let updatedAt: Date
    var identity: Int {
        return id
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
        self.forkCount = try container.decode(Int.self, forKey: .forkCount)
        self.updatedAt =  try container.decode(Date.self, forKey: .updatedAt)
        let ownerContainer = try container.nestedContainer(keyedBy: OwnerInfoKeys.self, forKey: .owner)
        self.loginName = try ownerContainer.decode(String.self, forKey: .loginName)
        self.profileImageURL = try ownerContainer.decode(String.self, forKey: .profileImageURL)
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
        case forkCount = "forks_count"
        case updatedAt = "updated_at"
    }
    
    enum OwnerInfoKeys: String, CodingKey {
        case loginName = "login"
        case starredURL = "starred_url"
        case profileImageURL = "avatar_url"
    }
    
    init(id: Int, title: String, fullTitle: String, repositoryDescription: String, topics: [String], starCount: Int, language: String, loginName: String, isStarred: Bool, profileImageURL: String, forkCount: Int, updatedAt: Date) {
        self.id = id
        self.title = title
        self.fullTitle = fullTitle
        self.repositoryDescription = repositoryDescription
        self.topics = topics
        self.starCount = starCount
        self.language = language
        self.loginName = loginName
        self.isStarred = isStarred
        self.profileImageURL = profileImageURL
        self.forkCount = forkCount
        self.updatedAt = updatedAt
    }
}

