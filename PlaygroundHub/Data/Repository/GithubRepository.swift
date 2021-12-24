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
    
    func fetchRepository(endpoint: Endpoint) -> Single<[Repository]>
    
    func fetchSearchRespotory(query: String, page: Int) -> Single<[Repository]>
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
    
    func fetchSearchRespotory(query: String, page: Int) -> Single<[Repository]> {
        return networkingProtocol.request(type: SearchRepository.self, endpoint: .searchRepository(query: query, page: page))
            .map({ $0.items })
    }
    
    
    func fetchRepository(endpoint: Endpoint) -> Single<[Repository]> {
        return Single.create() { single in
            
            self.networkingProtocol.request(type: [Repository].self, endpoint: endpoint)
                .subscribe(onSuccess: { repositories in
                    return single(.success(repositories))
                    
                }, onFailure: { error in
                    #if DEBUG
                    print(#function, error, endpoint)
                    #endif
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
    }
}
