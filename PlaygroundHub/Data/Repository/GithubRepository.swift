//
//  GithubRepository.swift
//  GitInsightHub
//
//  Created by Issac on 2021/11/08.
//

import Foundation
import RxSwift
import RxCocoa

protocol GithubRepository {
    
    func createAccessToken(endpoint: Endpoint) -> Single<Token>
    
    func fetchUser() -> Single<User>
    
    func fetchRepository(endpoint: Endpoint) -> Single<Repository>
    
    func fetchSearchRespotory(endpoint: Endpoint) -> Single<[Repository]>
    
    func fetchRepositories(endpoint: Endpoint) -> Single<[Repository]>
}

class DefaultGithubRepository: GithubRepository {
    let disposeBag = DisposeBag()
    let networkingProtocol: NetworkingProtocol
    
    init(networkingProtocol: NetworkingProtocol) {
        self.networkingProtocol = networkingProtocol
    }
    
    func createAccessToken(endpoint: Endpoint) -> Single<Token> {
        return networkingProtocol.createAccessToken(endpoint: endpoint)
    }
    
    func fetchUser() -> Single<User> {
        return networkingProtocol.request(type: User.self, endpoint: .user)
    }
    
    func fetchRepository(endpoint: Endpoint) -> Single<Repository> {
        return networkingProtocol.request(type: Repository.self, endpoint: endpoint)
            
    }
    
    func fetchSearchRespotory(endpoint: Endpoint) -> Single<[Repository]> {
        return networkingProtocol.request(type: SearchRepository.self, endpoint: endpoint)
            .map({ $0.items })
    }
    
    
    func fetchRepositories(endpoint: Endpoint) -> Single<[Repository]> {
        return Single.create() { single in
            
            self.networkingProtocol.request(type: [Repository].self, endpoint: endpoint)
                .subscribe(onSuccess: { repositories in
                    return single(.success(repositories.sorted(by: { $0.updatedAt > $1.updatedAt })))
                    
                }, onFailure: { error in
                    #if DEBUG
                    print(#function, error, endpoint)
                    #endif
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
    }
}
