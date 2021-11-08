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
    
    func fetchRepository(endpoint: Endpoint, category: RepositoryCagetory) -> Single<[Repository]>
}

class DefaultGithubRepository: GithubRepository {
    let disposeBag = DisposeBag()
    let repositoryCoreDataStorage: CoreDataStorage
    let networking: Networking
    
    init(repositoryCoreDataStorage: CoreDataStorage, networking: Networking) {
        self.repositoryCoreDataStorage = repositoryCoreDataStorage
        self.networking = networking
    }
    
    
    func createAccessToken(endpoint: Endpoint) -> Single<Token> {
        return networking.createAccessToken(endpoint: endpoint)
    }
    
    func fetchUser() -> Single<User> {
        return networking.request(type: User.self, endpoint: .user)
    }
    
    
    func fetchRepository(endpoint: Endpoint, category: RepositoryCagetory) -> Single<[Repository]> {
        return Single.create() { single in
            
            self.networking.request(type: [Repository].self, endpoint: endpoint)
                .subscribe(onSuccess: { repositories in
                    
                    for repository in repositories {
                        self.repositoryCoreDataStorage.saveRepository(repository: repository, category: category)
                    }
                    
                    return single(.success(repositories))
                    
                }, onFailure: { error in
                    #if DEBUG
                    print(#function, error, category, endpoint)
                    #endif
                    
                    self.repositoryCoreDataStorage.getLocalRepositoryList(category: category)
                        .subscribe(onSuccess: { repositories in
                            return single(.success(repositories))
                        }, onFailure: { error in
                            return single(.failure(error))
                        }).disposed(by: self.disposeBag)
                    
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
    }
}
