//
//  ServerAPI.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import Alamofire

enum Endpoint {
    case searchRepository(query: String, page: Int)
    case user(name: String)
    case userRepository(name: String)
    case isStarred(name: String, repo: String)
    case putStarred(name: String, repo: String)
    case deleteStarred(name: String, repo: String)
    
    var baseURL: String {
        "https://api.github.com/"
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .searchRepository, .user, .userRepository, .isStarred:
            return .get
        case .putStarred:
            return .put
        case .deleteStarred:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .searchRepository:
            return "search/repositories"
        case .user(let user):
            return "users/\(user)"
        case .userRepository(name: let user):
            return "users/\(user)/repos"
        case .isStarred(name: let user, repo: let repository):
            return "user/starred/\(user)/\(repository)"
        case .putStarred(name: let user, repo: let repository):
            return "user/starred/\(user)/\(repository)"
        case .deleteStarred(name: let user, repo: let repository):
            return "user/starred/\(user)/\(repository)"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .searchRepository, .user, .userRepository, .isStarred, .putStarred, .deleteStarred:
            return [
                HTTPHeader(name: "Accept", value: "application/vnd.github.mercy-preview+json"),
                HTTPHeader(name: "User-Agent", value: "request")
            ]
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .searchRepository(let query, let page):
            return [
                "q": query,
                "page": page
            ]
        case .user, .userRepository, .isStarred, .putStarred, .deleteStarred:
            return [:]
        }
    }
}

extension Endpoint {
    var URL: String {
        return "\(baseURL)\(path)"
    }
}
