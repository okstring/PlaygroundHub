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
    
    init(githubRepository: GithubRepository = DefaultGithubRepository(repositoryCoreDataStorage: CoreDataStorage(), networkingProtocol: Networking())) {
        self.githubRepository = githubRepository
    }
    
    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectURI: String?) -> Single<Token> {
        return githubRepository.createAccessToken(endpoint: Endpoint.createAccessToken(clientId: clientId, clientSecret: clientSecret, code: code, redirectURI: redirectURI))
    }
    
    func getUser() -> Single<User> {
        return githubRepository.fetchUser()
    }
    
    func getUserRepository() -> Single<[Repository]> {
        return githubRepository.fetchRepository(endpoint: .repository, category: .user)
    }
    
    func getStarred() -> Single<[Repository]> {
        return githubRepository.fetchRepository(endpoint: .userStarred, category: .starred)
    }
    
    func getSearchRepositoryResult(query: String, page: Int) -> Single<[Repository]> {
        return githubRepository.fetchSearchRespotory(query: query, page: page)
    }
}