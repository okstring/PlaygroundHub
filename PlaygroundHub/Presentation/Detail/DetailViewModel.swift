//
//  DetaioViewModel.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2021/12/25.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel: ViewModel, ViewModelType  {
    let disposeBag = DisposeBag()
    struct Input {
        let appearTrigger: Observable<Bool>
    }
    
    struct Output {
        let repository: Driver<Repository>
    }
    
    let repository: BehaviorSubject<Repository>
    
    init(title: String, usecase: GithubAPI, sceneCoordinator: SceneCoordinatorType, repository: Repository) {
        self.repository = BehaviorSubject<Repository>(value: repository)
        super.init(title: title, usecase: usecase, sceneCoordinator: sceneCoordinator)
    }
    
    
    func transform(input: Input) -> Output {
        
        let repository = input.appearTrigger
            .withLatestFrom(repository) { $1 }
            .flatMap({ self.usecase.getRepsitory(name: $0.loginName, repo: $0.title) })
            .asDriver(onErrorJustReturn: Repository.EMPTY)
            
        
        return Output(repository: repository)
    }
}
