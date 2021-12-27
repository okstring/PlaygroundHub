//
//  ServerAPI.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import Alamofire

enum Endpoint {
    case createAccessToken(clientId: String, clientSecret: String, code: String, redirectURI: String?)
    case searchRepository(query: String, page: Int)
    case user
    case repository(name: String, repo: String)
    case repositories
    case userStarred
    case userRepositories(name: String)
    case isStarred(name: String, repo: String)
    case putStarred(name: String, repo: String)
    case deleteStarred(name: String, repo: String)
    
    var baseURL: String {
        "https://api.github.com/"
    }
    
    var createAccessTokenURL: String {
        "https://github.com/login/oauth/access_token"
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .repository, .searchRepository, .user, .userRepositories, .isStarred, .repositories, .userStarred:
            return .get
        case .createAccessToken:
            return .post
        case .putStarred:
            return .put
        case .deleteStarred:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createAccessToken:
            return ""
        case .searchRepository:
            return "search/repositories"
        case .user:
            return "user"
        case .repositories:
            return "user/repos"
        case .userStarred:
            return "user/starred"
        case .repository(name: let user, repo: let repository):
            return "repos/\(user)/\(repository)"
        case .userRepositories(name: let user):
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
        var headers = HTTPHeaders()
        if let token = AuthManager.shared.token {
            headers.add(HTTPHeader(name: "Authorization", value: "token \(token.accessToken)"))
        }
        
        switch self {
        case .searchRepository, .user, .userRepositories, .isStarred, .putStarred, .deleteStarred, .repositories, .userStarred, .repository:
            headers.add(HTTPHeader(name: "Accept", value: "application/vnd.github.v3+json"))
            headers.add(HTTPHeader(name: "User-Agent", value: "request"))
        case .createAccessToken:
            headers.add(HTTPHeader(name: "Accept", value: "application/json"))
        }
        
        return headers
    }
    
    var parameters: [String: Any] {
        switch self {
        case .searchRepository(let query, let page):
            return [
                "q": query,
                "page": page
            ]
        case .createAccessToken(let clientId, let clientSecret, let code, let redirectURI):
            return [
                "client_id": clientId,
                "client_secret": clientSecret,
                "code": code,
                "redirect_uri": redirectURI ?? ""
            ]
        case .userRepositories, .userStarred:
            return [
                "sort": "updated",
                "per_page": 100
            ]
        case .user, .isStarred, .putStarred, .deleteStarred, .repositories, .repository:
            return [:]
        }
    }
}

extension Endpoint {
    var URL: String {
        return "\(baseURL)\(path)"
    }
}
