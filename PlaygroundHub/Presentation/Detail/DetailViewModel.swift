//
//  DetaioViewModel.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2021/12/25.
//

import Foundation
import RxSwift

class DetailViewModel: ViewModel, ViewModelType  {
    let disposeBag = DisposeBag()
    struct Input {
        let appearTrigger: Observable<Bool>
    }
    
    struct Output {
        let repository: Observable<Repository>
    }
    
    let repository: Repository
    
    init(title: String, usecase: GithubAPI, sceneCoordinator: SceneCoordinatorType, repository: Repository) {
        self.repository = repository
        super.init(title: title, usecase: usecase, sceneCoordinator: sceneCoordinator)
    }
    
    
    func transform(input: Input) -> Output {
        let selectedRepository = repository
        
        let repository = input.appearTrigger
            .map{ _ in selectedRepository }
        
        return Output(repository: repository)
    }
}
