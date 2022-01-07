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
    
    let oauthAction: Action<Void, Void>
    let detailAction: Action<Repository, Void>
    
    override init(title: String = "", usecase: GithubAPI, sceneCoordinator: SceneCoordinatorType) {
        
        self.oauthAction = Action<Void, Void> {
            let oauthViewModel = OAuthViewModel(title: "", usecase: usecase, sceneCoordinator: sceneCoordinator)
            let oauthScene = Scene.oauth(oauthViewModel)
            
            return sceneCoordinator.transition(to: oauthScene, using: .root, animated: false).asObservable().mapToVoid()
        }
        
        self.detailAction = Action<Repository, Void> { repository in
            let detailViewModel = DetailViewModel(title: "Detail", usecase: usecase, sceneCoordinator: sceneCoordinator, repository: repository)
            let detailScene = Scene.detail(detailViewModel)
            
            return sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().mapToVoid()
        }
        
        super.init(title: title, usecase: usecase, sceneCoordinator: sceneCoordinator)
    }
    
    func transform(input: Input) -> Output {
        let refresh = PublishSubject<Bool>()
        
        let title = title.asDriver(onErrorJustReturn: "")
        
        let userRepository = Observable
            .combineLatest(input.repositoryRefresh, input.appearTrigger) { appear, _ in appear }
            .do(onNext: { refresh.onNext(true) })
            .flatMap({ self.usecase.getUserRepository() })
            .do(onNext: { _ in refresh.onNext(false) })
            .asDriver(onErrorJustReturn: [Repository]())
                
        let starredRepository = Observable
            .combineLatest(input.starredRefresh, input.appearTrigger) { appear, _ in appear }
            .do(onNext: { refresh.onNext(true) })
            .flatMap({ self.usecase.getStarred() })
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
    
    
}
