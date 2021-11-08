//
//  GithubRepository.swift
//  GitInsightHub
//
//  Created by Issac on 2021/11/08.
//

import Foundation
import RxSwift
import RxCocoa

class GithubRepository {
    let disposeBag = DisposeBag()
    let repositoryCoreDataStorage: DefaultRepositoryCoreDataStorage
    let networking: Networking
    
    init(repositoryCoreDataStorage: DefaultRepositoryCoreDataStorage, networking: Networking) {
        self.repositoryCoreDataStorage = repositoryCoreDataStorage
        self.networking = networking
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
                    print(#function, error)
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
