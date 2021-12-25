//
//  ProfileViewModel.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/21.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class ProfileViewModel: ViewModel, ViewModelType {
    struct Input {
        let appearTrigger: Observable<Void>
        let repositoryRefresh: Observable<Void>
        let starredRefresh: Observable<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let userRepository: Driver<[Repository]>
        let starredRespository: Driver<[Repository]>
        let isRefresh: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let usecase = usecase
        let refresh = PublishSubject<Bool>()
        
        let title = title.asDriver(onErrorJustReturn: "")
        
        let userRepository = Observable
            .combineLatest(input.repositoryRefresh, input.appearTrigger) { appear, _ in appear }
            .do(onNext: { refresh.onNext(true) })
            .flatMap{ usecase.getUserRepository() }
            .do(onNext: { _ in refresh.onNext(false) })
            .asDriver(onErrorJustReturn: [Repository]())
                
        let starredRepository = Observable
            .combineLatest(input.starredRefresh, input.appearTrigger) { appear, _ in appear }
            .do(onNext: { refresh.onNext(true) })
            .flatMap({ usecase.getStarred() })
            .do(onNext: { _ in refresh.onNext(false) })
            .asDriver(onErrorJustReturn: [Repository]())
                
        let isRefresh = refresh.distinctUntilChanged()
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
                
        return Output(title: title,
                      userRepository: userRepository,
                      starredRespository: starredRepository,
                      isRefresh: isRefresh)
    }
    
    lazy var detailAction: Action<Repository, Void> = {
        return Action { repository in
            
            let detailViewModel = DetailViewModel(title: "Detail", usecase: self.usecase, sceneCoordinator: self.sceneCoordinator, repository: repository)
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().mapToVoid()
        }
    }()
}
