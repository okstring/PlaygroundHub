//
//  UseCase.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/18.
//

import Foundation
import RxSwift


class Usecase: GithubAPI {
    let githubRepository: GithubRepository
    
    init(githubRepository: GithubRepository = DefaultGithubRepository(networkingProtocol: Networking())) {
        self.githubRepository = githubRepository
    }
    
    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectURI: String?) -> Single<Token> {
        return githubRepository.createAccessToken(endpoint: Endpoint.createAccessToken(clientId: clientId, clientSecret: clientSecret, code: code, redirectURI: redirectURI))
    }
    
    func getUser() -> Single<User> {
        return githubRepository.fetchUser()
    }
    
    func getUserRepository() -> Single<[Repository]> {
        return githubRepository.fetchRepositories(endpoint: .repositories)
    }
    
    func getStarred() -> Single<[Repository]> {
        return githubRepository.fetchRepositories(endpoint: .userStarred)
    }
    
    func getSearchRepositoryResult(query: String, page: Int) -> Single<[Repository]> {
        return githubRepository.fetchSearchRespotory(query: query, page: page)
    }
    
    func getRepsitory(name: String, repo: String) -> Single<Repository> {
        return githubRepository.fetchRepository(endpoint: .repository(name: name, repo: repo))
    }
}
