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
    let networking: Networking
    
    init(networking: Networking = Networking(),
         githubRepository: GithubRepository = DefaultGithubRepository(repositoryCoreDataStorage: CoreDataStorage(), networking: Networking())) {
        self.networking = networking
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
}
